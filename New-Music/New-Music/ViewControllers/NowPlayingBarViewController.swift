//
//  NowPlayingContainerViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/30/20.
//

import SwiftUI

class NowPlayingBarViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    weak var tabBarSelectedView: UIView?
    var fullFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    var minimizedFrame = CGRect()
    var artworkViewFrame = CGRect()
    var blurView = UIVisualEffectView()
    var minimizedNowPlayingFrame = CGRect()
    var tabBarHeight = CGFloat()
    var childVCs = [UIViewController]()
    private var transitionAnimator: UIViewPropertyAnimator?
    var currentState: NowPlayingViewState = .minimized {
        didSet {
            if self.currentState == .full {
                view.removeGestureRecognizer(tapGesture)
            } else {
                view.addGestureRecognizer(tapGesture)
            }
        }
    }
    var musicController: MusicController!
    lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(nowPlayingViewPanGesture(_:)))
        return gesture
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(presentFullScreenNowPlaying(_:)))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        addChildVCs()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private func configureSubviews() {
        minimizedFrame = CGRect(x: 0, y: UIScreen.main.bounds.midY + (tabBarHeight * 2) + 10, width: UIScreen.main.bounds.width, height: tabBarHeight - 10)
        view.backgroundColor = .clear
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)
        tapGesture.require(toFail: panGesture)
        
    }
    
    
    func createAnimator() {
        coordinator?.passTabBarSelectedView()
        tabBarSelectedView?.transform = CGAffineTransform(scaleX: 0.87, y: 0.87)
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
            self.tabBarSelectedView?.transform = .identity
            self.tabBarSelectedView?.layoutIfNeeded()
        }
        animator.addCompletion({ position in
            switch position {
            case .start:
                self.tabBarSelectedView?.transform = .identity
            case .end:
                self.tabBarSelectedView?.transform = .identity
            default:
                self.tabBarSelectedView?.transform = .identity
            }
        })
        animator.isInterruptible = true
        animator.scrubsLinearly = true
        self.transitionAnimator = animator
        self.transitionAnimator?.startAnimation()
    }
    private func addChildVCs() {
        blurView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
        view.addSubview(blurView)
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        blurView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        let artworkView = UIHostingController(rootView: ArtworkView().environmentObject(musicController.nowPlayingViewModel))
        addChild(artworkView)
        artworkView.didMove(toParent: self)
        childVCs.append(artworkView)
        let fullPlayerView = UIHostingController(rootView: NowPlayingFullView(isPresented: .constant(true), musicController: musicController).environmentObject(musicController.nowPlayingViewModel))
        addChild(fullPlayerView)
        fullPlayerView.didMove(toParent: self)
        view.addSubview(fullPlayerView.view)
        view.addSubview(artworkView.view)
        fullPlayerView.view.frame = view.bounds
        artworkView.view.backgroundColor = .clear
        artworkView.view.frame = CGRect(x: 20, y: view.bounds.minY + 8, width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7)
        self.artworkViewFrame = artworkView.view.frame
        artworkView.view.clipsToBounds = true
        fullPlayerView.view.backgroundColor = .clear
        childVCs.append(fullPlayerView)
        
        // MARK: - Minimized Now Playing View
        let minimizedNowPlayingView = UIHostingController(rootView: NowPlayingMinimized(musicController: musicController).environmentObject(musicController.nowPlayingViewModel))
        addChild(minimizedNowPlayingView)
        minimizedNowPlayingView.didMove(toParent: self)
        view.addSubview(minimizedNowPlayingView.view)
        minimizedNowPlayingView.view.backgroundColor = .clear
        childVCs.append(minimizedNowPlayingView)
        minimizedNowPlayingView.view.frame = CGRect(x: artworkView.view.frame.maxX, y: artworkView.view.frame.minY, width: UIScreen.main.bounds.width - (artworkView.view.frame.width + 20), height: UIScreen.main.bounds.width / 7)
        self.minimizedNowPlayingFrame = minimizedNowPlayingView.view.frame
        
    }
    
    @objc func presentFullScreenNowPlaying(_ sender: UITapGestureRecognizer) {
//        coordinator?.presentNowPlayingFullVC()
        expandNowPlayingBar()
    }
    
    private func expandNowPlayingBar() {
        self.blurView.effect = UIBlurEffect(style: .light)
        self.childVCs[2].view.alpha = 0
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1.0) {
            self.view.frame = self.fullFrame
            self.view.layer.cornerRadius = 25
            self.childVCs[0].view.frame = CGRect(x: self.view.safeAreaInsets.left + 40, y: self.view.safeAreaInsets.top + 140, width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80)
            self.childVCs[1].view.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, bottom: self.view.bottomAnchor)
            self.musicController.nowPlayingViewModel.isFullScreen = true
            self.view.layer.cornerRadius = 25
            self.view.layoutIfNeeded()
        }
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = .minimized
                self.musicController.nowPlayingViewModel.isFullScreen = false
            case .end:
                self.currentState = .full
                self.musicController.nowPlayingViewModel.isFullScreen = true
            default:
                break
            }
        }
        transitionAnimator.startAnimation()
    }
    
    private func animateToBarView() {
        self.blurView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.4, curve: .linear) { 
            self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - (self.tabBarHeight * 2) + 10, width: UIScreen.main.bounds.width, height: self.tabBarHeight - 10)
            self.view.layer.cornerRadius = 0
            self.blurView.contentView.frame = self.minimizedFrame
            self.childVCs[0].view.frame = self.artworkViewFrame
            self.childVCs[1].view.frame = self.minimizedFrame
            self.childVCs[2].view.alpha = 1
            self.musicController.nowPlayingViewModel.isFullScreen = false
            self.view.layoutIfNeeded()
        }
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = .full
                self.musicController.nowPlayingViewModel.isFullScreen = true
            case .end:
                self.currentState = .minimized
                self.musicController.nowPlayingViewModel.isFullScreen = false
            default:
                break
            }
        }
        transitionAnimator.startAnimation()
    }
    
    private func bounceBackFull() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.1, dampingRatio: 1.0) {
            self.view.frame = self.fullFrame
            self.view.layoutIfNeeded()
        }
        transitionAnimator.addCompletion { _ in
            self.currentState = .full
        }
        transitionAnimator.startAnimation()
    }
    
    @objc private func nowPlayingViewPanGesture(_ recognizer: UIPanGestureRecognizer) {
        if self.currentState == .full {
            switch recognizer.state {
            case .began:
                ()
                createAnimator()
            case .changed:
                if transitionAnimator!.isRunning {
                    transitionAnimator?.pauseAnimation()
                }
                let translation = recognizer.translation(in: recognizer.view).y
                view.frame = view.bounds.offsetBy(dx: 0, dy: max(translation, 0))
                var percentage =  translation / (UIScreen.main.bounds.height)
                percentage = min(percentage, 0.999)
                percentage = max(percentage, 0.001)
                self.transitionAnimator?.fractionComplete = percentage
                view.layoutIfNeeded()
            case .ended:
                self.transitionAnimator?.fractionComplete = 1.0
                transitionAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                self.transitionAnimator = nil
                let yVelocity = recognizer.velocity(in: view).y
                if yVelocity > 400 || view.frame.minY > UIScreen.main.bounds.height / 3 {
                    animateToBarView()
                } else {
                    bounceBackFull()
                }
            default:
                break
            }
        } else {
            switch recognizer.state {
            case .began:
                ()
            case .changed:
                ()
            case .ended:
                let yVelocity = recognizer.velocity(in: view).y
                if yVelocity < 0 {
                    expandNowPlayingBar()
                }
            default:
                break
            }
        }
    }
}
