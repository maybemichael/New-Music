//
//  PresentAnimator.swift
//  New-Music
//
//  Created by Michael McGrath on 12/4/20.
//

import SwiftUI

class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        containerView.backgroundColor = .clear
        toVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        containerView.addSubview(toVC.view)
        let finalFrame = transitionContext.finalFrame(for: toVC)
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toVC.view.frame = finalFrame
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
