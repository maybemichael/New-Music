//
//  MusicPlayerControlsViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/19/20.
//

import SwiftUI

class NowPlayingFullViewController: UIViewController {

    var musicController: MusicController! 
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
    }
    
    private func configureContentView() {
        let contentView = UIHostingController(rootView: NowPlayingFullView(musicController: musicController).environmentObject(musicController.nowPlayingViewModel))
        let backgroundView = UIVisualEffectView()
        backgroundView.effect = UIBlurEffect(style: .light)
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.addSubview(backgroundView)
        backgroundView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        addChild(contentView)
        contentView.didMove(toParent: self)
        view.addSubview(contentView.view)
        contentView.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        contentView.view.backgroundColor = .clear
        view.backgroundColor = .clear
    }
}
