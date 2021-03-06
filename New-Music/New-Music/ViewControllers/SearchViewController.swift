//
//  SearchViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI
import Combine

class SearchViewController: UIViewController, UISearchBarDelegate, SearchCellDelegate {
	
    var collectionView: UICollectionView!
    lazy var searchController = UISearchController(searchResultsController: nil)
    typealias SearchDataSource = UICollectionViewDiffableDataSource<Section, Media>
    typealias SearchSnapshot = NSDiffableDataSourceSnapshot<Section, Media>
    var dataSource: SearchDataSource?
    var musicController: MusicController!
    weak var coordinator: MainCoordinator?
    var cancellable = [AnyCancellable]()
    var isPlaylistSearch: Bool
    var sections = [Section]()
    weak var reloadDataDelegate: ReloadDataDelegate?
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.setSize(width: UIScreen.main.bounds.width, height: 1)
        return view
    }()
	
	lazy var tapGesture: UITapGestureRecognizer = {
		let tapGesture = UITapGestureRecognizer()
		tapGesture.addTarget(self, action: #selector(setSearchControllerInactive))
		return tapGesture
	}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setUpViews()
        setupSearchBarListeners()
        createDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func setupSearchBarListeners() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        publisher.map({
            ($0.object as! UISearchTextField).text
        })
        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
        .removeDuplicates()
        .sink(receiveValue: { [weak self] searchTerm in
            guard let self = self else { return }
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
        navigationController?.navigationBar.topItem?.title = isPlaylistSearch ? "Add Songs to Playlist" : "Search"
        if isPlaylistSearch {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPlaylistCreation))
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finishedAddingSongsToPlaylist))
        }
        view.layer.cornerRadius = 20
        navigationController?.navigationBar.layer.cornerRadius = 20
        navigationController?.navigationBar.layer.cornerRadius = 20
        searchController.view.layer.cornerRadius = 20
        searchController.searchBar.layer.cornerRadius = 20
        navigationController?.view.backgroundColor = .clear
        searchController.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        searchController.searchBar.backgroundImage = UIImage()
		searchController.searchBar.delegate = self
        if !isPlaylistSearch {
            view.addSubview(separatorView)
            separatorView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.centerXAnchor)
        }
		navigationController?.view.addGestureRecognizer(tapGesture)
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompLayout())
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
//        collectionView.contentInset.left = 20
//        collectionView.contentInset.right = 20
        if !isPlaylistSearch {
            collectionView.contentInset.bottom = UIScreen.main.bounds.width / 8
        }
    }
    
    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with media: Media, for indexPath: IndexPath, isListCell: Bool) -> T {
        if isListCell {
            let song = media.media as! Song
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.makeSongsSearchedCellRegistration(), for: indexPath, item: song)
            cell.song = song
            cell.delegate = self
            return cell as! T
        } else {
            guard var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
                fatalError("Unable to dequeue cell: \(cellType)")
            }
            cell.configure(with: media)
            cell.delegate = self
            return cell
        }
    }
    
    private func createDataSource() {
        dataSource = SearchDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, media in
            switch self?.sections[indexPath.section].mediaType {
            case .song:
                return self?.configure(SongsSearchedCollectionViewCell.self, with: media, for: indexPath, isListCell: true)
            case .album:
                return self?.configure(AlbumsCollectionViewCell.self, with: media, for: indexPath, isListCell: false)
            default:
                return self?.configure(SongsCollectionViewCell.self, with: media, for: indexPath, isListCell: false)
            }
        }
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            if indexPath.section == 0 {
                guard
                    let media = self.dataSource?.itemIdentifier(for: indexPath),
                    let section = self.dataSource?.snapshot().sectionIdentifier(containingItem: media),
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as? SectionHeader
                else { return nil }
                sectionHeader.backgroundColor = .clear
                sectionHeader.titleLabel.text = section.mediaType.rawValue
				
                return sectionHeader
            } else {
                let sectionHeader = collectionView.dequeueConfiguredReusableSupplementary(using: (self.makeSearchedSongHeaderRegistration()), for: indexPath)
				
                return sectionHeader
            }
        }
    }
    
    private func reloadData() {
        var snapshot = SearchSnapshot()
        let songSection = Section(mediaType: .song, media: musicController.searchedSongs)
        let albumSection = Section(mediaType: .album, media: musicController.searchedAlbums)
        let sections = [albumSection, songSection]
        musicController.sections = sections
        self.sections = sections
        snapshot.appendSections(sections)
        sections.forEach {
            snapshot.appendItems($0.media, toSection: $0)
        }
        dataSource?.apply(snapshot)
    }
    
    private func createSongsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(UIScreen.main.bounds.width / 5))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(UIScreen.main.bounds.width / 5))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        let laytoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width - 40), heightDimension: .fractionalWidth(0.12))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: laytoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        if isPlaylistSearch {
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        } else {
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        }
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }
    
    private func makeSongsSearchedCellRegistration() -> UICollectionView.CellRegistration<SongsSearchedCollectionViewCell, Song> {
        let playlistCellRegistration = UICollectionView.CellRegistration<SongsSearchedCollectionViewCell, Song> { cell, indexPath, song in
            cell.song = song
            cell.delegate = self
        }
        return playlistCellRegistration
    }
    
    private func makeSearchedSongHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        let playlistHeaderRegistration = UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] (header: UICollectionViewListCell, string, indexPath) in
            var config = header.defaultContentConfiguration()
            guard
                let media = self?.dataSource?.itemIdentifier(for: indexPath),
                let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: media)
            else { return }
            config.secondaryText = section.mediaType.rawValue
            config.secondaryTextProperties.color = .white
            config.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .headline).withSize(25)
            header.contentConfiguration = config
        }
        return playlistHeaderRegistration
    }
    
    private func createAlbumSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .absolute((UIScreen.main.bounds.width - 48) / 2), heightDimension: .fractionalWidth(0.55))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let laytoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .fractionalWidth(0.12))
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
                var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
                layoutConfig.backgroundColor = .backgroundColor
                layoutConfig.headerMode = .supplementary
                return NSCollectionLayoutSection.list(using: layoutConfig, layoutEnvironment: layoutEnvironment)
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
    
    func addSongTapped(cell: SongsSearchedCollectionViewCell) {
		guard let song = cell.song else { return }
		if isPlaylistSearch {
			musicController.createPlaylistSongs.append(song)
		} else {
			coordinator?.presentSettingsVC(viewController: self, song: song)
		}
    }
	
	func newPlaylistCreation(with song: Song) {
		musicController.createPlaylistSongs.append(song)
	}
    
    @objc private func cancelPlaylistCreation() {
        self.dismiss(animated: true, completion: nil)
    }
	
	@objc private func finishedAddingSongsToPlaylist() {
		reloadDataDelegate?.applySnapshot()
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc private func setSearchControllerInactive() {
		searchController.isActive = false
	}
    
    init(isPlaylistSearch: Bool) {
        self.isPlaylistSearch = isPlaylistSearch
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard is horrible")
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
                        let playlist = Playlist(playlistName: "", songs: [song])
                        self.musicController.nowPlayingPlaylist = playlist
                        self.musicController.musicPlayer.setQueue(with: [song.playID])
                        self.musicController.nowPlayingViewModel.nowPlayingSong = song
                        self.musicController.play()
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
