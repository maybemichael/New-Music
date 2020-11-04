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
    var nowPlayingBarFrame: CGRect?
    var containerView: UIView?
    weak var fromVC: UIViewController?
    weak var toVC: UIViewController?
    
    init(type: TransitionType, animationType: AnimationType, duration: TimeInterval = 0.6, nowPlayingBarFrame: CGRect?) {
        self.transitionType = type
        self.duration = duration
        self.animationType = animationType
        self.nowPlayingBarFrame = nowPlayingBarFrame
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let nowPlayingBarFrame = self.nowPlayingBarFrame
        else { return }
        let containerView = transitionContext.containerView
        self.containerView = containerView
        self.fromVC = fromVC
        self.toVC = toVC
        if self.transitionType == .navigation {
            containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        fromVC.view.isUserInteractionEnabled = true
        containerView.layer.cornerRadius = 20
        fromVC.view.layer.cornerRadius = 20
        toVC.view.transform = CGAffineTransform(scaleX: 0.87, y: 0.87)
        
        if animationType == .present {
            if let startFrame = self.nowPlayingBarFrame {
                toVC.view.frame = startFrame
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: .layoutSubviews) {
                toVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            } completion: { complete in
                transitionContext.completeTransition(complete)
            }
        } else {
            let animations = {
                fromVC.view.frame = containerView.bounds.offsetBy(dx: 0, dy: min(UIScreen.main.bounds.height - 200, containerView.frame.size.height))
                toVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
            let displayLink = CADisplayLink(target: self, selector: #selector(self.animationDidUpdate(_:)))
            displayLink.preferredFramesPerSecond = 60
            displayLink.add(to: .main, forMode: .default)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: animations) { success in
                print("This is success: \(success)")
                toVC.view.transform = .identity
                if !transitionContext.transitionWasCancelled {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState) {
                        fromVC.view.frame = nowPlayingBarFrame
                        fromVC.view.alpha = 0
                    } completion: { _ in
                        displayLink.invalidate()
                        fromVC.view.removeFromSuperview()
                        fromVC.view.alpha = 1
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    }
                } else {
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        }
        
//        let displayLink = CADisplayLink(target: self, selector: #selector(self.animationDidUpdate(_:)))
//        displayLink.preferredFramesPerSecond = 60
//        displayLink.add(to: .main, forMode: .default)
        
//        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubicPaced) {
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.7) {
////                fromVC.view.frame = containerView.bounds.offsetBy(dx: 0, dy: min(UIScreen.main.bounds.height, containerView.frame.size.height))
//                fromVC.view.transform = CGAffineTransform(translationX: 1, y: containerView.bounds.height - 200)
//                toVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
//                fromVC.view.frame = fromVC.view.bounds.offsetBy(dx: 0, dy: containerView.bounds.height + 120)
//                fromVC.view.alpha = 1
//            }
////            fromVC.view.frame = fromVC.view.bounds.offsetBy(dx: 0, dy: containerView.bounds.height + 120)
//            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1) {
//                fromVC.view.transform = CGAffineTransform(scaleX: 1, y: 0.09)
////                fromVC.view.alpha = 0.5
////                fromVC.view.frame = finalFrame
//            }
//        } completion: { _ in
//            if !transitionContext.transitionWasCancelled {
//                fromVC.view.removeFromSuperview()
//                fromVC.view.transform = .identity
//                fromVC.view.alpha = 1
//                displayLink.invalidate()
//            }
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
        
    }
    
    
    @objc func animationDidUpdate(_ displayLink: CADisplayLink) {
        guard
            let containerView = self.containerView,
            let fromVC = self.fromVC
        else { return }
        containerView.layoutIfNeeded()
        fromVC.view.layoutIfNeeded()
    }
}


