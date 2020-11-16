//
//  SearchViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit
import Combine

class SearchViewController: UIViewController, SearchCellDelegate {
    
    var collectionView: UICollectionView!
    lazy var searchController = UISearchController(searchResultsController: nil)
    typealias SearchDataSource = UICollectionViewDiffableDataSource<Section, Media>
    typealias SearchSnapshot = NSDiffableDataSourceSnapshot<Section, Media>
    var dataSource: SearchDataSource?
    var musicController: MusicController!
    weak var coordinator: MainCoordinator?
    var cancellable = [AnyCancellable]()
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        configureCollectionView()
        createDataSource()
        setupSearchBarListeners()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    private func setupSearchBarListeners() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        publisher.map({
            ($0.object as! UISearchTextField).text
        })
        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
        .removeDuplicates()
        .sink(receiveValue: { searchTerm in
            DispatchQueue.global(qos: .userInteractive).async {
                APIController.shared.searchForMedia(with: searchTerm ?? "") { result in
                    switch result {
                    case .success(let searchedMedia):
                        let songs = searchedMedia.songs
                        let albums = searchedMedia.albums
                        var mediaFromSearch = [Media]()
                        var songsArray = [Media]()
                        var albumsArray = [Media]()
                        songs.forEach {
                            let songMedia = Media(stringURL: $0.stringURL, mediaType: .song, media: $0)
                            songsArray.append(songMedia)
                            mediaFromSearch.append(songMedia)
                        }
                        albums.forEach {
                            let albumMedia = Media(stringURL: $0.stringURL, mediaType: .album, media: $0)
                            albumsArray.append(albumMedia)
                            mediaFromSearch.append(albumMedia)
                        }
                        self.musicController?.searchedMedia = mediaFromSearch
                        self.musicController.searchedSongs = songsArray
                        self.musicController.searchedAlbums = albumsArray
                        DispatchQueue.main.async {
                            self.reloadData()
                        }
                    case .failure(let error):
                        print("Error fetching songs for searchTerm: \(error.localizedDescription)")
                    }
                }
            }
        })
        .store(in: &cancellable)
    }
  
    private func setUpViews() {
        view.backgroundColor = .backgroundColor
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Albums, Artists, or Songs"
//        searchController.searchBar.sizeToFit()
        searchController.searchBar.barTintColor = UIColor.backgroundColor?.withAlphaComponent(0.4)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.backgroundColor = .clear
        navigationItem.searchController?.view.backgroundColor = .clear
        navigationItem.searchController?.view.layer.cornerRadius = 20
        navigationItem.searchController?.searchResultsController?.view.backgroundColor = .clear
        navigationItem.searchController?.searchResultsController?.view.layer.cornerRadius = 20
        navigationItem.searchController?.searchBar.layer.cornerRadius = 20
        navigationItem.searchController?.searchBar.barTintColor = .clear
        navigationItem.searchController?.searchBar.searchBarStyle = .minimal
        navigationItem.searchController?.searchBar.barTintColor = .clear
        searchController.view.backgroundColor = .clear
        searchController.searchBar.backgroundColor = .clear
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.topItem?.title = "Search"
        view.layer.cornerRadius = 20
        navigationController?.navigationBar.layer.cornerRadius = 20
        navigationController?.navigationBar.layer.cornerRadius = 20
        searchController.view.layer.cornerRadius = 20
        searchController.searchBar.layer.cornerRadius = 20
        navigationController?.view.backgroundColor = .clear
        searchController.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        searchController.searchBar.backgroundImage = UIImage()
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createCompLayout())
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        collectionView.register(SongsCollectionViewCell.self, forCellWithReuseIdentifier: SongsCollectionViewCell.identifier)
        collectionView.register(AlbumsCollectionViewCell.self, forCellWithReuseIdentifier: AlbumsCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsVerticalScrollIndicator = false
        collectionView.layer.cornerRadius = 20
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collectionView.delegate = self
    }
    
    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with media: Media, for indexPath: IndexPath) -> T {
        guard var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell: \(cellType)")
        }
        cell.configure(with: media)
       
        cell.delegate = self
        return cell
    }
    
    func createDataSource() {
        dataSource = SearchDataSource(collectionView: collectionView) { collectionView, indexPath, media in
            switch self.sections[indexPath.section].mediaType {
            case .song:
                return self.configure(SongsCollectionViewCell.self, with: media, for: indexPath)
            case .album:
                return self.configure(AlbumsCollectionViewCell.self, with: media, for: indexPath)
            default:
                return self.configure(SongsCollectionViewCell.self, with: media, for: indexPath)
            }
        }
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as? SectionHeader else {
                return nil
            }
            
            guard let media = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: media) else { return nil }

            sectionHeader.titleLabel.text = section.mediaType.rawValue
            return sectionHeader
        }
    }
    
    func reloadData() {
        var snapshot = SearchSnapshot()
        let songSection = Section(mediaType: .song, media: musicController.searchedSongs)
        let albumSection = Section(mediaType: .album, media: musicController.searchedAlbums)
        let sections = [albumSection, songSection]
        self.sections = sections
        snapshot.appendSections(sections)
        sections.forEach {
            snapshot.appendItems($0.media, toSection: $0)
        }
        dataSource?.apply(snapshot)
    }
    
//    private func createSongsSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .absolute(UIScreen.main.bounds.width / 5))
//        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
//        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 12)
//        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(UIScreen.main.bounds.width / 4.5))
//        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
//        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//        return layoutSection
//    }
    
//    private func createSongsSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33))
//        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
//        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
//        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width - 40), heightDimension: .fractionalWidth(0.6))
//        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
//        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 70, trailing: 20)
//        layoutSection.interGroupSpacing = 8
//        let laytoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width - 40), heightDimension: .fractionalWidth(0.12))
//        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: laytoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
//        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
//        return layoutSection
//    }
    
    private func createSongsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(UIScreen.main.bounds.width / 5))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(2.5))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        let laytoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width - 40), heightDimension: .fractionalWidth(0.12))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: laytoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }
    
//    private func createAlbumSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
//        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
//        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width / 2), heightDimension: .fractionalWidth(0.5))
//        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
//        let laytoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalWidth(0.12))
//        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: laytoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
//        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
//        return layoutSection
//    }
    
    private func createAlbumSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .absolute((UIScreen.main.bounds.width - 48) / 2), heightDimension: .fractionalWidth(0.55))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let laytoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width - 40), heightDimension: .fractionalWidth(0.12))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: laytoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        layoutSection.interGroupSpacing = 8
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return layoutSection
    }
    
    private func createCompLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.sections[sectionIndex]
            switch section.mediaType {
            case .song:
                return self.createSongsSection()
            case .album:
                return self.createAlbumSection()
            default:
                return self.createSongsSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 8
        layout.configuration = config
        return layout
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func addSongTapped(cell: SongsCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var song = musicController.searchedSongs[indexPath.item].media as! Song
        APIController.shared.fetchImage(mediaItem: song, size: 500) { result in
            switch result {
            case .success(let imageData):
                song.albumArtwork = imageData
            case .failure(let error):
                print("Error fetching image data: \(error)")
            }
        }
        musicController.addSongToPlaylist(song: song)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            musicController.musicPlayer.stop()
            let media = musicController.searchedSongs[indexPath.item]
            if var song = media.media as? Song {
                APIController.shared.fetchImage(mediaItem: song, size: 500) { result in
                    switch result {
                    case .success(let imageData):
                        song.albumArtwork = imageData
                        self.musicController.musicPlayer.setQueue(with: [song.playID])
                        self.musicController.nowPlayingViewModel.searchedSong = song
                        self.musicController.play()
                        self.musicController.nowPlayingViewModel.playingMediaType = .singleSong
                    case .failure(let error):
                        print("Error fetching image data: \(error)")
                    }
                }
            }
        default:
            break
        }
    }
}
