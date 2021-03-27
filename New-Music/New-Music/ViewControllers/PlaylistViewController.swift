//
//  PlaylistViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI
import Combine

class PlaylistViewController: UIViewController, ReloadDataDelegate, PlaylistDelegate {
    
//    private var subscriptions = Set<AnyCancellable>()
    private var nowPlayingViewModel: NowPlayingViewModel!
//    typealias PlaylistsDataSource = UICollectionViewDiffableDataSource<Playlist, PlaylistMedia>
	typealias PlaylistsDataSource = UICollectionViewDiffableDataSource<Playlist, String>
//    typealias PlaylistSnapshot = NSDiffableDataSourceSnapshot<Playlist, PlaylistMedia>
	typealias PlaylistSnapshot = NSDiffableDataSourceSnapshot<Playlist, String>
    var musicController: MusicController!
    weak var coordinator: MainCoordinator?
    let artistLabel = UILabel()
    var backgroundColor: UIColor?
	var isValidMove = true
	var didReorder = false {
		didSet {
			didReorder = false
			applySnapshot()
		}
	}
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.setSize(width: UIScreen.main.bounds.width, height: 1)
        return view
    }()
	
	lazy var backingStore: Dictionary<Playlist, [String]> = { initialBackingStore() }() {
		didSet {
//			self.updateUserPlaylists()
//			DispatchQueue.global(qos: .utility).async { [weak self] in
//				guard let self = self else { return }
//				self.applyBackingStore(animated: false, isInitial: false)
//			}
		}
	}
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
			var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
			configuration.backgroundColor = .backgroundColor
//			configuration.headerMode = sectionIndex == 0 ? .supplementary : .none
			configuration.footerMode = .supplementary
			configuration.headerMode = .firstItemInSection
			configuration.trailingSwipeActionsConfigurationProvider = { indexPath -> UISwipeActionsConfiguration? in
				guard
					let identifier = self.dataSource.itemIdentifier(for: indexPath),
					let value = self.musicController.userPlaylistsBackingStore[identifier]
				else { return nil }
				
				switch value {
				case is Playlist:
					let playlist = value as! Playlist
					return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _, _, completion in
						self?.deleteSelectedPlaylist(playlist: playlist)
						completion(true)
					})])
				case is Song:
					let song = value as! Song
					return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _, _, completion in
						self?.deleteSelectedSong(song: song)
						completion(true)
					})])
				default:
					return nil
				}
			}
			let section = NSCollectionLayoutSection.list(using: configuration,
														 layoutEnvironment: layoutEnvironment)
//			if sectionIndex == 0 {
//				let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//					layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//													   heightDimension: .estimated(44)),
//					elementKind: UICollectionView.elementKindSectionHeader,
//					alignment: .top)
//				sectionHeader.pinToVisibleBounds = true
//				sectionHeader.zIndex = 25
//				let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
//					layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//													   heightDimension: .estimated(44)),
//					elementKind: UICollectionView.elementKindSectionFooter,
//					alignment: .bottom)
//				section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
//			} else {
				let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
					layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
													   heightDimension: .estimated(44)),
					elementKind: UICollectionView.elementKindSectionFooter,
					alignment: .bottom)
				section.boundarySupplementaryItems = [sectionFooter]
//			}
			return section
		}
		layout.configuration.interSectionSpacing = 0
		let cv = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
		cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		cv.backgroundColor = .clear
		cv.contentInset.bottom = 66
		cv.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
		return cv
	}()
    
    let playlistCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Playlist> { cell, indexPath, playlist in
        var content = cell.defaultContentConfiguration()
        content.text = playlist.playlistName.lowercased().capitalized
        content.textProperties.font = UIFont.preferredFont(forTextStyle: .headline).withSize(25)
        cell.contentConfiguration = content
        let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .cell, isHidden: false, tintColor: .white)
        cell.accessories = [.outlineDisclosure(displayed: .always, options: headerDisclosureOption, actionHandler: .none)]
    }
    
	var dataSource: PlaylistsDataSource!
    
	func configureDataSource() {
		dataSource = PlaylistsDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, playlistMedia -> UICollectionViewCell? in
			guard
				let self = self,
				let value = self.musicController.userPlaylistsBackingStore[playlistMedia]
			else { fatalError() }
			switch value {
			case is Playlist:
				let playlist = value as! Playlist
				let cell = collectionView.dequeueConfiguredReusableCell(using: self.makeCustomPlaylistCellRegistration(), for: indexPath, item: playlist)
				cell.setPlaylistDelegate = self
				return cell
			case is Song:
				let song = value as! Song
				let cell = collectionView.dequeueConfiguredReusableCell(using: self.makeCellRegistration(), for: indexPath, item: song)
				return cell
			default:
				return nil
			}
		}
		
		dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
			guard let self = self else { return nil }
			
			if kind == UICollectionView.elementKindSectionHeader {
				let header = collectionView.dequeueConfiguredReusableSupplementary(using: self.makeAddHeaderRegistration(), for: indexPath)
				return header
			} else {
				let footer = collectionView.dequeueConfiguredReusableSupplementary(using: self.makePlaylistFooterRegistration(), for: indexPath)
				return footer
			}
		}
		
		dataSource.reorderingHandlers.canReorderItem = { _ -> Bool in
			self.collectionView.isEditing
		}
		
		dataSource.reorderingHandlers.didReorder = { [weak self] transaction in
			guard let self = self else { return }
			defer {
				self.updateSnapshotAfterValidMove(using: transaction.sectionTransactions)
			}
			self.printDataSourceItems(stringIDs: transaction.finalSnapshot.itemIdentifiers)
			transaction.sectionTransactions.forEach {
				self.printDataSourceItems("Section Transaction:", stringIDs: $0.finalSnapshot.items)
			}
			for sectionTransation in transaction.sectionTransactions {
				guard
					let firstIdentifier = sectionTransation.finalSnapshot.items.first,
					let _ = self.musicController.userPlaylistsBackingStore[firstIdentifier] as? Playlist
				else {
					self.isValidMove = false
					defer { self.refreshSnapshot(using: transaction.sectionTransactions, animated: false) }
					return
				}
				var songs = [Song]()
				sectionTransation.finalSnapshot.items.forEach {
					if let song = self.musicController.userPlaylistsBackingStore[$0] as? Song {
						songs.append(song)
					}
				}
				let playlist = sectionTransation.sectionIdentifier
				sectionTransation.sectionIdentifier.songs = songs
				self.printDataSourceItems("This is the playlists songs...", stringIDs: playlist.songIDs)
				self.musicController.saveToPersistentStore()
			}
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.view.layer.cornerRadius = 20
        setupViews()
		configureDataSource()
		applyBackingStore(animated: true, isInitial: true)
//        applySnapshot()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		checkForSongAddedToExistingPlaylist()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.isEditing = editing
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
	private func deleteSelectedPlaylist(playlist: Playlist) {
		var snapshot = dataSource.snapshot()
		guard
			let playlist = snapshot.sectionIdentifier(containingItem: playlist.id),
			let index = musicController.userPlaylists.firstIndex(of: playlist)
		else { return }
		
		let sectionItems = snapshot.itemIdentifiers(inSection: playlist)
		var sectionSnapshot = dataSource.snapshot(for: playlist)
		sectionSnapshot.deleteAll()
		snapshot.deleteItems(sectionItems)
		snapshot.deleteSections([playlist])
		musicController.userPlaylists.remove(at: index)
		musicController.userPlaylistsBackingStore.removeValue(forKey: playlist.id)
		playlist.songs.forEach {
			musicController.userPlaylistsBackingStore.removeValue(forKey: $0.id)
		}
		musicController.saveToPersistentStore()
		dataSource.apply(snapshot, animatingDifferences: true)
	}
	
//    private func deleteSelectedPlaylist(playlist: PlaylistMedia) {
//        var snapshot = dataSource.snapshot()
//        guard let indexPath = dataSource.indexPath(for: playlist) else { return }
//        if case PlaylistMedia.playlist(let playlist) = playlist {
//            snapshot.deleteSections([playlist])
//            musicController.userPlaylists.remove(at: indexPath.section)
//            musicController.saveToPersistentStore()
//        }
//        dataSource.apply(snapshot, animatingDifferences: true)
//    }
    
	private func deleteSelectedSong(song: Song) {
		var snapshot = dataSource.snapshot()
		guard
			let playlist = snapshot.sectionIdentifier(containingItem: song.id),
			let index = playlist.songs.firstIndex(of: song)
		else { return }
		snapshot.deleteItems([song.id])
		playlist.songs.remove(at: index)
		musicController.userPlaylistsBackingStore.removeValue(forKey: song.id)
		backingStore.removeValue(forKey: playlist)
		musicController.saveToPersistentStore()
		dataSource.apply(snapshot, animatingDifferences: true)
	}
	
//    private func deleteSelectedSong(song: Song) {
//        var snapshot = dataSource.snapshot()
//        let playlistMedia = PlaylistMedia.song(song)
//        guard let indexPath = dataSource.indexPath(for: playlistMedia) else { return }
//        snapshot.deleteItems([playlistMedia])
//        if let index = musicController.userPlaylists[indexPath.section].songs.firstIndex(of: song) {
//            musicController.userPlaylists[indexPath.section].songs.remove(at: index)
//            musicController.saveToPersistentStore()
//        }
//        dataSource.apply(snapshot, animatingDifferences: true)
//    }
    
    private func makeCustomPlaylistCellRegistration() -> UICollectionView.CellRegistration<PlaylistCollectionViewCell, Playlist> {
        let playlistCellRegistration = UICollectionView.CellRegistration<PlaylistCollectionViewCell, Playlist> { cell, indexPath, playlist in
            cell.playlist = playlist
			let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header, isHidden: false, tintColor: .white)
            let outlineDisclosure: UICellAccessory = .outlineDisclosure(displayed: .always, options: headerDisclosureOption, actionHandler: .none)
            cell.accessories = [outlineDisclosure]
			
        }
        return playlistCellRegistration
    }
    
    private func makeCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Song> {
        let songCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Song> { [weak self] cell, indexPath, song in
            guard let self = self else { return }
            var content = cell.defaultContentConfiguration()
            content.imageProperties.maximumSize = CGSize(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7)
            content.imageProperties.cornerRadius = 7
            content.textProperties.color = .lightText
            content.secondaryTextProperties.color = .white
            content.textProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
            content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
            content.imageToTextPadding = 0
            content.textToSecondaryTextVerticalPadding = 0

            content.imageProperties.reservedLayoutSize = CGSize(width: (UIScreen.main.bounds.width / 7) + 16, height: (UIScreen.main.bounds.width / 7) + 16)
            content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

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
//			let options = UICellAccessory.DeleteOptions(isHidden: nil, reservedLayoutWidth: .custom(80), tintColor: nil, backgroundColor: nil)
			let delete: UICellAccessory = .delete(displayed: .whenEditing) {
				self.deleteSelectedSong(song: song)
			}
//            let delete: UICellAccessory = .delete(displayed: .whenEditing, actionHandler: { self.deleteSelectedSong(song: song) })
			let options = UICellAccessory.ReorderOptions(isHidden: nil, reservedLayoutWidth: .standard, tintColor: nil, showsVerticalSeparator: true)
			let reorder: UICellAccessory = .reorder(displayed: .whenEditing, options: options)
//            let reorder: UICellAccessory = .reorder(displayed: .whenEditing)
            var bgConfig = UIBackgroundConfiguration.listGroupedCell().updated(for: cell.configurationState)
            bgConfig.backgroundColor = .clear
            cell.backgroundConfiguration = bgConfig
            cell.accessories = [delete, reorder]
        }
        return songCellRegistration
    }
    
    private func makePlaylistHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        let playlistHeaderRegistration = UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] (header: UICollectionViewListCell, string, indexPath) in
            guard let self = self else { return }
            var content = header.defaultContentConfiguration()
            content.textProperties.font = UIFont.preferredFont(forTextStyle: .headline).withSize(25)
            content.textProperties.color = .white
            content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .headline).withSize(25)
            if let item = self.dataSource.itemIdentifier(for: indexPath), let playlist = self.dataSource.snapshot().sectionIdentifier(containingItem: item) {
                content.secondaryText = playlist.playlistName
            }

            header.contentConfiguration = content
        }
        return playlistHeaderRegistration
    }
	
	private func makeAddHeaderRegistration() -> UICollectionView.SupplementaryRegistration<CreateNewPlaylistCollectionViewCell> {
		let addHeaderRegistration = UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { (header: CreateNewPlaylistCollectionViewCell, string, indexPath) in
			header.playlistDelegate = self
		}
		return addHeaderRegistration
	}
    
    private func makePlaylistFooterRegistration() -> UICollectionView.SupplementaryRegistration<SectionFooterCollectionViewCell> {
        let playlistFooterRegistration = UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionFooter) { [weak self] (footer: SectionFooterCollectionViewCell, string, indexPath) in
            guard let self = self else { return }
            if let item = self.dataSource.itemIdentifier(for: indexPath), let playlist = self.dataSource.snapshot().sectionIdentifier(containingItem: item) {
                footer.playlistDetailLabel.text = "\(playlist.songCount) songs, \(String(format: "%.0f", playlist.totalDuration)) mins"
            }
        }
        return playlistFooterRegistration
    }
    
    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Playlists"
//        navigationItem.leftBarButtonItem = editButtonItem
//        navigationItem.leftBarButtonItem?.tintColor = .white
//		navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(createNewPlaylist(_:)))]
		let navItem = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), menu: createMenu())
		navigationItem.rightBarButtonItems = [navItem]
//		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(createNewPlaylist))
//        navigationItem.rightBarButtonItem?.tintColor = .white
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 20
        view.addSubview(collectionView)
        view.addSubview(separatorView)
        separatorView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.centerXAnchor)
    }
    
	func applySnapshot() {
		var snapshot = PlaylistSnapshot()
		snapshot.appendSections(musicController.userPlaylists)
		musicController.userPlaylists.forEach {
			var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<String>()
			sectionSnapshot.append([$0.id])
			let songIDs = $0.songs.map { $0.id }
			sectionSnapshot.append(songIDs, to: $0.id)
			dataSource.apply(sectionSnapshot, to: $0, animatingDifferences: true)
		}
	}
	
	private func refreshSnapshot(using sectionTransactions: [NSDiffableDataSourceSectionTransaction<Playlist, String>], animated: Bool = false) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			for transaction in sectionTransactions {
				let playlist = transaction.sectionIdentifier
				var oldSectionSnapshot = self.dataSource.snapshot(for: playlist)
				oldSectionSnapshot = transaction.initialSnapshot
				self.printDataSourceItems("Items after invalid move...", stringIDs: transaction.initialSnapshot.items)
				var snapshot = self.dataSource.snapshot()
				snapshot.reloadSections([playlist])
				self.dataSource.apply(oldSectionSnapshot, to: playlist, animatingDifferences: false)
			}
		}
	}
	
//    func reloadData() {
//        var snapshot = PlaylistSnapshot()
//
//        snapshot.appendSections(musicController.userPlaylists)
//        musicController.userPlaylists.forEach {
//            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<PlaylistMedia>()
//            let playlistItem = PlaylistMedia.playlist($0)
//            snapshot.appendItems([playlistItem], toSection: $0)
//            sectionSnapshot.append([playlistItem])
//            let playlistSongs = $0.songs.map { PlaylistMedia.song($0) }
//            sectionSnapshot.append(playlistSongs, to: playlistItem)
//            dataSource.apply(sectionSnapshot, to: $0, animatingDifferences: true)
//        }
//    }
    
    
    func setQueue(with playlist: Playlist) {
        let newQueue = playlist.songs.map { $0.playID }
        musicController.updateAlbumArtwork(for: playlist)
        musicController?.musicPlayer.setQueue(with: newQueue)
        musicController.nowPlayingPlaylist = playlist
		musicController.currentPlaylist = playlist
        musicController?.play()
    }
    
    @objc func createNewPlaylist(_ sender: UIBarButtonItem) {
        coordinator?.presentCreatePlaylistVC()
    }
	
	func presentCreatePlaylistVC() {
		coordinator?.presentCreatePlaylistVC()
	}
    
	
	
	/// Shuffles the songs of a specific playlist, persists the new shuffled order of the playlist songs, updates the collection views data source with the newly shuffled song order and starts playback.
	/// - Parameter playlist: The playlist whose songs will be shuffled
	func shuffleSongs(for playlist: Playlist) {
		var sectionSnapshot = dataSource.snapshot(for: playlist)
		var snapshotSection = NSDiffableDataSourceSectionSnapshot<String>()
		playlist.songs.shuffle()
		let shuffledSongIDs = playlist.songs.map { $0.id }
		snapshotSection.append(shuffledSongIDs)
		sectionSnapshot.replace(childrenOf: sectionSnapshot.rootItems.first!, using: snapshotSection)
		dataSource.apply(sectionSnapshot, to: playlist)
		musicController.saveToPersistentStore()
		musicController.musicPlayer.stop()
		setQueue(with: playlist)
	}
	
//    func shuffleSongs(for playlist: Playlist) {
//        var sectionSnapshot = dataSource.snapshot(for: playlist)
//        var snapshotSection = NSDiffableDataSourceSectionSnapshot<PlaylistMedia>()
//        playlist.songs.shuffle()
//        let shuffledSongs = playlist.songs.map { PlaylistMedia.song($0) }
//        snapshotSection.append(shuffledSongs)
//        sectionSnapshot.replace(childrenOf: sectionSnapshot.rootItems.first!, using: snapshotSection)
//        dataSource.apply(sectionSnapshot, to: playlist)
//        musicController.saveToPersistentStore()
//        musicController.musicPlayer.stop()
//        setQueue(with: playlist)
//    }
	
	func checkForSongAddedToExistingPlaylist() {
		if let addedSongToPlaylist = musicController.addSongToPlaylistTuple {
			let playlist = addedSongToPlaylist.playlist
			let song = addedSongToPlaylist.song
			var sectionSnapshot = dataSource.snapshot(for: playlist)
			sectionSnapshot.append([song.id], to: playlist.id)
			dataSource.apply(sectionSnapshot, to: playlist, animatingDifferences: true)
			musicController.addSongToPlaylistTuple = nil
		}
	}
	
	private func initialBackingStore() -> Dictionary<Playlist, [String]> {
		var allPlaylists = Dictionary<Playlist, [String]>()
		musicController.userPlaylists.forEach {
			allPlaylists[$0, default: [$0.id]] += $0.songIDs
		}
		return allPlaylists
	}
	
	private func applyBackingStore(animated: Bool, isInitial: Bool) {
		if isInitial {
			for (playlist, songs) in backingStore {
				var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<String>()
				sectionSnapshot.append([songs[0]])
				let songIDs = Array(songs[1..<songs.count])
				sectionSnapshot.append(songIDs, to: playlist.id)
				dataSource.apply(sectionSnapshot, to: playlist, animatingDifferences: animated)
			}
		} else {
			var sections = [NSDiffableDataSourceSectionSnapshot<String>]()
			
			musicController.userPlaylists.forEach {
				var newSectionSnapshot = NSDiffableDataSourceSectionSnapshot<String>()
				var oldSectionSnapshot = dataSource.snapshot(for: $0)
				newSectionSnapshot.append($0.songIDs)
				oldSectionSnapshot.replace(childrenOf: oldSectionSnapshot.rootItems.first ?? $0.id, using: newSectionSnapshot)
				sections.append(newSectionSnapshot)
			}
			
			musicController.userPlaylists.enumerated().forEach {
				var sectionSnapshot = sections[$0.offset]
				sectionSnapshot.expand(sectionSnapshot.snapshot(of: sectionSnapshot.rootItems.first ?? $0.element.id, includingParent: false).items)
				dataSource.apply(sectionSnapshot, to: $0.element, animatingDifferences: animated)
			}
		}
	}
	
	private func updateSnapshotAfterValidMove(using sectionTransactions: [NSDiffableDataSourceSectionTransaction<Playlist, String>]) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			if self.isValidMove {
				for transaction in sectionTransactions {
					let playlist = transaction.sectionIdentifier
					var oldSectionSnapshot = self.dataSource.snapshot(for: playlist)
					
					oldSectionSnapshot = transaction.finalSnapshot
					
					self.dataSource.apply(oldSectionSnapshot, to: playlist, animatingDifferences: false)
					if transaction.difference.insertions.count > 0 {
						let finalItemsSet = Set(transaction.finalSnapshot.items)
						if let newSongID = finalItemsSet.symmetricDifference(transaction.initialSnapshot.items).first, let indexPath = self.dataSource.indexPath(for: newSongID) {
							defer { self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false) }
							continue
						}
					}
				}
			} else {
				self.isValidMove = true
			}
		}
	}
	
	private func printDataSourceItems(_ title: String? = nil, stringIDs: [String]) {
		if let title = title {
			print("\n\(title)\n")
		}
		for identifier in stringIDs {
			if let value = musicController.userPlaylistsBackingStore[identifier] {
				if value is Song {
					let song = value as! Song
					print("Song Name: \(song.songName)")
				}
				if value is Playlist {
					let playlist = value as! Playlist
					print("Playlist Name: \(playlist.playlistName)")
				}
			}
		}
	}
	
	private func updateSnapshot(with snapshot: PlaylistSnapshot) {
		DispatchQueue.global().async { [weak self] in
			guard let self = self else { return }
			var newSnapshot = PlaylistSnapshot()
			newSnapshot = snapshot
			var oldSnapshot = self.dataSource.snapshot()
			oldSnapshot.deleteAllItems()
			print("\nSnapshot Items:")
			self.printDataSourceItems(stringIDs: snapshot.itemIdentifiers)
			self.dataSource.apply(newSnapshot)
		}
	}
	
	func createMenu() -> UIMenu {
		let createNewPlaylistAction = UIAction(title: "Create a new playlist...", image: UIImage(systemName: "music.note.list")) { [weak self] _ in
			guard let self = self else { return }
			self.presentCreatePlaylistVC()
		}
		
		let editPlaylistsAction = UIAction(title: "Edit playlists", image: UIImage(systemName: "pencil")) { [weak self] _ in
			guard let self = self else { return }
			self.collectionView.isEditing = true
			self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneEditingTapped(_:)))]
		}
		let menu = UIMenu(title: "", options: [], children: [createNewPlaylistAction, editPlaylistsAction])
		return menu
	}
	
	@objc
	private func doneEditingTapped(_ sender: UIBarButtonItem) {
		collectionView.isEditing = false
		let navItem = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), menu: createMenu())
		navigationItem.rightBarButtonItems = [navItem]
	}
}
