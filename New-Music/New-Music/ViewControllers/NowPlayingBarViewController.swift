//
//  NowPlayingViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI

class NowPlayingBarViewController: UIViewController, TabBarStatus {

    var musicController: MusicController? {
        didSet {
//            configureContentView()
        }
    }
    @Namespace var namespace
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
        let height = view.safeAreaLayoutGuide.layoutFrame.height
        print("This is the height: \(height)")
        guard let tabBar = tabBarController?.tabBar else { return }
        let tabBarHeight = tabBar.frame.size.height
//        let contentView = UIHostingController(rootView: NowPlayingView(musicController: musicController, delegate: self, isFullScreen: musicController.nowPlayingViewModel.isFullScreen, height: height, tabBarHeight: tabBarHeight).environmentObject(musicController.nowPlayingViewModel))
        guard let musicController = musicController else { return }
//        let contentView = UIHostingController(rootView: NowPlayingBar(musicController: musicController, isFullScreen: musicController.nowPlayingViewModel.isFullScreen, namespace: namespace).environmentObject(musicController.nowPlayingViewModel))
        
        let contentView = UIHostingController(rootView: NowPlayingView2(musicController: musicController, delegate: self, tabBarHeight: tabBarHeight).environmentObject(musicController.nowPlayingViewModel))
        addChild(contentView)
        contentView.didMove(toParent: self)
        view.addSubview((contentView.view))
//        contentView.view.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, size: CGSize(width: UIScreen.main.bounds.width, height: 100))
        contentView.view.frame = self.view.frame
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
//        contentView.view.backgroundColor = UIColor.backgroundColor
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentNowPlayingFull(_:)))
//        contentView.view.addGestureRecognizer(tapGesture)
        self.tabBarController?.tabBar.isHidden = false
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
