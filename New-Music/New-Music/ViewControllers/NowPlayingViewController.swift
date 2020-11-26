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
    var childVCCoordinator = ChildVCCoordinator()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createCompLayout())
        cv.register(CurrentPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: CurrentPlaylistCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        return cv
    }()
    
    lazy var dataSource: CurrentPlaylistDataSource = {
        let dataSource = CurrentPlaylistDataSource(collectionView: collectionView) { collectionView, indexPath, song -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentPlaylistCollectionViewCell.identifier, for: indexPath) as! CurrentPlaylistCollectionViewCell
            guard
                let song = self.musicController?.currentPlaylist[indexPath.item],
                let viewController = self.coordinator?.getPlaylistCellView(for: indexPath, with: song, moveTo: self) as? PlayingIndicatorViewController
            else { fatalError("fatal error in NowPlayingViewController data source for collection view") }
            
            viewController.view.backgroundColor = .clear
            cell.hostedView = viewController.view
            viewController.song = song
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewController = coordinator?.getViewController(indexPath: indexPath) else { return }
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        coordinator?.removePlaylistCellView(for: indexPath)
    }
}
