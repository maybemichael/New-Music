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
    weak var interactor: Interactor?
    
    enum TransitionType {
        case navigation
        case modal
    }
    
    init(type: TransitionType, duration: TimeInterval = 0.5, interactor: Interactor?) {
        self.type = type
        self.duration = duration
        self.interactor = interactor
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
        containerView.isUserInteractionEnabled = true
        if self.type == .navigation {
            containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        
        containerView.layer.cornerRadius = 20
        toVC.view.layer.cornerRadius = 20
        fromVC.view.layer.cornerRadius = 20
        toVC.view.transform = CGAffineTransform(scaleX: 0.87, y: 0.87)
        let animations = {
            fromVC.view.frame = containerView.bounds.offsetBy(dx: 0, dy: containerView.frame.size.height)
            toVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: animations) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}


