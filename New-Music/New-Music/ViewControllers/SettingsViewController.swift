//
//  SettingsViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 1/23/21.
//

import UIKit

class SettingsViewController: UIViewController {

	typealias SettingsSnapshot = NSDiffableDataSourceSnapshot<Int, Setting>
	typealias SettingsDataSource = UICollectionViewDiffableDataSource<Int, Setting>
	
	weak var coordinator: MainCoordinator?
	var song: Song
	var settingType: SettingType
//	var shouldShowExistingPlaylists: Bool
	var musicController: MusicController?

	
	lazy var collectionView: UICollectionView = {
		var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//        layoutConfig.headerMode = .supplementary
		layoutConfig.backgroundColor = .clear
		let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
		let cv = UICollectionView(frame: view.bounds, collectionViewLayout: createCompLayout())
		cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		cv.layer.cornerRadius = 20
		let visualEffectView = UIVisualEffectView(frame: cv.bounds)
		visualEffectView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
		cv.backgroundView = visualEffectView
		cv.backgroundColor = .clear
		cv.isScrollEnabled = false
		cv.backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		return cv
	}()
	
	lazy var dataSource: SettingsDataSource = {
		let dataSource = SettingsDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, songSection -> UICollectionViewCell? in
			guard let self = self else { fatalError() }
			
			switch self.settingType {
			case .searchedSongSetting:
				let cell = collectionView.dequeueConfiguredReusableCell(using: self.makeSettingCellRegistration(), for: indexPath, item: songSection)
				cell.settingsDelegate = self
				return cell
			case .addToExistingPlaylist:
				let cell = collectionView.dequeueConfiguredReusableCell(using: self.makeExistingPlaylistCellRegistration(), for: indexPath, item: songSection)
				return cell
			case .playlistSetting:
				return nil
			}
		}
		return dataSource
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		reloadData()
	}
	
	private func setupViews() {
		view.addSubview(collectionView)
		view.clipsToBounds = true
		view.layer.cornerRadius = 20
		view.backgroundColor = UIColor.clear
		collectionView.delegate = self
//        panGesture.addTarget(self, action: #selector(handleGesture(_:)))
//        collectionView.addGestureRecognizer(panGesture)
	}
	
	private func configureTitleView() -> UIListContentView {
		var config = UIListContentConfiguration.cell()
		config.text = song.artistName
		config.textProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
		config.textProperties.color = .lightText
		config.image = UIImage(data: song.albumArtwork ?? Data())
		config.imageProperties.maximumSize = CGSize(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7)
		config.secondaryText = song.songName
		config.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
		config.secondaryTextProperties.color = .white
		config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
		let listView = UIListContentView(configuration: config)
		listView.backgroundColor = .clear
		return listView
	}
	
	private func createCompLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
			
			switch sectionIndex {
			case 0:
				var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
				layoutConfig.backgroundColor = .clear
				return NSCollectionLayoutSection.list(using: layoutConfig, layoutEnvironment: layoutEnvironment)
			case 1:
				var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
				layoutConfig.backgroundColor = .clear
				return NSCollectionLayoutSection.list(using: layoutConfig, layoutEnvironment: layoutEnvironment)
			default:
				var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
				layoutConfig.backgroundColor = .clear
				return NSCollectionLayoutSection.list(using: layoutConfig, layoutEnvironment: layoutEnvironment)
			}
		}
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.interSectionSpacing = -20
		layout.configuration = config
		return layout
	}
	
	private func makeSettingCellRegistration() -> UICollectionView.CellRegistration<SearchedSongSettingCollectionViewCell, Setting> {
		let songSettingsCellRegistration = UICollectionView.CellRegistration<SearchedSongSettingCollectionViewCell, Setting> { [weak self] cell, indexPath, setting in
			cell.section = indexPath.section
			switch self?.settingType {
			case .searchedSongSetting:
				cell.setting = setting
				cell.settingType = self?.settingType
			case .playlistSetting:
				cell.setting = setting
				cell.settingType = self?.settingType
			default:
				break
			}
		}
		return songSettingsCellRegistration
	}
	
	private func makeExistingPlaylistCellRegistration() -> UICollectionView.CellRegistration<ExistingPlaylistCollectionViewCell, Setting> {
		let songSettingsCellRegistration = UICollectionView.CellRegistration<ExistingPlaylistCollectionViewCell, Setting> { cell, indexPath, songSetting in
			cell.songSetting = songSetting
            var config = cell.defaultContentConfiguration()
            config.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
            config.textProperties.color = .white
            config.imageProperties.maximumSize = CGSize(width: 40, height: 40)
            config.imageProperties.tintColor = .white
            config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
            let playlistMedia = songSetting.setting as! PlaylistMedia
            if case PlaylistMedia.playlist(let playlist) = playlistMedia {
                config.text = playlist.playlistName
                config.image = UIImage(systemName: "music.note.list", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .default))
            }
            var bgConfig = UIBackgroundConfiguration.listGroupedCell()
            bgConfig.backgroundColor = .backgroundColor
            cell.backgroundConfiguration = bgConfig
            cell.contentConfiguration = config
		}
		return songSettingsCellRegistration
	}
	
	init(song: Song, settingType: SettingType) {
		self.song = song
		self.settingType = settingType
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func reloadData() {
		switch settingType {
		case .searchedSongSetting:
			var snapshot = SettingsSnapshot()
			snapshot.appendSections([0, 1])
			var songOptions = [Setting]()
			SearchedSongSetting.allCases.forEach {
				let songOption = Setting(setting: $0)
				songOptions.append(songOption)
			}
			let searchedSong = SettingsObject.song(self.song)
			let songSettingOne = Setting(setting: searchedSong)
			snapshot.appendItems([songSettingOne], toSection: 0)
			snapshot.appendItems(songOptions, toSection: 1)
			dataSource.apply(snapshot, animatingDifferences: true)
		case .playlistSetting:
			var snapshot = SettingsSnapshot()
			snapshot.appendSections([0, 1])
			var playlistSettings = [Setting]()
			PlaylistSetting.allCases.forEach {
				let playlistSetting = Setting(setting: $0)
				playlistSettings.append(playlistSetting)
			}
			let closeButton = SettingsObject.closeButton
			let setting = Setting(setting: closeButton)
			snapshot.appendItems([setting], toSection: 0)
			snapshot.appendItems(playlistSettings, toSection: 1)
			dataSource.apply(snapshot, animatingDifferences: true)
		case .addToExistingPlaylist:
			addSongToExistingPlaylistSnapshot()
		}
	}
	
	@objc private func dismissSettings() {
		dismiss(animated: true, completion: nil)
	}
	
	private func addSongToExistingPlaylistSnapshot() {
		var snapshot = SettingsSnapshot()
		var playlists = [Setting]()
		musicController?.userPlaylists.forEach {
			let playlistMedia = PlaylistMedia.playlist($0)
			let playlist = Setting(setting: playlistMedia)
			playlists.append(playlist)
		}
		
		var playlistIndices = [Int]()
		(0..<playlists.count).forEach {
			playlistIndices.append($0)
		}
		snapshot.appendSections(playlistIndices)
		playlistIndices.forEach {
			snapshot.appendItems([playlists[$0]], toSection: $0)
		}
		dataSource.apply(snapshot)
	}

	
	
	@objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
		guard let viewToAnimate = gesture.view?.superview?.superview else { return }
		
		var translation = gesture.translation(in: viewToAnimate).y
		switch gesture.state {
		case .began:
			()
		case .changed:
			translation = max(translation, 0)
			viewToAnimate.frame = viewToAnimate.bounds.offsetBy(dx: 0, dy: translation)
			viewToAnimate.layoutIfNeeded()
		case .ended:
			()
		default:
			break
		}
	}
	
	func playSearchedSong() {
		self.dismiss(animated: true, completion: nil)
		let playlist = Playlist(playlistName: "", songs: [song])
		self.musicController?.musicPlayer.stop()
		self.musicController?.nowPlayingPlaylist = playlist
		self.musicController?.musicPlayer.setQueue(with: [song.playID])
		self.musicController?.nowPlayingViewModel.nowPlayingSong = song
		self.musicController?.play()
	}
	
	private func presentExistingPlaylists() {
		guard let presentingVC = self.presentingViewController else { return }
		dismiss(animated: true, completion: nil)
		coordinator?.presentExistingPlaylists(viewController: presentingVC, song: song)
	}
}

extension SettingsViewController: UICollectionViewDelegate, SettingsDelegate {
	func createNewPlaylist() {
		
	}
	
	func dismissVC() {
		self.dismiss(animated: true, completion: nil)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if settingType == .addToExistingPlaylist {
			guard let playlist = musicController?.userPlaylists[indexPath.section] else { return }
			playlist.addNewSong(song: song)
			playlist.songsAddedFromSearch.append(song)
			musicController?.saveToPersistentStore()
			musicController?.songsAdded = true
			dismiss(animated: true, completion: nil)
		} else if settingType == .searchedSongSetting {
			switch indexPath.item {
			case 0:
				playSearchedSong()
			case 1:
				musicController?.createPlaylistSongs.append(song)
				self.dismiss(animated: true) { [weak self] in
					self?.coordinator?.switchToPlaylistTab()
				}
			case 2:
				presentExistingPlaylists()
			default:
				break
			}
		}
			
//		if shouldShowExistingPlaylists {
//            guard let song = self.song else { return }
//			let cell = collectionView.cellForItem(at: indexPath) as! ExistingPlaylistCollectionViewCell
//			let playlistMedia = cell.songSetting?.setting as! PlaylistMedia
//			if case PlaylistMedia.playlist(let playlist) = playlistMedia {
//				playlist.songs.append(song)
//				self.dismiss(animated: true, completion: nil)
//			}
//		} else {
//			switch indexPath.section {
//			case 1:
//				switch indexPath.item {
//				case 1:
//					self.dismiss(animated: true) {
//						self.coordinator?.switchToPlaylistTab()
//					}
//				case 2:
//					shouldShowExistingPlaylists = true
//					applySnapshotForExistingPlaylists()
//				default:
//					break
//				}
//			default:
//				break
//			}
//		}
	}
}
