//
//  AppTabBarViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/30/20.
//

import UIKit

class AppTabBarViewController: UITabBarController {

    var nowPlayingView = UIView()
    var interactor: Interactor?
    weak var nowPlayingVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    private func configureNowPlayingView() {
//        view.insertSubview(nowPlayingView, aboveSubview: view)
//        nowPlayingView.backgroundColor = .blue
//        nowPlayingView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.topAnchor, size: .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 11))
    }
}

extension AppTabBarViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator(type: .modal, animationType: .dismiss, interactor: interactor)
    }
    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transitionAnimator(type: .modal, animationType: .present, interactor: interactor)
//    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let interactor = self.interactor else { return nil }
        return interactor.isStarted ? interactor : nil
    }
    
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        guard let nowPlayingVC = self.nowPlayingVC else { return nil }
//        return SlideUpPresentationController(presentedViewController: nowPlayingVC, presenting: self)
//    }
}
