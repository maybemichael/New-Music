//
//  PlaylistViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI
import Combine

class PlaylistViewController: UIViewController {
    private var subscriptions = Set<AnyCancellable>()
    private var nowPlayingViewModel: NowPlayingViewModel!
    var musicController: MusicController!
    weak var coordinator: MainCoordinator?
    let artistLabel = UILabel()
    var backgroundColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundColor
        navigationController?.view.layer.cornerRadius = 20
        configureContentView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func configureContentView() {
        let height = view.frame.size.height
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 50
        let contentView = UIHostingController(rootView: NowPlayingView(musicController: musicController, isFullScreen: musicController.nowPlayingViewModel.isFullScreen, height: height, tabBarHeight: tabBarHeight).environmentObject(musicController.nowPlayingViewModel))
        view.backgroundColor = .backgroundColor
        addChild(contentView)
        view.addSubview((contentView.view))
        contentView.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        view.layer.cornerRadius = 20
    }
}
