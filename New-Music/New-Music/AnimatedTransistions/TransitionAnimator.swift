//
//  DissmissAnimator.swift
//  New-Music
//
//  Created by Michael McGrath on 10/19/20.
//

import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let transitionType: TransitionType
    let animationType: AnimationType
    let duration: TimeInterval
    var finalFrame: CGRect?
    
    init(type: TransitionType, animationType: AnimationType, duration: TimeInterval = 0.6) {
        self.transitionType = type
        self.duration = duration
        self.animationType = animationType
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        self.duration
    }
    
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        else { return }
        let containerView = transitionContext.containerView
        if self.transitionType == .navigation {
            containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        }

        containerView.layer.cornerRadius = 20
        fromVC.view.layer.cornerRadius = 20
        let moveDown = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        let scaleDown = CGAffineTransform(scaleX: 1, y: 0.2)
        let finalFrame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 11)
        toVC.view.transform = CGAffineTransform(scaleX: 0.87, y: 0.87)
        let animations = {
            fromVC.view.frame = containerView.bounds.offsetBy(dx: 0, dy: min(UIScreen.main.bounds.height, containerView.frame.size.height))
//            fromVC.view.frame = finalFrame
//            fromVC.view.transform = moveDown
//            fromVC.view.transform = scaleDown
            toVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)

        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: animations) { success in
            print("This is success: \(success)")
            toVC.view.transform = .identity
            fromVC.view.transform = .identity
            if transitionContext.transitionWasCancelled {
                fromVC.view.layoutIfNeeded()
//                transitionContext.cancelInteractiveTransition()
//                transitionContext.completeTransition(false)
            } else {
                fromVC.view.removeFromSuperview()
                //                transitionContext.completeTransition(true)
//                transitionContext.finishInteractiveTransition()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}


