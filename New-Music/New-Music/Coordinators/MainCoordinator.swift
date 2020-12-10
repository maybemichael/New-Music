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

class MainCoordinator: NSObject, UITabBarControllerDelegate {
    
    private var window: UIWindow
    private var nowPlayingNav = UINavigationController(rootViewController: NowPlayingViewController())
    private var tabBarController = AppTabBarViewController()
    private var playlistNav = UINavigationController(rootViewController: PlaylistViewController()) 
    private var searchNav = UINavigationController(rootViewController: SearchViewController(isPlaylistSearch: false))
    private var musicController = MusicController()
    private var nowPlayingFullVC = NowPlayingFullViewController()
    private lazy var transitionCoordinator = NowPlayingTransitionCoordinator(musicController: musicController)
    private var nowPlayingBarVC =  NowPlayingBarViewController()
    private var transitionAnimator: UIViewPropertyAnimator?
    private var childVCCoordinator = ChildVCCoordinator()
    private lazy var nowPlayingMinimized = NowPlayingMinimizedViewController()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        setUpAppNavViews()
        passDependencies()
        configureNowPlayingView()
        setupNowPlayingBarVC()
    }
    
    private func setUpAppNavViews() {
        searchNav.navigationBar.prefersLargeTitles = true
        tabBarController.viewControllers = [searchNav, nowPlayingNav, playlistNav]
        nowPlayingNav.tabBarItem = UITabBarItem(title: "Now Playing", image: UIImage(systemName: "music.quarternote.3"), tag: 0)
        searchNav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        playlistNav.tabBarItem = UITabBarItem(title: "Playlists", image: UIImage(systemName: "heart.fill"), tag: 2)
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = .lightText
        tabBarController.delegate = self
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
        nowPlayingMinimized.musicController = musicController
        nowPlayingMinimized.coordinator = self
    }
    
    private func configureNowPlayingView() {
//        nowPlayingBarVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - (tabBarController.tabBar.bounds.height * 2) + 10, width: UIScreen.main.bounds.width, height: tabBarController.tabBar.bounds.height - 10)
//        nowPlayingBarVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - (tabBarController.tabBar.frame.height + 66), width: UIScreen.main.bounds.width, height: 65)
//        nowPlayingBarVC.tabBarHeight = tabBarController.tabBar.bounds.height
//        nowPlayingBarVC.view.backgroundColor = .clear
//        nowPlayingBarVC.tabBarSelectedView = tabBarController.view
//        window.insertSubview(nowPlayingBarVC.view, aboveSubview: tabBarController.view)
    }
    
    func presentNowPlayingFullVC() {
        guard
            let navController = self.tabBarController.viewControllers?[self.tabBarController.selectedIndex] as? UINavigationController
//            let presentingVC = navController.topViewController
        else { return }
//        print("Presenting VC: \(presentingVC.description)")
        transitionCoordinator.prepareViewForDismiss(fromVC: nowPlayingFullVC, toVC: navController, finalFrame: nowPlayingMinimized.view.frame, centerPoint: nowPlayingBarVC.view.center)
//        transitionCoordinator.prepareViewForDismiss(fromVC: nowPlayingFullVC, toVC: presentingVC, finalFrame: nowPlayingBarVC.view.frame)
        DispatchQueue.main.async {
            navController.present(self.nowPlayingFullVC, animated: true, completion: nil)
//            presentingVC.present(self.nowPlayingFullVC, animated: true, completion: nil)
        }
    }
    
    private func setupNowPlayingBarVC() {
        let searchVC = searchNav.topViewController as! SearchViewController
        searchVC.addChild(nowPlayingBarVC)
        nowPlayingBarVC.didMove(toParent: searchVC)
//        nowPlayingBarVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - (tabBarController.tabBar.frame.height + 74), width: UIScreen.main.bounds.width, height: 73)
        searchVC.addChild(nowPlayingMinimized)
        nowPlayingMinimized.didMove(toParent: searchVC)
        searchVC.view.addSubview(nowPlayingMinimized.view)
        nowPlayingMinimized.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - (tabBarController.tabBar.frame.height + 66), width: UIScreen.main.bounds.width, height: 65)
        transitionCoordinator.startFrame = nowPlayingMinimized.view.frame
    }
    
    func dismissNowPlayingVC() {
        tabBarController.dismiss(animated: true, completion: nil)
    }
    
    func presentCreatePlaylistVC() {
        let createPlaylistNav = UINavigationController(rootViewController: CreatePlaylistViewController())
        let createPlaylistVC = createPlaylistNav.topViewController as! CreatePlaylistViewController
        createPlaylistVC.musicController = musicController
        createPlaylistVC.coordinator = self
        let playlistVC = playlistNav.topViewController as! PlaylistViewController
        playlistNav.modalPresentationStyle = .fullScreen
        createPlaylistVC.reloadDataDelegate = playlistVC
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let nav = viewController as! UINavigationController
        
        switch nav.topViewController {
        case is SearchViewController:
            let vc = nav.topViewController as! SearchViewController
            nowPlayingMinimized.view.removeFromSuperview()
            nowPlayingMinimized.willMove(toParent: nil)
            nowPlayingMinimized.removeFromParent()
            vc.addChild(nowPlayingMinimized)
            nowPlayingMinimized.didMove(toParent: vc)
            vc.view.addSubview(nowPlayingMinimized.view)
//            nowPlayingBarVC.tabBarSelectedView = tabBarController.view
//            nowPlayingBarVC.tabBarHeight = tabBarController.tabBar.frame.height
            nowPlayingMinimized.view.frame = CGRect(x: UIScreen.main.bounds.minX, y: UIScreen.main.bounds.height - (tabBarController.tabBar.frame.height + 66), width: UIScreen.main.bounds.width, height: 65)
        case is NowPlayingViewController:
            let vc = nav.topViewController as! NowPlayingViewController
            nowPlayingMinimized.view.removeFromSuperview()
            nowPlayingMinimized.willMove(toParent: nil)
            nowPlayingMinimized.removeFromParent()
            vc.addChild(nowPlayingMinimized)
            nowPlayingMinimized.didMove(toParent: vc)
            vc.view.addSubview(nowPlayingMinimized.view)
//            nowPlayingBarVC.tabBarSelectedView = tabBarController.view
//            nowPlayingBarVC.tabBarHeight = tabBarController.tabBar.frame.height
            nowPlayingMinimized.view.frame = CGRect(x: UIScreen.main.bounds.minX, y: UIScreen.main.bounds.height - (tabBarController.tabBar.frame.height + 66), width: UIScreen.main.bounds.width, height: 65)
        case is PlaylistViewController:
            let vc = nav.topViewController as! PlaylistViewController
            nowPlayingMinimized.view.removeFromSuperview()
            nowPlayingMinimized.willMove(toParent: nil)
            nowPlayingMinimized.removeFromParent()
            vc.addChild(nowPlayingMinimized)
            nowPlayingMinimized.didMove(toParent: vc)
            vc.view.addSubview(nowPlayingMinimized.view)
//            nowPlayingBarVC.tabBarSelectedView = tabBarController.view
//            nowPlayingBarVC.tabBarHeight = tabBarController.tabBar.frame.height
            nowPlayingMinimized.view.frame = CGRect(x: UIScreen.main.bounds.minX, y: UIScreen.main.bounds.height - (tabBarController.tabBar.frame.height + 66), width: UIScreen.main.bounds.width, height: 65)
        default:
            break
        }
    }
}
