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
    
    private func configureContentView() {
        view.backgroundColor = .backgroundColor
        navigationController?.view.layer.cornerRadius = 25
        navigationController?.navigationBar.prefersLargeTitles = true
        guard let musicController = musicController else { return }
        let contentView = UIHostingController(rootView: NowPlayingPlaylistView().environmentObject(musicController.nowPlayingViewModel))
        
        addChild(contentView)
        contentView.didMove(toParent: self)
        view.addSubview((contentView.view)!)
        contentView.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        contentView.view.layer.cornerRadius = 25
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.backgroundColor = .backgroundColor
        title = "Now Playing"
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
