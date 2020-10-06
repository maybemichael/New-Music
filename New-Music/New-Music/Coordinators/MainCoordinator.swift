//
//  MainCoordinator.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

class MainCoordinator {
    private var window: UIWindow
    private var nowPlayingVC = NowPlayingViewController()
    private var tabBarController = UITabBarController()
    private var playlistVC = PlaylistViewController()
    private var navController = UINavigationController(rootViewController: SearchViewController())
    private var musicController = MusicController()
    var coordinator: Coordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        setUpAppNavViews()
        passMusicController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func setUpAppNavViews() {
        navController.navigationBar.barStyle = .black
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.barTintColor = .backgroundColor
        tabBarController.setViewControllers([navController, nowPlayingVC, playlistVC], animated: false)
        tabBarController.tabBar.barTintColor = .backgroundColor
        nowPlayingVC.tabBarItem = UITabBarItem(title: "Now Playing", image: UIImage(systemName: "music.quarternote.3"), tag: 0)
        navController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        playlistVC.tabBarItem = UITabBarItem(title: "Playlists", image: UIImage(systemName: "heart.fill"), tag: 2)
//        tabBarController.tabBar.unselectedItemTintColor = .white
        tabBarController.tabBar.tintColor = .white
    }
    
    private func passMusicController() {
        nowPlayingVC.musicController = musicController
        playlistVC.musicController = musicController
        if let searchVC = navController.topViewController as? SearchViewController {
            searchVC.musicController = musicController
            
        }
    }
}
