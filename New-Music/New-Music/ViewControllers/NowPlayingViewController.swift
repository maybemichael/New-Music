//
//  NowPlayingViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI

class NowPlayingViewController: UIViewController {
    
    typealias CurrentPlaylistDataSource = UICollectionViewDiffableDataSource<Playlist, Song>
    typealias CurrentPlaylistSnapshot = NSDiffableDataSourceSnapshot<Playlist, Song>
    var musicController: MusicController?
    weak var coordinator: MainCoordinator?
    var childVCCoordinator = ChildVCCoordinator()
   
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.setSize(width: UIScreen.main.bounds.width, height: 1)
        return view
    }()
    
//    lazy var collectionView: UICollectionView = {
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: createCompLayout())
//        cv.register(CurrentPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: CurrentPlaylistCollectionViewCell.identifier)
//        cv.backgroundColor = .clear
//        cv.contentInset.bottom = 66
//        return cv
//    }()
    
    lazy var collectionView: UICollectionView = {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        layoutConfig.headerMode = .supplementary
        layoutConfig.backgroundColor = .backgroundColor
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let cv = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cv.backgroundColor = .clear
        cv.contentInset.bottom = UIScreen.main.bounds.width / 8
        cv.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        cv.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        return cv
    }()
    
//    lazy var dataSource: CurrentPlaylistDataSource = {
//        let dataSource = CurrentPlaylistDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, song -> UICollectionViewCell? in
//            guard let self = self else { return nil }
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentPlaylistCollectionViewCell.identifier, for: indexPath) as! CurrentPlaylistCollectionViewCell
//            guard
//                let song = self.musicController?.currentPlaylist[indexPath.item],
//                let viewController = self.coordinator?.getPlaylistCellView(for: indexPath, with: song, moveTo: self) as? PlayingIndicatorViewController
//            else { fatalError("fatal error in NowPlayingViewController data source for collection view") }
//
//            viewController.view.backgroundColor = .clear
//            cell.hostedView = viewController.view
//            viewController.song = song
//            cell.song = song
//
//            return cell
//        }
//        return dataSource
//    }()
    lazy var dataSource: CurrentPlaylistDataSource = {
        let dataSource = CurrentPlaylistDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, song -> UICollectionViewCell? in
            guard let self = self else { fatalError() }
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.makeCustomPlaylistCellRegistration(), for: indexPath, item: song)
            
            cell.song = song
            cell.backgroundColor = .clear
            cell.playID = song.playID
            
            return cell
        }
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            guard let self = self else { return nil }
            
            let headerView = collectionView.dequeueConfiguredReusableSupplementary(using: self.makePlaylistHeaderRegistration(), for: indexPath)
            return headerView
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
        guard let musicController = self.musicController else { return }
        musicController.nowPlayingViewModel.playID = musicController.nowPlayingViewModel.playID
        musicController.nowPlayingViewModel.isPlaying = musicController.nowPlayingViewModel.isPlaying
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
        navigationItem.title = "Now Playing..."
        collectionView.delegate = self
        view.addSubview(separatorView)
        separatorView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.centerXAnchor)
    }
    
    private func reloadData() {
        var snapshot = CurrentPlaylistSnapshot()
        guard let playlist = musicController?.nowPlayingPlaylist else { return }
        snapshot.appendSections([playlist])
        snapshot.appendItems(playlist.songs)
        dataSource.apply(snapshot)
    }
    
    private func makePlaylistHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        let playlistHeaderRegistration = UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { (header: UICollectionViewListCell, string, indexPath) in
            var content = header.defaultContentConfiguration()
            content.textProperties.font = UIFont.preferredFont(forTextStyle: .headline).withSize(25)
            content.secondaryTextProperties.color = .white
            content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .headline).withSize(25)
            let playlist = self.dataSource.snapshot().sectionIdentifiers.first!
            content.secondaryText = playlist.playlistName
            header.contentConfiguration = content
        }
        return playlistHeaderRegistration
    }
    
    private func makeCustomPlaylistCellRegistration() -> UICollectionView.CellRegistration<NowPlayingCollectionViewCell, Song> {
        let playlistCellRegistration = UICollectionView.CellRegistration<NowPlayingCollectionViewCell, Song> { [weak self] cell, indexPath, song in
            guard
                let self = self,
                let nowPlayingViewModel = self.musicController?.nowPlayingViewModel
            else { return }
            cell.song = song
            cell.nowPlayingViewModel = nowPlayingViewModel
            cell.playID = self.musicController?.nowPlayingViewModel.nowPlayingSong?.playID
        }
        return playlistCellRegistration
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
