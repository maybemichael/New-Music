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
        nowPlayingBarVC.childVC = nowPlayingContainerVC
        if let searchVC = navController.topViewController as? SearchViewController {
            searchVC.musicController = musicController
        }
    }
    
    private func configureNowPlayingView() {
        let nowPlayingView = UIVisualEffectView()
        nowPlayingView.effect = UIBlurEffect(style: .prominent)
        let contentView = UIHostingController(rootView: NowPlayingBarView(musicController: musicController).environmentObject(musicController.nowPlayingViewModel))
        nowPlayingView.contentView.addSubview(contentView.view)
        contentView.view.backgroundColor = .clear
        
        window.insertSubview(nowPlayingView, aboveSubview: tabBarController.view)
        nowPlayingView.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - (tabBarController.tabBar.bounds.height * 2) + 10, width: UIScreen.main.bounds.width, height: tabBarController.tabBar.bounds.height - 10)
        contentView.view.anchor(top: nowPlayingView.topAnchor, leading: nowPlayingView.leadingAnchor, trailing: nowPlayingView.trailingAnchor, bottom: nowPlayingView.bottomAnchor)
        nowPlayingView.contentView.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentNowPlayingFull(_:)))
        nowPlayingView.addGestureRecognizer(tapGesture)
    }
    
    func presentFullScreenNowPlaying(fromVC: UIViewController?) {
        nowPlayingVC.transitioningDelegate = self
        nowPlayingVC.interactor = interactor
        nowPlayingVC.modalPresentationStyle = .custom
        DispatchQueue.main.async {
            self.nowPlayingBarVC.present(self.nowPlayingVC, animated: true, completion: nil)
        }
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
