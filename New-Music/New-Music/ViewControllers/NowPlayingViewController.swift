//
//  NowPlayingViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI

class NowPlayingViewController: UIViewController {
    

    var musicController: MusicController? {
        didSet {
//            configureContentView()
        }
    }
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @Namespace var namespace
    weak var coordinator: MainCoordinator?
    var contentView: UIHostingController<NowPlayingBarView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func navBarView() {
        guard
            let navBar = navigationController?.navigationBar,
            let musicController = self.musicController
        else { return }
        let navBarBlurView = UIVisualEffectView()
        navBarBlurView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
        navBarBlurView.contentView.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - navBar.bounds.height, width: UIScreen.main.bounds.width, height: navBar.bounds.height)
        let navBarBackground = UIHostingController(rootView: TabBarBackgroundView().environmentObject(musicController.nowPlayingViewModel))
        navBarBlurView.contentView.addSubview(navBarBackground.view)
        navBarBackground.view.anchor(top: navBarBlurView.contentView.topAnchor, leading: navBarBlurView.contentView.leadingAnchor, trailing: navBarBlurView.contentView.trailingAnchor, bottom: navBarBlurView.contentView.bottomAnchor)
        navBarBackground.view.backgroundColor = .clear
        navBar.layer.cornerRadius = 20
        navBar.insertSubview(navBarBlurView.contentView, at: 1)
    }
    
    
    private func configureContentView() {
        view.backgroundColor = .backgroundColor
        navigationController?.view.layer.cornerRadius = 20
        guard let musicController = musicController else { return }
        let contentView = UIHostingController(rootView: NowPlayingPlaylistView().environmentObject(musicController.nowPlayingViewModel))
        
        addChild(contentView)
        contentView.didMove(toParent: self)
        view.addSubview((contentView.view)!)
        contentView.view.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        contentView.view.layer.cornerRadius = 20
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = .backgroundColor
//        contentView.view.backgroundColor = .clear
    }
}

protocol TabBarStatus {
    func toggleHidden(isFullScreen: Bool, viewController: UIViewController?)
    
    func addGestureRecognizer<Content>(viewController: UIHostingController<Content>) where Content : View
}

protocol FullScreenNowPlaying {
    func presentFullScreen()
}
