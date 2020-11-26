//
//  CreatePlaylistViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 11/25/20.
//

import UIKit
import Combine

class CreatePlaylistViewController: UIViewController, CreatePlaylistDelegate {

    var musicController: MusicController?
    weak var coordinator: MainCoordinator?
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
    
    let addMusicButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Music", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(presentSearchVC), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createCompLayout())
        cv.register(CreatePlaylistCollectionViewCell.self, forCellWithReuseIdentifier: CreatePlaylistCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        return cv
    }()
    
    lazy var dataSource: CreatePlaylistDataSource = {
        let dataSource = CreatePlaylistDataSource(collectionView: collectionView) { collectionView, indexPath, song -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatePlaylistCollectionViewCell.identifier, for: indexPath) as! CreatePlaylistCollectionViewCell
        
            let song = self.musicController?.createPlaylistSongs[indexPath.item]
            cell.song = song
            
            return cell
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
    
    
    private func setupViews() {
        view.backgroundColor = .backgroundColor
        navigationController?.navigationBar.topItem?.title = "Create New Playlist"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewPlaylist))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(createNewPlaylist))
        view.addSubview(playlistNameTextField)
        view.addSubview(addMusicButton)
        view.addSubview(collectionView)
        playlistNameTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, centerX: view.centerXAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        addMusicButton.anchor(top: playlistNameTextField.bottomAnchor, centerX: view.centerXAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: UIScreen.main.bounds.width / 3, height: 50))
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
    
    func reloadData() {
        var snapshot = CreatePlaylistSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(musicController?.createPlaylistSongs ?? [])
        dataSource.apply(snapshot)
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
        if let persistedPlaylist = PersistedPlaylist(playlist: playlist) {
//            var persistedSongs = [PlaylistSong]()
            musicController.createPlaylistSongs.forEach {
                if let playlistSong = PlaylistSong(song: $0) {
//                    persistedPlaylist.mutableOrderedSetValue(forKey: "playlistSongs").add(playlistSong)
                    persistedPlaylist.addToPlaylistSongs(playlistSong)
//                    persistedSongs.append(playlistSong)
                }
            }
//            persistedPlaylist.playlistSongs = NSOrderedSet(array: persistedSongs)
            musicController.saveToPersistentStore()
//            musicController.savePlaylistSongs(persistedPlaylist: persistedPlaylist)
        }
        musicController.userPlaylists.append(playlist)
        musicController.createPlaylistSongs.removeAll()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func presentSearchVC() {
        let searchNav = UINavigationController(rootViewController: SearchViewController(isPlaylistSearch: true))
        let searchVC = searchNav.topViewController as! SearchViewController
        searchVC.musicController = self.musicController
        searchVC.createPlaylistDelegate = self
        self.present(searchNav, animated: true)
    }
}
