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
    func toggleHidden(isFullScreen: Bool) {
        if isFullScreen {
            tabBarController.tabBar.isHidden = true
        } else {
            tabBarController.tabBar.isHidden = false
        }
    }
    
    private var window: UIWindow
    private var nowPlayingBarVC = NowPlayingBarViewController()
    private var tabBarController = AppTabBarViewController()
    private var playlistVC = PlaylistViewController()
    private var navController = UINavigationController(rootViewController: SearchViewController())
    private var musicController = MusicController()
    private var nowPlayingVC = NowPlayingViewController()
    lazy var some = ViewControllerWrapper(viewController: NowPlayingViewController())
    private var nowPlayingContainerVC =  NowPlayingContainerViewController()
    let interactor = Interactor()
    weak var coordinator: Coordinator?
    
    let height = UIScreen.main.bounds.height / 11
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        nowPlayingBarVC.coordinator = self
        setUpAppNavViews()
        passDependencies()
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        configureNowPlayingView()
        configureTabBarBlurView()
    }
    
    private func setUpAppNavViews() {
        navController.navigationBar.barStyle = .black
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.barTintColor = .backgroundColor
        tabBarController.setViewControllers([navController, nowPlayingBarVC, playlistVC], animated: false)
//        tabBarController.tabBar.barTintColor = .backgroundColor
//        tabBarController.tabBar.isTranslucent = true
//        tabBarController.tabBar.barTintColor = .clear
//        tabBarController.view.backgroundColor = .clear
        
        nowPlayingBarVC.tabBarItem = UITabBarItem(title: "Now Playing", image: UIImage(systemName: "music.quarternote.3"), tag: 0)
        navController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        playlistVC.tabBarItem = UITabBarItem(title: "Playlists", image: UIImage(systemName: "heart.fill"), tag: 2)
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = .lightText
    }
    
    private func passDependencies() {
        nowPlayingVC.musicController = musicController
        nowPlayingBarVC.musicController = musicController
        playlistVC.musicController = musicController
        nowPlayingBarVC.childVC = nowPlayingContainerVC
        if let searchVC = navController.topViewController as? SearchViewController {
            searchVC.musicController = musicController
        }
    }
    
    private func configureNowPlayingView() {
        nowPlayingContainerVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - (tabBarController.tabBar.bounds.height * 2) + 10, width: UIScreen.main.bounds.width, height: tabBarController.tabBar.bounds.height - 10)
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
        let contentView = UIHostingController(rootView: NowPlayingBarView(musicController: musicController).environmentObject(musicController.nowPlayingViewModel))
        nowPlayingContainerVC.view.addSubview(blurView)
        blurView.contentView.addSubview(contentView.view)
        blurView.anchor(top: nowPlayingContainerVC.view.topAnchor, leading: nowPlayingContainerVC.view.leadingAnchor, trailing: nowPlayingContainerVC.view.trailingAnchor, bottom: nowPlayingContainerVC.view.bottomAnchor)
        contentView.view.backgroundColor = .clear
        nowPlayingContainerVC.view.backgroundColor = .clear
        contentView.view.anchor(top: blurView.contentView.topAnchor, leading: blurView.contentView.leadingAnchor, trailing: blurView.contentView.trailingAnchor, bottom: blurView.contentView.bottomAnchor)
        window.insertSubview(nowPlayingContainerVC.view, aboveSubview: tabBarController.view)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentNowPlayingFull(_:)))
        nowPlayingContainerVC.view.addGestureRecognizer(tapGesture)
    }
    
    func presentFullScreenNowPlaying(fromVC: UIViewController?) {
        nowPlayingVC.transitioningDelegate = self
        nowPlayingVC.interactor = interactor
        nowPlayingVC.modalPresentationStyle = .custom
        DispatchQueue.main.async {
            self.nowPlayingBarVC.present(self.nowPlayingVC, animated: true, completion: nil)
        }
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
    
    @objc func presentNowPlayingFull(_ sender: UITapGestureRecognizer) {
        nowPlayingVC.transitioningDelegate = tabBarController
        nowPlayingVC.interactor = tabBarController.interactor
        nowPlayingVC.modalPresentationStyle = .custom
        DispatchQueue.main.async {
            self.tabBarController.present(self.nowPlayingVC, animated: true, completion: nil)
        }
    }
}

extension MainCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DismissAnimator(type: .modal, interactor: nil)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.isStarted ? interactor : nil
    }
}
