//
//  SearchViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit

class SearchViewController: UIViewController, SongsCellDelegate {
    
    var collectionView: UICollectionView!
    let searchController = UISearchController(searchResultsController: nil)
    typealias SearchDataSource = UICollectionViewDiffableDataSource<Int, Song>
    typealias SongsSnapshot = NSDiffableDataSourceSnapshot<Int, Song>
    var dataSource: SearchDataSource?
    var musicController: MusicController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        configureCollectionView()
        createDataSource()
    }
    
    private func setUpViews() {
        view.backgroundColor = .backgroundColor
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Albums, Artists, or Songs"
        searchController.searchBar.barStyle = .black
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        navigationItem.searchController = searchController
        self.navigationController?.navigationBar.barTintColor = .systemGray6
        navigationController?.navigationBar.topItem?.title = "Search"
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createCompLayout())
        collectionView.register(SongsCollectionViewCell.self, forCellWithReuseIdentifier: SongsCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with song: Song, for indexPath: IndexPath) -> T {
        guard var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell: \(cellType)")
        }
        let song = APIController.shared.searchedSongs[indexPath.item]
        cell.configure(with: song)
        cell.delegate = self
        return cell
    }
    
    private func createDataSource() {
        dataSource = SearchDataSource(collectionView: collectionView) { collectionView, indexPath, song in
            self.configure(SongsCollectionViewCell.self, with: song, for: indexPath)
        }
    }
    
    func reloadData() {
        var snapshot = SongsSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(APIController.shared.searchedSongs)
        dataSource?.apply(snapshot)
    }
    
    private func createSongsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .absolute(UIScreen.main.bounds.width / 5))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 12)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(UIScreen.main.bounds.width / 4.5))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
    
    private func createCompLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return self.createSongsSection()
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
        var song = musicController.searchedSongs[indexPath.item]
        APIController.shared.fetchImage(song: song, size: 500) { result in
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
