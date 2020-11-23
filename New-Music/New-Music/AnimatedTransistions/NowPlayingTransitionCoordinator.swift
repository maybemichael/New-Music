//
//  NowPlayingTransitionCoordinator.swift
//  New-Music
//
//  Created by Michael McGrath on 11/3/20.
//

import UIKit

class NowPlayingTransitionCoordinator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    
    var finalFrame = CGRect()
    var isTransitionInProgress = false
    var animator = UIViewPropertyAnimator()
    weak var toVC: UIViewController?
    weak var fromVC: NowPlayingFullViewController?
    var centerPoint = CGPoint()
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handleGesture(_:)))
        return gesture
    }()
    
    func prepareViewForDismiss(fromVC: NowPlayingFullViewController, toVC: UIViewController, finalFrame: CGRect, centerPoint: CGPoint) {
        fromVC.modalPresentationStyle = .custom
        toVC.modalPresentationStyle = .custom
        fromVC.modalPresentationCapturesStatusBarAppearance = true
        toVC.modalPresentationCapturesStatusBarAppearance = true
        toVC.transitioningDelegate = self
        fromVC.transitioningDelegate = self
        self.finalFrame = finalFrame
//        interactor = Interactor(fromVC: fromVC, toVC: toVC)
        self.toVC = toVC
        self.fromVC = fromVC
        self.centerPoint = centerPoint
        fromVC.view.addGestureRecognizer(panGesture)
    }
    
    private func slideDownAnimator() -> UIViewPropertyAnimator {
        toVC?.view.transform = CGAffineTransform(scaleX: 0.87, y: 0.87)
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.toVC?.view.transform = .identity
//            self.fromVC?.view.frame = UIScreen.main.bounds.offsetBy(dx: 0, dy: <#T##CGFloat#>)
            self.toVC?.view.layoutIfNeeded()
        }
        animator.addCompletion { position in
            switch position {
            case .start:
                self.toVC?.view.transform = .identity
            case .end:
                self.toVC?.view.transform = .identity
            default:
                self.toVC?.view.transform = .identity
            }
        }
        return animator
    }
    
    private func bounceBackFull() {
        let animator = UIViewPropertyAnimator(duration: 0.25, dampingRatio: 0.8) {
//            self.fromVC?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.fromVC?.view.frame = (self.fromVC?.view.convert((self.fromVC?.view.frame)!, from: UIScreen.main.coordinateSpace))!
//            self.
//            self.fromVC?.view.frame = windowBounds
            self.fromVC?.view.layoutIfNeeded()
        }
        animator.addCompletion { _ in
            self.toVC?.view.transform = .identity
        }
        animator.startAnimation()
    }
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        guard let viewToAnimate = gesture.view else { return }
        
//        let percentage = translation / viewToAnimate.bounds.height
        var translation = gesture.translation(in: viewToAnimate).y
        
        switch gesture.state {
        case .began:
//            isTransitionInProgress = true
//            fromVC?.dismiss(animated: true, completion: nil)
            self.animator = slideDownAnimator()
            animator.startAnimation()
            gesture.setTranslation(.zero, in: fromVC?.view)
        case .changed:
            animator.pauseAnimation()
            translation = max(translation, 0)
            viewToAnimate.frame = viewToAnimate.bounds.offsetBy(dx: 0, dy: translation)
            print("translation: \(translation)")
            var percentage =  translation / (UIScreen.main.bounds.height / 2)
            percentage = min(percentage, 0.999)
            percentage = max(percentage, 0.001)
            animator.fractionComplete = percentage
            viewToAnimate.layoutIfNeeded()
        case .ended:
            let yVelocity = gesture.velocity(in: viewToAnimate).y
            if yVelocity > 400 || viewToAnimate.frame.minY > UIScreen.main.bounds.height / 3 {
//                UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .calculationModeCubicPaced) {
//                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
//                        self.fromVC?.view.transform = CGAffineTransform(translationX: 0, y: 250)
//                    }
//                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1.0) {
//                        self.fromVC?.view.frame = self.finalFrame
//                        self.fromVC?.view.center = self.centerPoint
//                        self.fromVC?.view.layer.cornerRadius = 0
//                    }
//
//                } completion: { _ in
//                    self.fromVC?.view.layer.cornerRadius = 20
//                    self.fromVC?.dismiss(animated: false, completion: nil)
//                }

                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
                    self.fromVC?.view.frame = self.finalFrame
//                    self.fromVC?.view.center = self.centerPoint
                    self.fromVC?.view.layer.cornerRadius = 0
                    self.fromVC?.view.alpha = 0.3
                } completion: { _ in
                    self.fromVC?.view.layer.cornerRadius = 20
                    self.fromVC?.dismiss(animated: false, completion: nil)
                    self.fromVC?.view.alpha = 1
                }
            } else {
//                animator.isReversed = true
                bounceBackFull()
                animator.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve: .easeOut), durationFactor: 0.5)
//                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
//                    self.fromVC?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//                } completion: { _ in
//
//                }

//                self.cancel()
//                isTransitionInProgress = false
            }
            animator.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve: .easeOut), durationFactor: 0.5)
            self.finish()
        default:
            break
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard
//            let finalFrame = self.finalFrame
//        else { return }
        let containerView = transitionContext.containerView
        containerView.layer.cornerRadius = 20
        fromVC?.view.layer.cornerRadius = 20
//        toVC?.view.transform = CGAffineTransform(scaleX: 0.87, y: 0.87)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut) {
            self.fromVC?.view.center = self.centerPoint
            self.fromVC?.view.frame = CGRect(origin: self.centerPoint, size: CGSize(width: self.finalFrame.width, height: self.finalFrame.height))
        } completion: { _ in
//            self.fromVC?.view.removeFromSuperview()
        }

//        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut) {
//            self.fromVC?.view.frame = containerView.bounds.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)
//            self.toVC?.view.transform = .identity
//            self.fromVC?.view.frame = CGRect(x: containerView.bounds.midX - 50, y: containerView.bounds.midY - 50, width: 100, height: 100)
//        } completion: { _ in
//            if !transitionContext.transitionWasCancelled {
//                UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState) {
//                    self.fromVC?.view.frame = finalFrame
//                    fromVC.view.alpha = 0
//                } completion: { _ in
//                    displayLink.invalidate()
//                    self.fromVC?.view.removeFromSuperview()
//                    fromVC.view.alpha = 1
//                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//                }
//            }
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }

//        let animator = UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubicPaced) {
//            animator
//            self.fromVC?.view.frame = finalFrame
//        } completion: { _ in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }

//        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: .easeOut) {
//            self.fromVC?.view.frame = finalFrame
//        }
//        animator.addCompletion { _ in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
    }
}

extension NowPlayingTransitionCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return TransitionAnimator(type: .modal, animationType: .dismiss, nowPlayingBarFrame: self.finalFrame)
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        guard let interactor = self.interactor else { return nil }
//        return interactor
        return self
    }
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return SlideUpPresentationController(presentedViewController: presented, presenting: presenting)
//    }
}
