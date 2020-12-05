//
//  NowPlayingTransitionCoordinator.swift
//  New-Music
//
//  Created by Michael McGrath on 11/3/20.
//

import UIKit

class NowPlayingTransitionCoordinator: UIPercentDrivenInteractiveTransition {
    
    var musicController: MusicController
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
        self.toVC = toVC
        self.fromVC = fromVC
        self.centerPoint = centerPoint
        fromVC.view.addGestureRecognizer(panGesture)
    }
    
    private func slideDownAnimator() -> UIViewPropertyAnimator {
        toVC?.view.transform = CGAffineTransform(scaleX: 0.87, y: 0.87)
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.toVC?.view.transform = .identity
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
            self.fromVC?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.fromVC?.view.frame = (self.fromVC?.view.convert((self.fromVC?.view.frame)!, from: UIScreen.main.coordinateSpace))!
            self.fromVC?.view.layoutIfNeeded()
        }
        animator.addCompletion { _ in
            self.toVC?.view.transform = .identity
        }
        animator.startAnimation()
    }
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        guard let viewToAnimate = gesture.view else { return }
        
        var translation = gesture.translation(in: viewToAnimate).y
        
        switch gesture.state {
        case .began:
            self.animator = slideDownAnimator()
            animator.startAnimation()
            gesture.setTranslation(.zero, in: fromVC?.view)
        case .changed:
            animator.pauseAnimation()
            translation = max(translation, 0)
            viewToAnimate.frame = viewToAnimate.bounds.offsetBy(dx: 0, dy: translation)
            var percentage =  translation / (UIScreen.main.bounds.height / 2)
            percentage = min(percentage, 0.999)
            percentage = max(percentage, 0.001)
            animator.fractionComplete = percentage
            viewToAnimate.layoutIfNeeded()
        case .ended:
            let yVelocity = gesture.velocity(in: viewToAnimate).y
            if yVelocity > 400 || viewToAnimate.frame.minY > UIScreen.main.bounds.height / 3 {
                self.fromVC?.dismiss(animated: true, completion: nil)
                musicController.nowPlayingViewModel.isFullScreen = false
            } else {
                bounceBackFull()
                musicController.nowPlayingViewModel.isFullScreen = true
                animator.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve: .easeOut), durationFactor: 0.3)
            }
            animator.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve: .easeOut), durationFactor: 0.3)
        default:
            break
        }
    }
    
    init(musicController: MusicController) {
        self.musicController = musicController
    }
}

extension NowPlayingTransitionCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator(finalFrame: self.finalFrame)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimator()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        NowPlayingPresentationController(presentedViewController: presented, presenting: presenting, musicController: self.musicController)
    }
}
