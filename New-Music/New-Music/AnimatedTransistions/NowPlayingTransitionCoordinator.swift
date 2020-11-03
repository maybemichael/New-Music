//
//  NowPlayingTransitionCoordinator.swift
//  New-Music
//
//  Created by Michael McGrath on 11/3/20.
//

import UIKit

class NowPlayingTransitionCoordinator: NSObject, UIViewControllerTransitioningDelegate {
    
    var finalFrame: CGRect?
    var interactor: Interactor?
    var toVC: UIViewController?
    var fromVC: NowPlayingFullViewController?
    
    func prepareViewForDismiss(fromVC: NowPlayingFullViewController, toVC: UIViewController) {
        fromVC.transitioningDelegate = self
        fromVC.modalPresentationStyle = .custom
        interactor = Interactor(fromVC: fromVC, toVC: toVC)
        self.toVC = toVC
        self.fromVC = fromVC
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimator(type: .modal, animationType: .dismiss)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let interactor = self.interactor else { return nil }
        return interactor
    }
}
