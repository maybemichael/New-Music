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
    private(set) var window: UIWindow
    private(set) var listenVC = NowPlayingViewController()
    private(set) var tabBarController = UITabBarController()
    private(set) var playlistVC = PlaylistViewController()
    private(set) var navController = UINavigationController(rootViewController: SearchViewController())
    var coordinator: Coordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        setUpAppNavViews()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func setUpAppNavViews() {
        navController.navigationBar.barStyle = .black
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.barTintColor = .backgroundColor
        tabBarController.setViewControllers([navController, listenVC, playlistVC], animated: false)
        tabBarController.tabBar.barTintColor = .backgroundColor
        listenVC.tabBarItem = UITabBarItem(title: "Playing Now", image: UIImage(systemName: "music.quarternote.3"), tag: 0)
        navController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        playlistVC.tabBarItem = UITabBarItem(title: "Playlists", image: UIImage(systemName: "heart.fill"), tag: 2)
    }
}
