//
//  SlideUpPresentationController.swift
//  New-Music
//
//  Created by Michael McGrath on 11/1/20.
//

import UIKit

class SlideUpPresentationController: UIPresentationController {
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
      super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
    }
    
    override func presentationTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        let container = coordinator.containerView
        let finalFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let startFrame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 11)
        container.frame = startFrame
        coordinator.animate(alongsideTransition: { _ in
            container.frame = finalFrame
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        let container = coordinator.containerView
        let startFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let finalFrame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 11)
        container.frame = startFrame
        coordinator.animate(alongsideTransition: { _ in
            container.frame = finalFrame
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
//    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
//
//    }
}
