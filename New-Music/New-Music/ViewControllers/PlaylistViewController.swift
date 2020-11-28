//
//  PlaylistViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI
import Combine

class PlaylistViewController: UIViewController, ReloadDataDelegate, SetPlaylistDelegate {
    
    private var subscriptions = Set<AnyCancellable>()
    private var nowPlayingViewModel: NowPlayingViewModel!
    typealias PlaylistsDataSource = UICollectionViewDiffableDataSource<Playlist, PlaylistMedia>
//    typealias PlaylistsDataSource = UICollectionViewDiffableDataSource<Playlist, Song>
    typealias PlaylistSnapshot = NSDiffableDataSourceSnapshot<Playlist, PlaylistMedia>
//    typealias PlaylistSnapshot = NSDiffableDataSourceSnapshot<Playlist, Song>
    var musicController: MusicController!
    weak var coordinator: MainCoordinator?
    let artistLabel = UILabel()
    var backgroundColor: UIColor?
    
    lazy var collectionView: UICollectionView = {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        layoutConfig.headerMode = .supplementary
        layoutConfig.backgroundColor = .backgroundColor
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let cv = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        cv.backgroundColor = .clear
        cv.contentInset.bottom = 60
        cv.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        cv.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        return cv
    }()
    
    let playlistCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Playlist> { cell, indexPath, playlist in
        var content = cell.defaultContentConfiguration()
        content.text = playlist.playlistName
        cell.contentConfiguration = content
        let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .cell, isHidden: false, tintColor: .white)
        cell.accessories = [.outlineDisclosure(displayed: .always, options: headerDisclosureOption, actionHandler: .none)]
    }
    
    
    lazy var dataSource: PlaylistsDataSource = {
        let dataSource = PlaylistsDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, playlistMedia -> UICollectionViewCell? in
            guard let self = self else { fatalError() }
            switch playlistMedia {
            case .playlist(let playlist):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath) as! PlaylistCollectionViewCell
                cell.playlist = playlist
                cell.setPlaylistDelegate = self
                return cell
            case .song(let song):
                let cell = collectionView.dequeueConfiguredReusableCell(using: self.makeCellRegistration(), for: indexPath, item: song)
//                cell.contentView.backgroundColor = .black
                return cell
                
            }
//            guard
//                let self = self,
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath) as? PlaylistCollectionViewCell
//            else { fatalError() }
//            guard let self = self else { fatalError() }
//            let cell = collectionView.dequeueConfiguredReusableCell(using: self.makeCellRegistration(), for: indexPath, item: song)
//            cell.artistLabel.text = song.artistName
//            cell.songTitleLabel.text = song.artistName
//            cell.song = song
//            return cell
        }
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
//            guard
//                let self = self,
//                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as? SectionHeader
//            else { fatalError() }
//            let thing = self.dataSource.snapshot().sectionIdentifier(containingItem: <#T##PlaylistMedia#>)
//            guard
//                let song = self.dataSource.itemIdentifier(for: indexPath),
//                let playlist = self.dataSource.snapshot().sectionIdentifier(containingItem: song)
//            else { return nil }
            guard let self = self else { fatalError() }
//            sectionHeader.titleLabel.text = self.musicController.userPlaylists[indexPath.section].playlistName
            let headerView = collectionView.dequeueConfiguredReusableSupplementary(using: self.makePlaylistHeaderRegistration(), for: indexPath)
            return headerView
//            return sectionHeader
        }
        
        dataSource.reorderingHandlers.canReorderItem = { song -> Bool in
            self.collectionView.isEditing
        }
        
        dataSource.reorderingHandlers.didReorder = { transaction in
            transaction.sectionTransactions.forEach {
                let sectionIdentifier = $0.sectionIdentifier
                if let sectionIndex = transaction.finalSnapshot.indexOfSection(sectionIdentifier) {
//                    self.musicController.userPlaylists[sectionIndex].songs = $0.finalSnapshot.items
                }
            }
        }
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.view.layer.cornerRadius = 20
        setupViews()
        reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.isEditing = editing
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
//            section.contentInsets
            return section
        }
        return layout
    }
    
    private func deleteSelectedSong(song: Song) {
//        guard let indexPath = dataSource.indexPath(for: song) else { return }
//        musicController.userPlaylists[indexPath.section].songs.remove(at: indexPath.item)
//        var snapshot = dataSource.snapshot()
//        snapshot.deleteItems([song])
//        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func makeCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Song> {
        let songCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Song> { cell, indexPath, song in
            var content = cell.defaultContentConfiguration()
            content.imageProperties.maximumSize = CGSize(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7)
            content.imageProperties.cornerRadius = 7
            content.textProperties.color = .lightText
            content.secondaryTextProperties.color = .white
            content.textProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
            content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
//            cell.backgroundColor = .clear
//            cell.contentView.backgroundColor = .clear
            
            if let imageData = song.albumArtwork {
                content.image = UIImage(data: imageData)
            } else {
                APIController.shared.fetchImage(mediaItem: song, size: 500) { result in
                    switch result {
                    case .success(let imageData):
                        content.image = UIImage(data: imageData!)
                    case .failure(let error):
                        print("Unable to fetch image data for song: \(song). Error: \(error.localizedDescription)")
                    }
                }
            }
            content.text = song.artistName
            content.secondaryText = song.songName
            cell.contentConfiguration = content
            let delete: UICellAccessory = .delete(displayed: .whenEditing, actionHandler: { self.deleteSelectedSong(song: song) })
            let reorder: UICellAccessory = .reorder(displayed: .whenEditing)
            cell.accessories = [delete, reorder]
        }
        return songCellRegistration
    }
    
    private func makePlaylistHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        let playlistHeaderRegistration = UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { (header: UICollectionViewListCell, string, indexPath) in
            var content = header.defaultContentConfiguration()
            if let item = self.dataSource.itemIdentifier(for: indexPath), let playlist = self.dataSource.snapshot().sectionIdentifier(containingItem: item) {
                content.text = playlist.playlistName
            }
            content.textProperties.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            content.textProperties.color = .white
            content.textProperties.adjustsFontForContentSizeCategory = true
            header.contentConfiguration = content
//            header.backgroundColor = .backgroundColor
//            header.contentView.backgroundColor = .backgroundColor
//            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .automatic, isHidden: false, reservedLayoutWidth: .actual, tintColor: .white)
//            header.accessories = [.outlineDisclosure(displayed: .always, options: headerDisclosureOption, actionHandler: .none)]
        }
        return playlistHeaderRegistration
    }
    
    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Playlists"
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewPlaylist))
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 20
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    func reloadData() {
        var snapshot = PlaylistSnapshot()
        
        snapshot.appendSections(musicController.userPlaylists)
        musicController.userPlaylists.forEach {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<PlaylistMedia>()
            let playlistItem = PlaylistMedia.playlist($0)
            snapshot.appendItems([playlistItem], toSection: $0)
            sectionSnapshot.append([playlistItem])
            let playlistSongs = $0.songs.map { PlaylistMedia.song($0) }
            sectionSnapshot.append(playlistSongs, to: playlistItem)
            dataSource.apply(sectionSnapshot, to: $0, animatingDifferences: true)
        }
//        dataSource.apply(snapshot)
//        musicController.userPlaylists.forEach {
//            let playlistItem = PlaylistMedia.playlist($0)
//            sectionSnapshot.append([playlistItem], to: )
//            let playlistSongs = $0.songs.map { PlaylistMedia.song($0) }
//            sectionSnapshot.append(playlistSongs, to: playlistItem)
//            sectionSnapshot.expand([playlistItem])
//        }
//        dataSource.apply(sectionSnapshot, to: 0, animatingDifferences: true)
    }
    
    func setQueue(with playlist: Playlist) {
        let newQueue = playlist.songs.map { $0.playID }
        musicController?.musicPlayer.setQueue(with: newQueue)
        musicController?.currentPlaylist = playlist.songs
        musicController?.play()
    }
    
    @objc private func createNewPlaylist() {
        
        coordinator?.presentCreatePlaylistVC()
    }
}
