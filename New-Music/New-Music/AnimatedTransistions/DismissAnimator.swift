//
//  DismissAnimator.swift
//  New-Music
//
//  Created by Michael McGrath on 12/4/20.
//

import SwiftUI

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var finalFrame: CGRect
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from),
            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: true)
        else { return }
        let containerView = transitionContext.containerView
        containerView.backgroundColor = .clear
        let tabBarController = toVC as! UITabBarController
        let nav = tabBarController.viewControllers?[tabBarController.selectedIndex] as! UINavigationController
        let vc = nav.topViewController
        let barVC = vc?.children.first(where: { $0 is NowPlayingMinimizedViewController} ) as! NowPlayingMinimizedViewController
        print("Bar VC: \(barVC.description)")
        containerView.addSubview(snapshot)
        snapshot.frame = fromVC.view.frame
        fromVC.view.removeFromSuperview()
        containerView.layoutSubviews()
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubicPaced) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6) {
                snapshot.center = CGPoint(x: self.finalFrame.midX, y: UIScreen.main.bounds.height + 100)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                snapshot.frame = self.finalFrame
                snapshot.layer.cornerRadius = 0
            }
        } completion: { _ in
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }


        
//        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
//            fromVC.view.frame = self.finalFrame
//            fromVC.view.layer.cornerRadius = 0
//        } completion: { _ in
//            fromVC.view.layer.cornerRadius = 20
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }

    }
    
    init(finalFrame: CGRect) {
        self.finalFrame = finalFrame
    }
}
