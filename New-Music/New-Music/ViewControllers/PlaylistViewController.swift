//
//  PlaylistViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI

class PlaylistViewController: UIViewController, TabBarStatus {
    
    func addGestureRecognizer<Content>(viewController: UIHostingController<Content>) where Content : View {
        
    }
    var musicController: MusicController!
    var interactor: Interactor?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundColor
        configureContentView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func configureContentView() {
        let height = view.frame.size.height
//        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 50
//        let contentView = UIHostingController(rootView: NowPlayingView(musicController: musicController, delegate: self, isFullScreen: musicController.nowPlayingViewModel.isFullScreen, height: height, tabBarHeight: tabBarHeight).environmentObject(musicController.nowPlayingViewModel))
//        view.backgroundColor = .backgroundColor
//        addChild(contentView)
//        view.addSubview((contentView.view))
//        contentView.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        view.layer.cornerRadius = 20
    }
    func toggleHidden(isFullScreen: Bool, viewController: UIViewController?) {
        if isFullScreen {
            tabBarController?.tabBar.isHidden = true
        } else {
            tabBarController?.tabBar.isHidden = false
        }
    }
}

extension PlaylistViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator(type: .modal, animationType: .dismiss, interactor: interactor)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator(type: .modal, animationType: .present, interactor: interactor)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let interactor = self.interactor else { return nil }
        return interactor.isStarted ? interactor : nil
    }
}
