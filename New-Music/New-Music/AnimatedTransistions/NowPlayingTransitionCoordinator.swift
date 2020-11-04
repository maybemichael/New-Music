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
    
    func prepareViewForDismiss(fromVC: NowPlayingFullViewController, toVC: UIViewController, finalFrame: CGRect) {
        fromVC.modalPresentationStyle = .custom
        toVC.modalPresentationStyle = .overFullScreen
        fromVC.modalPresentationCapturesStatusBarAppearance = true
        toVC.modalPresentationCapturesStatusBarAppearance = true 
        toVC.transitioningDelegate = self
        fromVC.transitioningDelegate = self
        self.finalFrame = finalFrame
        interactor = Interactor(fromVC: fromVC, toVC: toVC)
        self.toVC = toVC
        self.fromVC = fromVC
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimator(type: .modal, animationType: .dismiss, nowPlayingBarFrame: self.finalFrame)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let interactor = self.interactor else { return nil }
        return interactor
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SlideUpPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
