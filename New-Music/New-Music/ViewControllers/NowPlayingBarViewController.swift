//
//  NowPlayingViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI

class NowPlayingBarViewController: UIViewController, TabBarStatus {

    var musicController: MusicController!
    weak var coordinator: MainCoordinator?
    let interactor = Interactor()
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
        let height = view.frame.size.height
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 50
        let contentView = UIHostingController(rootView: NowPlayingView(musicController: musicController, delegate: self, isFullScreen: musicController.nowPlayingViewModel.isFullScreen, height: height, tabBarHeight: tabBarHeight).environmentObject(musicController.nowPlayingViewModel))
        view.backgroundColor = .backgroundColor
        addChild(contentView)
        view.addSubview((contentView.view))
        contentView.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentNowPlayingFull(_:)))
//        contentView.view.addGestureRecognizer(tapGesture)
//        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func presentNowPlayingFull(_ sender: UITapGestureRecognizer) {
        coordinator?.presentFullScreenNowPlaying(fromVC: self)
    }
    
    func toggleHidden(isFullScreen: Bool) {
        if isFullScreen {
            tabBarController?.tabBar.isHidden = true
        } else {
            tabBarController?.tabBar.isHidden = false
        }
    }
}

extension NowPlayingBarViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DismissAnimator(type: .modal)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.isStarted ? interactor : nil
    }
}

protocol TabBarStatus {
    func toggleHidden(isFullScreen: Bool)
}
