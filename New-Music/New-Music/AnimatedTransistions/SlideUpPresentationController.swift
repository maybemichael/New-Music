//
//  SlideUpPresentationController.swift
//  New-Music
//
//  Created by Michael McGrath on 11/1/20.
//

import UIKit

class SlideUpPresentationController: UIPresentationController {
    
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        let container = coordinator.containerView
        container.addSubview(presentedViewController.view)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
//        guard
//            let coordinator = presentedViewController.transitionCoordinator,
//            let presentedView = self.presentedViewController.view
////            let presentingView = self.presentingViewController.view
//        else { return }
//        let container = coordinator.containerView
//        container.addSubview(presentedView)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
//
//    override var frameOfPresentedViewInContainerView: CGRect {
//        CGRect(x: 0, y: UIScreen.main.bounds.maxY - 200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 11)
//    }
//    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
//
//    }
}
