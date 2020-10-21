//
//  DissmissAnimator.swift
//  New-Music
//
//  Created by Michael McGrath on 10/19/20.
//

import UIKit

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let type: TransitionType
    let duration: TimeInterval
    
    enum TransitionType {
        case navigation
        case modal
    }
    
    init(type: TransitionType, duration: TimeInterval = 0.5) {
        self.type = type
        self.duration = duration
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        self.duration
    }
    
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        else { return }
        let containerView = transitionContext.containerView
        
        if self.type == .navigation {
            containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        
        let animations = {
            fromVC.view.frame = containerView.bounds.offsetBy(dx: 0, dy: containerView.frame.size.height)
//            fromVC.view.transform = CGAffineTransform(scaleX: 0, y: containerView.frame.size.height)
//            toVC.view.transform = CGAffineTransform(translationX: containerView.bounds.width, y: containerView.bounds.height)
            toVC.view.frame = containerView.bounds
        }
        containerView.layer.cornerRadius = 12
        toVC.view.layer.cornerRadius = 12
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
//        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: animations) { _ in
            fromVC.view.transform = CGAffineTransform.identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseIn, animations: ) {
//            fromVC.view.frame = finalFrame
//        } completion: { _ in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
    }
}


