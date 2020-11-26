//
//  MainCoordinator.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI

protocol Coordinator: AnyObject {
    func start()
}

class MainCoordinator: NSObject {
    
    private var window: UIWindow
    private var nowPlayingNav = UINavigationController(rootViewController: NowPlayingViewController())
    private var tabBarController = AppTabBarViewController()
    private var playlistNav = UINavigationController(rootViewController: PlaylistViewController()) 
    private var searchNav = UINavigationController(rootViewController: SearchViewController(isPlaylistSearch: false))
    private var musicController = MusicController()
    private var nowPlayingFullVC = NowPlayingFullViewController()
    private var transitionCoordinator = NowPlayingTransitionCoordinator()
    private var nowPlayingBarVC =  NowPlayingBarViewController()
    private var transitionAnimator: UIViewPropertyAnimator?
    private var childVCCoordinator = ChildVCCoordinator()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        setUpAppNavViews()
        passDependencies()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        configureNowPlayingView()
    }
    
    private func setUpAppNavViews() {
        searchNav.navigationBar.prefersLargeTitles = true
        tabBarController.setViewControllers([searchNav, nowPlayingNav, playlistNav], animated: false)
        nowPlayingNav.tabBarItem = UITabBarItem(title: "Now Playing", image: UIImage(systemName: "music.quarternote.3"), tag: 0)
        searchNav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        playlistNav.tabBarItem = UITabBarItem(title: "Playlists", image: UIImage(systemName: "heart.fill"), tag: 2)
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = .lightText
    }
    
    private func passDependencies() {
        guard
            let playlistVC = playlistNav.topViewController as? PlaylistViewController,
            let searchVC = searchNav.topViewController as? SearchViewController,
            let nowPlayingVC = nowPlayingNav.topViewController as? NowPlayingViewController
        else { return }
        nowPlayingFullVC.musicController = musicController
        nowPlayingVC.musicController = musicController
        nowPlayingVC.coordinator = self
        playlistVC.musicController = musicController
        playlistVC.coordinator = self
        searchVC.musicController = musicController
        searchVC.coordinator = self
        nowPlayingBarVC.musicController = musicController
        nowPlayingBarVC.coordinator = self
    }
    
    private func configureNowPlayingView() {
        nowPlayingBarVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - (tabBarController.tabBar.bounds.height * 2) + 10, width: UIScreen.main.bounds.width, height: tabBarController.tabBar.bounds.height - 10)
        nowPlayingBarVC.tabBarHeight = tabBarController.tabBar.bounds.height
        nowPlayingBarVC.view.backgroundColor = .clear
        window.insertSubview(nowPlayingBarVC.view, aboveSubview: tabBarController.view)
    }
    
    func presentNowPlayingFullVC() {
        guard
            let navController = self.tabBarController.viewControllers?[self.tabBarController.selectedIndex] as? UINavigationController
//            let presentingVC = navController.topViewController
        else { return }
//        print("Presenting VC: \(presentingVC.description)")
        transitionCoordinator.prepareViewForDismiss(fromVC: nowPlayingFullVC, toVC: navController, finalFrame: nowPlayingBarVC.view.frame, centerPoint: nowPlayingBarVC.view.center)
//        transitionCoordinator.prepareViewForDismiss(fromVC: nowPlayingFullVC, toVC: presentingVC, finalFrame: nowPlayingBarVC.view.frame)
        DispatchQueue.main.async {
            navController.present(self.nowPlayingFullVC, animated: true, completion: nil)
//            presentingVC.present(self.nowPlayingFullVC, animated: true, completion: nil)
        }
    }
    
    func dismissNowPlayingVC() {
        tabBarController.dismiss(animated: true, completion: nil)
    }
    
    func presentCreatePlaylistVC() {
        let createPlaylistNav = UINavigationController(rootViewController: CreatePlaylistViewController())
        let createPlaylistVC = createPlaylistNav.topViewController as! CreatePlaylistViewController
        createPlaylistVC.musicController = musicController
        createPlaylistVC.coordinator = self
        playlistNav.present(createPlaylistNav, animated: true)
    }
    
    func passTabBarSelectedView() {
        guard
            let navController = self.tabBarController.viewControllers?[self.tabBarController.selectedIndex] as? UINavigationController
        else { return }
        nowPlayingBarVC.tabBarSelectedView = navController.view
    }

    func updateProgress(progress: CGFloat) {
        if transitionAnimator != nil && transitionAnimator!.isRunning {
            transitionAnimator?.fractionComplete = progress
        }
    }
    
    func getPlaylistCellView(for indexPath: IndexPath, with song: Song, moveTo parent: UIViewController) -> UIViewController {
        childVCCoordinator.addChild(parent: parent, indexPath: indexPath, musicController: musicController, song: song)
    }
    
    func removePlaylistCellView(for indexPath: IndexPath) {
        childVCCoordinator.remove(at: indexPath)
    }
    
    func getViewController(indexPath: IndexPath) -> UIViewController? {
        childVCCoordinator.viewControllersByIndexPath[indexPath]
    }
}
