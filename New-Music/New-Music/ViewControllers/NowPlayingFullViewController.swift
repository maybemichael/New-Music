//
//  MusicPlayerControlsViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/19/20.
//

import SwiftUI

class NowPlayingFullViewController: UIViewController, NowPlayingController, FrameDelegate {
    

    var musicController: MusicController!
    weak var coordinator: MainCoordinator?
    var albumArtworkView: UIViewController?
    var contentView: UIViewController?
    
//    let artworkViewHolder: UIView = {
//        let view = UIView(frame: .zero)
//        view.backgroundColor = .clear
//        return view
//    }()
    
    var animationFrame: CGRect = CGRect() {
        didSet {
            self.animationFrameView.frame = self.animationFrame
        }
    }
    
    let animationFrameView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        musicController.nowPlayingViewModel.getFrame.toggle()
    }
    
    private func configureContentView() {
        view.addSubview(animationFrameView)
        animationFrameView.frame = startingFrame()
        self.animationFrame = startingFrame()
//        let contentView = UIHostingController(rootView: NowPlayingFullView(frame: self.animationFrame, musicController: musicController, frameDelegate: self).environmentObject(musicController.nowPlayingViewModel))
        let contentView = UIHostingController(rootView: NowPlayingViewFull2(musicController: musicController, frameDelegate: self).environmentObject(musicController.nowPlayingViewModel))
        self.contentView = contentView
        let backgroundView = UIVisualEffectView()
        backgroundView.effect = UIBlurEffect(style: .light)
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.addSubview(backgroundView)
        backgroundView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
//        backgroundView.frame = self.view.bounds
        addChild(contentView)
        contentView.didMove(toParent: self)
//        backgroundView.contentView.addSubview(contentView.view)
        view.addSubview(contentView.view)
//        contentView.view.anchor(top: backgroundView.contentView.topAnchor, leading: backgroundView.contentView.leadingAnchor, trailing: backgroundView.contentView.trailingAnchor, bottom: backgroundView.contentView.bottomAnchor)
//        contentView.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        contentView.view.frame = view.bounds
        contentView.view.backgroundColor = .clear
        view.backgroundColor = .clear
        let artworkView = UIHostingController(rootView: ArtworkAnimationView(size: UIScreen.main.bounds.width - 80).environmentObject(musicController.nowPlayingViewModel))
        self.albumArtworkView = artworkView
        addChild(artworkView)
        artworkView.didMove(toParent: self)
        artworkView.view.backgroundColor = .clear
    }
    
    private func startingFrame() -> CGRect {
        let horizontalMargin: CGFloat = 40
        let size = UIScreen.main.bounds.width - 80
        let x = horizontalMargin - (size * 0.015)
        let y = UIScreen.main.bounds.height / 6.5
        let width = size + (size * 0.03)
        let height = size + (size * 0.03)
        print("Starting Frame in Now Playing Full: \(CGRect(x: x, y: y, width: width, height: height))")
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func getFrame(frame: CGRect) {
        animationFrame = frame
    }
}
