//
//  NowPlayingViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI

class NowPlayingViewController: UIViewController {
    
    typealias CurrentPlaylistDataSource = UICollectionViewDiffableDataSource<Int, Song>
    typealias CurrentPlaylistSnapshot = NSDiffableDataSourceSnapshot<Int, Song>
    var musicController: MusicController?
    weak var coordinator: MainCoordinator?
    var contentView: UIHostingController<NowPlayingBarView>?
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createCompLayout())
        cv.register(CurrentPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: CurrentPlaylistCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        return cv
    }()
    
    lazy var dataSource: CurrentPlaylistDataSource = {
        let dataSource = CurrentPlaylistDataSource(collectionView: collectionView) { collectionView, indexPath, song -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentPlaylistCollectionViewCell.identifier, for: indexPath) as! CurrentPlaylistCollectionViewCell
            let song = self.musicController?.currentPlaylist[indexPath.item]
            cell.song = song
            
            return cell
        }
        return dataSource
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    private func createCompLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .absolute(UIScreen.main.bounds.width / 5))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 12)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(UIScreen.main.bounds.width / 4.5))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        let layout = UICollectionViewCompositionalLayout(section: layoutSection)
        return layout
    }
    
    private func configureContentView() {
        view.backgroundColor = .backgroundColor
        navigationController?.view.layer.cornerRadius = 20
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        view.layer.cornerRadius = 20
        view.backgroundColor = .backgroundColor
        title = "Now Playing"
        collectionView.delegate = self
    }
    
    private func reloadData() {
//        guard let currentPlaylist = musicController?.currentPlaylist else { return }
        var snapshot = CurrentPlaylistSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(musicController?.currentPlaylist ?? [])
        dataSource.apply(snapshot)
    }
}

extension NowPlayingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        musicController?.playlistSongTapped(index: indexPath.item)
    }
}
