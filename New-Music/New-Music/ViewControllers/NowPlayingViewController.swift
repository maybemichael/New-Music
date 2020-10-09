//
//  NowPlayingViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI
import MediaPlayer

class NowPlayingViewController: UIViewController {
    
    var musicController: MusicController!
    
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
        let contentView = UIHostingController(rootView: NowPlayingView(viewModel: musicController.nowPlayingViewModel, musicController: self.musicController))
        view.backgroundColor = .backgroundColor
        addChild(contentView)
        view.addSubview(contentView.view)
        contentView.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
}


