//
//  NowPlayingMinimizedViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 12/2/20.
//

import SwiftUI

class NowPlayingMinimizedViewController: UIViewController, NowPlayingController, FrameDelegate {
    

    var musicController: MusicController?
    weak var coordinator: MainCoordinator?
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
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(presentFullScreenNowPlaying))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(animationFrameView)
        animationFrameView.frame = CGRect(x: 20, y: 5, width: 55, height: 55)
        self.animationFrame = animationFrameView.frame
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        view.addSubview(blurView)
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        blurView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        guard let musicController = self.musicController else { return }
        let nowPlayingMinimizedVC = UIHostingController(rootView: NowPlayingMinimized2(musicController: musicController, height: 60, frame: animationFrame, frameDelegate: self).environmentObject(musicController.nowPlayingViewModel))
        addChild(nowPlayingMinimizedVC)
        nowPlayingMinimizedVC.didMove(toParent: self)
        view.addSubview(nowPlayingMinimizedVC.view)
//        nowPlayingMinimizedVC.view.frame = view.bounds
        nowPlayingMinimizedVC.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        nowPlayingMinimizedVC.view.backgroundColor = UIColor.backgroundColor?.withAlphaComponent(0.4)
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func presentFullScreenNowPlaying() {
        coordinator?.presentNowPlayingFullVC()
    }
    
    func getFrame(frame: CGRect) {
        self.animationFrame = frame
    }
}
