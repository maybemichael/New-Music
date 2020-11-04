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
    private var searchNav = UINavigationController(rootViewController: SearchViewController())
    private var musicController = MusicController()
    private var nowPlayingFullVC = NowPlayingFullViewController()
    private var transitionCoordinator = NowPlayingTransitionCoordinator()
    private var nowPlayingBarVC =  NowPlayingBarViewController()
    
    let height = UIScreen.main.bounds.height / 11
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        setUpAppNavViews()
        passDependencies()
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        configureNowPlayingView()
        configureTabBarBlurView()
    }
    
    private func setUpAppNavViews() {
        searchNav.navigationBar.barStyle = .black
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
        nowPlayingBarVC.coordinator = self
    }
    
    private func configureNowPlayingView() {
        nowPlayingBarVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - (tabBarController.tabBar.bounds.height * 2) + 10, width: UIScreen.main.bounds.width, height: tabBarController.tabBar.bounds.height - 10)
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
        let contentView = UIHostingController(rootView: NowPlayingBarView(musicController: musicController).environmentObject(musicController.nowPlayingViewModel))
        nowPlayingBarVC.view.addSubview(blurView)
        blurView.contentView.addSubview(contentView.view)
        blurView.anchor(top: nowPlayingBarVC.view.topAnchor, leading: nowPlayingBarVC.view.leadingAnchor, trailing: nowPlayingBarVC.view.trailingAnchor, bottom: nowPlayingBarVC.view.bottomAnchor)
        contentView.view.backgroundColor = .clear
        nowPlayingBarVC.view.backgroundColor = .clear
        contentView.view.anchor(top: blurView.contentView.topAnchor, leading: blurView.contentView.leadingAnchor, trailing: blurView.contentView.trailingAnchor, bottom: blurView.contentView.bottomAnchor)
        window.insertSubview(nowPlayingBarVC.view, aboveSubview: tabBarController.view)
    }
    
    func presentNowPlayingFullVC() {
        guard
            let navController = self.tabBarController.viewControllers?[self.tabBarController.selectedIndex] as? UINavigationController,
            let presentingVC = navController.topViewController
        else { return }
        print("Presenting VC: \(presentingVC.description)")
        transitionCoordinator.prepareViewForDismiss(fromVC: nowPlayingFullVC, toVC: presentingVC, finalFrame: nowPlayingBarVC.view.frame)
        DispatchQueue.main.async {
            presentingVC.present(self.nowPlayingFullVC, animated: true, completion: nil)
        }
    }
    
    func dismissNowPlayingVC() {
        tabBarController.dismiss(animated: true, completion: nil)
    }
    
    private func configureTabBarBlurView() {
        let tabBarBlurView = UIVisualEffectView()
        tabBarBlurView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
        tabBarBlurView.contentView.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - tabBarController.tabBar.bounds.height, width: UIScreen.main.bounds.width, height: tabBarController.tabBar.bounds.height)
        let tabBarBackground = UIHostingController(rootView: TabBarBackgroundView().environmentObject(musicController.nowPlayingViewModel))
        tabBarBlurView.contentView.addSubview(tabBarBackground.view)
        tabBarBackground.view.anchor(top: tabBarBlurView.contentView.topAnchor, leading: tabBarBlurView.contentView.leadingAnchor, trailing: tabBarBlurView.contentView.trailingAnchor, bottom: tabBarBlurView.contentView.bottomAnchor)
        tabBarBackground.view.backgroundColor = .clear
        tabBarController.view.insertSubview(tabBarBlurView.contentView, at: 1)
    }
}
