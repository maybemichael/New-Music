//
//  AppTabBarViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/30/20.
//

import UIKit

class AppTabBarViewController: UITabBarController {

    var nowPlayingView = UIView()
    let interactor = Interactor()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func configureNowPlayingView() {
        view.insertSubview(nowPlayingView, aboveSubview: view)
        nowPlayingView.backgroundColor = .blue
        nowPlayingView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.topAnchor, size: .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 11))
    }
}

extension AppTabBarViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DismissAnimator(type: .modal, interactor: nil)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.isStarted ? interactor : nil
    }
}
