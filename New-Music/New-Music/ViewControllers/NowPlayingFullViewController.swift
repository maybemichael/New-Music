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
    
    let artworkViewHolder: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    var animationFrame: CGRect = CGRect() {
        didSet {
            self.animationFrameView.frame = self.animationFrame
        }
    }
    
    let animationFrameView: UIView = {
        let view = UIView()
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
        let contentView = UIHostingController(rootView: NowPlayingFullView(frame: self.animationFrame, musicController: musicController, frameDelegate: self).environmentObject(musicController.nowPlayingViewModel))
        self.contentView = contentView
        let backgroundView = UIVisualEffectView()
        backgroundView.effect = UIBlurEffect(style: .light)
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.addSubview(backgroundView)
        backgroundView.frame = self.view.bounds
        addChild(contentView)
        contentView.didMove(toParent: self)
        view.addSubview(contentView.view)
        contentView.view.frame = self.view.bounds
        contentView.view.backgroundColor = .clear
        view.backgroundColor = .clear
        let artworkView = UIHostingController(rootView: ArtworkAnimationView(size: UIScreen.main.bounds.width - 80).environmentObject(musicController.nowPlayingViewModel))
        self.albumArtworkView = artworkView
        addChild(artworkView)
        artworkView.didMove(toParent: self)
        artworkViewHolder.addSubview(artworkView.view)
        artworkView.view.anchor(top: artworkViewHolder.topAnchor, leading: artworkViewHolder.leadingAnchor, trailing: artworkViewHolder.trailingAnchor, bottom: artworkViewHolder.bottomAnchor, padding: .init(top: 5, left: 5, bottom: -5, right: -5))
    }
    
    private func startingFrame() -> CGRect {
        let horizontalMargin: CGFloat = 40
        let size = UIScreen.main.bounds.width - 80
        let x = horizontalMargin - (size * 0.015)
        let y = (UIScreen.main.bounds.height / 6)
        let width = size + (size * 0.03)
        let height = size + (size * 0.03)
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func getFrame(frame: CGRect) {
        animationFrame = frame
    }
}
