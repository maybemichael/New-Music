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
    var margin: CGFloat = 8
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
    
    lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        musicController?.nowPlayingViewModel.getFrame.toggle()
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
        var nowPlayingMinimizedVC = UIViewController()
        if UIDevice.current.userInterfaceIdiom == .phone {
            nowPlayingMinimizedVC = UIHostingController(rootView: NowPlayingMinimized2(musicController: musicController, height: UIScreen.main.bounds.width / 6.2, frame: animationFrame, frameDelegate: self, verticalMargin: 6).environmentObject(musicController.nowPlayingViewModel))
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            nowPlayingMinimizedVC = UIHostingController(rootView: NowPlayingMinimized2(musicController: musicController, height: UIScreen.main.bounds.width / 12, frame: animationFrame, frameDelegate: self, verticalMargin: 6).environmentObject(musicController.nowPlayingViewModel))
        }
//        let nowPlayingMinimizedVC = UIHostingController(rootView: NowPlayingMinimized2(musicController: musicController, height: UIScreen.main.bounds.width / 6.2, frame: animationFrame, frameDelegate: self).environmentObject(musicController.nowPlayingViewModel))
        addChild(nowPlayingMinimizedVC)
        nowPlayingMinimizedVC.didMove(toParent: self)
        view.addSubview(nowPlayingMinimizedVC.view)
//        nowPlayingMinimizedVC.view.frame = view.bounds
        nowPlayingMinimizedVC.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        nowPlayingMinimizedVC.view.backgroundColor = UIColor.backgroundColor?.withAlphaComponent(0.4)
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)
        tapGesture.require(toFail: panGesture)
    }
    
    @objc private func presentFullScreenNowPlaying() {
        coordinator?.presentNowPlayingFullVC()
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let yVelocity = recognizer.velocity(in: recognizer.view).y
            if yVelocity < 0 {
                coordinator?.presentNowPlayingFullVC()
                recognizer.state = .ended
            }
        default:
            break
        }
    }
    
    func getFrame(frame: CGRect) {
        self.animationFrame = frame
    }
}
