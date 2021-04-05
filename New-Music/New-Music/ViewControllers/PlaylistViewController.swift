//
//  PlaylistViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI
import Combine

class PlaylistViewController: UIViewController, ReloadDataDelegate, PlaylistDelegate {

    private var nowPlayingViewModel: NowPlayingViewModel!
    typealias PlaylistsDataSource = UICollectionViewDiffableDataSource<Playlist, PlaylistMedia>
	    typealias PlaylistSnapshot = NSDiffableDataSourceSnapshot<Playlist, PlaylistMedia>

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
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
			var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
			configuration.backgroundColor = .backgroundColor
			configuration.headerMode = sectionIndex == 0 ? .supplementary : .none
			configuration.footerMode = .supplementary
//			configuration.headerMode = .firstItemInSection
			configuration.trailingSwipeActionsConfigurationProvider = { indexPath -> UISwipeActionsConfiguration? in
				guard let identifier = self.dataSource.itemIdentifier(for: indexPath) else { return nil }
				switch identifier {
				case .playlist(let playlist):
					return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _, _, completion in
						self?.deleteSelectedPlaylist(playlist: playlist)
						completion(true)
					})])
				case .song(let song):
					return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _, _, completion in
						self?.deleteSelectedSong(song: song)
						completion(true)
					})])
				}
			}
			let section = NSCollectionLayoutSection.list(using: configuration,
														 layoutEnvironment: layoutEnvironment)
			if sectionIndex == 0 {
				let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
					layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
													   heightDimension: .estimated(44)),
					elementKind: UICollectionView.elementKindSectionHeader,
					alignment: .top)
//				sectionHeader.pinToVisibleBounds = true
//				sectionHeader.zIndex = 25
				let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
					layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
													   heightDimension: .estimated(44)),
					elementKind: UICollectionView.elementKindSectionFooter,
					alignment: .bottom)
				section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
			} else {
				let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
					layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
													   heightDimension: .estimated(44)),
					elementKind: UICollectionView.elementKindSectionFooter,
					alignment: .bottom)
				section.boundarySupplementaryItems = [sectionFooter]
			}
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
			guard let self = self else { return nil }
			switch playlistMedia {
			case .playlist(let playlist):
				let cell = collectionView.dequeueConfiguredReusableCell(using: self.makeCustomPlaylistCellRegistration(), for: indexPath, item: playlist)
				cell.setPlaylistDelegate = self
				return cell
			case .song(let song):
				let cell = collectionView.dequeueConfiguredReusableCell(using: self.makeCellRegistration(), for: indexPath, item: song)
				return cell
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

		dataSource.reorderingHandlers.didReorder = { transaction in
			var playlistsToReload: [Playlist] = []
			defer { self.reloadSectionsAfterEditing(playlists: playlistsToReload) }
			for sectionTransation in transaction.sectionTransactions {
				let playlist = sectionTransation.sectionIdentifier
				let playlistSongs = sectionTransation.finalSnapshot.snapshot(of: PlaylistMedia.playlist(playlist), includingParent: false).items
				playlist.updatePlaylistSongsAfterEditing(updatedSongs: playlistSongs)
				playlistsToReload.append(playlist)
			}
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.view.layer.cornerRadius = 20
        setupViews()
		configureDataSource()
		collectionView.delegate = self
//		applyBackingStore(animated: true, isInitial: true)
        applySnapshot()
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
		guard let playlistIndex = musicController.userPlaylists.firstIndex(of: playlist) else { return }
		var snapshot = dataSource.snapshot()
		snapshot.deleteSections([playlist])
		musicController.userPlaylists.remove(at: playlistIndex)
		musicController.saveToPersistentStore()
		dataSource.apply(snapshot, animatingDifferences: true)
	}

	private func deleteSelectedSong(song: Song) {
		var snapshot = dataSource.snapshot()
		let playlistMediaSong = PlaylistMedia.song(song)
		guard let playlist = snapshot.sectionIdentifier(containingItem: playlistMediaSong) else { return }
		snapshot.deleteItems([playlistMediaSong])
		playlist.removeSong(song: song)
		snapshot.reloadSections([playlist])
		musicController.saveToPersistentStore()
		dataSource.apply(snapshot, animatingDifferences: true)
	}

    func makeCustomPlaylistCellRegistration() -> UICollectionView.CellRegistration<PlaylistCollectionViewCell, Playlist> {
        let playlistCellRegistration = UICollectionView.CellRegistration<PlaylistCollectionViewCell, Playlist> { cell, indexPath, playlist in
            cell.playlist = playlist
			let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header, isHidden: false, tintColor: .white)
            let outlineDisclosure: UICellAccessory = .outlineDisclosure(displayed: .always, options: headerDisclosureOption, actionHandler: .none)
            cell.accessories = [outlineDisclosure]
			
        }
        return playlistCellRegistration
    }
    
    func makeCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Song> {
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
			let deleteOptions = UICellAccessory.DeleteOptions(isHidden: nil, reservedLayoutWidth: .standard, tintColor: nil, backgroundColor: nil)
			let delete: UICellAccessory = .delete(displayed: .whenEditing, options: deleteOptions) {
				self.deleteSelectedSong(song: song)
			}
			let reorderOptions = UICellAccessory.ReorderOptions(isHidden: nil, reservedLayoutWidth: .standard, tintColor: .white, showsVerticalSeparator: true)
			let reorder: UICellAccessory = .reorder(displayed: .whenEditing, options: reorderOptions)
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
		let navItem = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), menu: createMenu())
		navigationItem.rightBarButtonItems = [navItem]
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 20
        view.addSubview(collectionView)
        view.addSubview(separatorView)
        separatorView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.centerXAnchor)
    }
    
	func applySnapshot() {
		musicController.userPlaylists.forEach {
			var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<PlaylistMedia>()
			let playlistItem = PlaylistMedia.playlist($0)
			sectionSnapshot.append([playlistItem])
			sectionSnapshot.append($0.playlistMedia, to: playlistItem)
			dataSource.apply(sectionSnapshot, to: $0)
		}
	}

	func reloadSectionsAfterEditing(playlists: [Playlist]) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			var snapshot = self.dataSource.snapshot()
			snapshot.reloadSections(playlists)
			self.dataSource.apply(snapshot)
		}
	}
	
	private func refreshSnapshot(using sectionTransactions: [NSDiffableDataSourceSectionTransaction<Playlist, PlaylistMedia>], animated: Bool = false) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			for transaction in sectionTransactions {
				let playlist = transaction.sectionIdentifier
				var oldSectionSnapshot = self.dataSource.snapshot(for: playlist)
				oldSectionSnapshot = transaction.initialSnapshot
//				self.printDataSourceItems("Items after invalid move...", stringIDs: transaction.initialSnapshot.items)
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
//		musicController.currentPlaylist = playlist
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
		var snapshotSection = NSDiffableDataSourceSectionSnapshot<PlaylistMedia>()
		playlist.shufflePlaylistSongs()
		snapshotSection.append(playlist.playlistMedia)
		sectionSnapshot.replace(childrenOf: sectionSnapshot.rootItems.first!, using: snapshotSection)
		dataSource.apply(sectionSnapshot, to: playlist)
		musicController.saveToPersistentStore()
		musicController.musicPlayer.stop()
		musicController.setQueue(with: playlist, shouldPlayMusic: true)
//		setQueue(with: playlist)
	}
	
	func checkForSongAddedToExistingPlaylist() {
		if musicController.songsAdded {
			for playlist in musicController.userPlaylists {
				guard !playlist.songsAddedFromSearch.isEmpty else { continue }
				var sectionSnapshot = dataSource.snapshot(for: playlist)
				sectionSnapshot.append(playlist.songsAddedPlaylistMedia, to: sectionSnapshot.rootItems.first!)
				dataSource.apply(sectionSnapshot, to: playlist, animatingDifferences: false)
				playlist.songsAddedFromSearch.removeAll()
			}
			musicController.songsAdded = false
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

extension PlaylistViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
		if proposedIndexPath.item == 0 {
			return originalIndexPath
		}
		print("\nOriginal IndexPath: \(originalIndexPath), Proposed IndexPath: \(proposedIndexPath)\n")
		return proposedIndexPath
	}
}
