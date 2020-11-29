//
//  CreatePlaylistViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 11/25/20.
//

import UIKit
import Combine

class CreatePlaylistViewController: UIViewController, ReloadDataDelegate, SetPlaylistDelegate {
    
    var musicController: MusicController?
    weak var coordinator: MainCoordinator?
    weak var reloadDataDelegate: ReloadDataDelegate?
    typealias CreatePlaylistDataSource = UICollectionViewDiffableDataSource<Int, Song>
    typealias CreatePlaylistSnapshot = NSDiffableDataSourceSnapshot<Int, Song>
    
    let playlistNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.attributedPlaceholder = NSAttributedString(string: "Playlist Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel, NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2)])
        textField.defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2)]
        return textField
    }()
    
    let addMusicButton: NeuMusicButton = {
        let button = NeuMusicButton()
        button.tintColor = .white
        button.setTitle("Add Music", for: .normal)
        button.setSize(width: 125, height: 40)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(presentSearchVC), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        cv.register(CreatePlaylistCollectionViewCell.self, forCellWithReuseIdentifier: CreatePlaylistCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        return cv
    }()
    
    lazy var dataSource: CreatePlaylistDataSource = {
        let dataSource = CreatePlaylistDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, song -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.makeCellRegistration(), for: indexPath, item: song)
            
            return cell
        }
        dataSource.reorderingHandlers.canReorderItem = { song -> Bool in
            return true
        }
        
        dataSource.reorderingHandlers.didReorder = { transaction in
            let section = transaction.sectionTransactions.first
            if let playlistSongs = section?.finalSnapshot.items {
                self.musicController?.createPlaylistSongs = playlistSongs
            }
        }
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        playlistNameTextField.resignFirstResponder()
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
            let delete: UICellAccessory = .delete(displayed: .always, actionHandler: { self.deleteSelectedSong(song: song) })
            let reorder: UICellAccessory = .reorder(displayed: .always)
            cell.accessories = [delete, reorder]
        }
        return songCellRegistration
    }
    
    private func setupViews() {
        view.backgroundColor = .backgroundColor
        navigationController?.navigationBar.topItem?.title = "Create New Playlist"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewPlaylist))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(createNewPlaylist))
        view.addSubview(playlistNameTextField)
        view.addSubview(addMusicButton)
        view.addSubview(collectionView)
        playlistNameTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, centerX: view.centerXAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        addMusicButton.anchor(top: playlistNameTextField.bottomAnchor, centerX: view.centerXAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: UIScreen.main.bounds.width / 3, height: 50))
        collectionView.anchor(top: addMusicButton.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
    }
    
    private func createCompLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(UIScreen.main.bounds.width / 5))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let layout = UICollectionViewCompositionalLayout(section: layoutSection)
        return layout
    }
    
    func deleteSelectedSong(song: Song) {
        guard let indexPath = dataSource.indexPath(for: song) else { return }
        var snapshot = dataSource.snapshot()
        if let song = musicController?.createPlaylistSongs.remove(at: indexPath.item) {
            snapshot.deleteItems([song])
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func reloadData() {
        var snapshot = CreatePlaylistSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(musicController?.createPlaylistSongs ?? [])
        dataSource.apply(snapshot)
    }
    
    func setQueue(with playlist: Playlist) {
        let newQueue = playlist.songs.map { $0.playID }
        musicController?.musicPlayer.setQueue(with: newQueue)
        musicController?.currentPlaylist = playlist.songs
        musicController?.play()
    }
    
    @objc private func cancelNewPlaylist() {
        musicController?.createPlaylistSongs.removeAll()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func createNewPlaylist() {
        guard
            let musicController = musicController,
            let playlistName = playlistNameTextField.text,
            !playlistName.isEmpty
        else {
            self.presentUserInfoAlert(title: "Not so fast...", message: "Please enter a name for your playlist.")
            return
        }
        
        let playlist = Playlist(playlistName: playlistName, songs: musicController.createPlaylistSongs)
        _ = PersistedPlaylist(playlist: playlist)
        musicController.saveToPersistentStore()
        musicController.userPlaylists.append(playlist)
        musicController.createPlaylistSongs.removeAll()
        reloadDataDelegate?.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func presentSearchVC() {
        let searchNav = UINavigationController(rootViewController: SearchViewController(isPlaylistSearch: true))
        let searchVC = searchNav.topViewController as! SearchViewController
        searchVC.musicController = self.musicController
        searchVC.reloadDataDelegate = self
        self.present(searchNav, animated: true)
    }
}
