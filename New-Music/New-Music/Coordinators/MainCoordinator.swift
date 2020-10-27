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

class MainCoordinator: NSObject, TabBarStatus {
    func toggleHidden(isFullScreen: Bool) {
        if isFullScreen {
            tabBarController.tabBar.isHidden = true
        } else {
            tabBarController.tabBar.isHidden = false
        }
    }
    
    private var window: UIWindow
    private var nowPlayingBarVC = NowPlayingBarViewController()
    private var tabBarController = UITabBarController()
    private var playlistVC = PlaylistViewController()
    private var navController = UINavigationController(rootViewController: SearchViewController())
    private var musicController = MusicController()
    private var nowPlayingVC = NowPlayingViewController()
    lazy var some = ViewControllerWrapper(viewController: NowPlayingViewController())
    let interactor = Interactor()
    weak var coordinator: Coordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        nowPlayingBarVC.coordinator = self
        setUpAppNavViews()
        passDependencies()
        window.rootViewController = tabBarController
        
        window.makeKeyAndVisible()
    }
    
    private func setUpAppNavViews() {
        navController.navigationBar.barStyle = .black
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.barTintColor = .backgroundColor
        tabBarController.setViewControllers([navController, nowPlayingBarVC, playlistVC], animated: false)
        tabBarController.tabBar.barTintColor = .backgroundColor
        nowPlayingBarVC.tabBarItem = UITabBarItem(title: "Now Playing", image: UIImage(systemName: "music.quarternote.3"), tag: 0)
        navController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        playlistVC.tabBarItem = UITabBarItem(title: "Playlists", image: UIImage(systemName: "heart.fill"), tag: 2)
        tabBarController.tabBar.tintColor = .white
    }
    
    private func passDependencies() {
        nowPlayingVC.musicController = musicController
        nowPlayingBarVC.musicController = musicController
        playlistVC.musicController = musicController
        if let searchVC = navController.topViewController as? SearchViewController {
            searchVC.musicController = musicController
        }
    }
    
    func presentFullScreenNowPlaying(fromVC: UIViewController?) {
        nowPlayingVC.transitioningDelegate = self
        nowPlayingVC.interactor = interactor
        nowPlayingVC.modalPresentationStyle = .custom
        DispatchQueue.main.async {
//            self.navController.pushViewController(self.nowPlayingVC, animated: true)
            self.nowPlayingBarVC.present(self.nowPlayingVC, animated: true, completion: nil)
        }
    }
}

extension MainCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DismissAnimator(type: .modal)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.isStarted ? interactor : nil
    }
}
