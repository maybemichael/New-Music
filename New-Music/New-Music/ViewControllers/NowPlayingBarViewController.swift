//
//  NowPlayingViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI

class NowPlayingBarViewController: UIViewController, TabBarStatus, FullScreenNowPlaying {
    

    var musicController: MusicController? {
        didSet {
//            configureContentView()
        }
    }
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @Namespace var namespace
    weak var coordinator: MainCoordinator?
    var childVC: NowPlayingContainerViewController?
    var contentView: UIHostingController<NowPlayingBarView>?
    let interactor = Interactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        viewControllerHolder?.transitioningDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func configureContentView() {
        view.backgroundColor = .backgroundColor
        guard let musicController = musicController else { return }
        let contentView = UIHostingController(rootView: NowPlayingPlaylistView().environmentObject(musicController.nowPlayingViewModel))
        
        addChild(contentView)
        contentView.didMove(toParent: self)
        view.addSubview((contentView.view)!)
        contentView.view.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        contentView.view.layer.cornerRadius = 20
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = .backgroundColor
//        contentView.view.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentNowPlayingFull(_:)))
        contentView.view.addGestureRecognizer(tapGesture)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func presentNowPlayingFull(_ sender: UITapGestureRecognizer) {
        coordinator?.presentFullScreenNowPlaying(fromVC: self)
    }
    
    func toggleHidden(isFullScreen: Bool, viewController: UIViewController?) {
        viewController?.transitioningDelegate = self
        if isFullScreen {
            tabBarController?.tabBar.isHidden = true
        } else {
            tabBarController?.tabBar.isHidden = false
        }
    }
    
    @objc func handleGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.25

        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / (view.bounds.height * 1.2)
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
//        guard let interactor = interactor else { return }

        switch sender.state {
        case .began:
            interactor.isStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.isStarted = false
            interactor.cancel()
        case .ended:
            interactor.isStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    func presentFullScreen() {
        coordinator?.presentFullScreenNowPlaying(fromVC: self)
    }
    
    func addGestureRecognizer<Content>(viewController: UIHostingController<Content>) where Content : View {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        viewController.view.addGestureRecognizer(panGesture)
    }
}

extension NowPlayingBarViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DismissAnimator(type: .modal, interactor: interactor)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.isStarted ? interactor : nil
    }
}

protocol TabBarStatus {
    func toggleHidden(isFullScreen: Bool, viewController: UIViewController?)
    
    func addGestureRecognizer<Content>(viewController: UIHostingController<Content>) where Content : View
}

protocol FullScreenNowPlaying {
    func presentFullScreen()
}
