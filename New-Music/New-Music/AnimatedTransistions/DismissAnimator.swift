//
//  DismissAnimator.swift
//  New-Music
//
//  Created by Michael McGrath on 12/4/20.
//

import SwiftUI

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var finalFrame: CGRect
    var musicController: MusicController
    var initialVelocity: CGFloat {
        didSet {
            print("Initial Velocity: \(self.initialVelocity)")
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return  0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        let containerView = transitionContext.containerView
        containerView.backgroundColor = .clear

        self.musicController.nowPlayingViewModel.shouldAnimateColorChange = true
        
        self.musicController.nowPlayingViewModel.isFull = false
        self.musicController.nowPlayingViewModel.isMinimized = true
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: initialVelocity, options: [.curveEaseOut]) { [weak self] in
            guard let self = self else { return }
            fromVC.view.frame = self.finalFrame
            fromVC.view.layer.cornerRadius = 7
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.musicController.nowPlayingViewModel.shouldAnimateColorChange = false
            fromVC.view.removeFromSuperview()
            fromVC.view.layer.cornerRadius = 20
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseInOut, .layoutSubviews]) { [weak self] in
//            guard let self = self else { return }
//            fromVC.view.frame = self.finalFrame
//            fromVC.view.layer.cornerRadius = 7
//        } completion: { [weak self] _ in
//            guard let self = self else { return }
//            self.musicController.nowPlayingViewModel.shouldAnimateColorChange = false
//            fromVC.view.removeFromSuperview()
//            fromVC.view.layer.cornerRadius = 20
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
    }
    
    init(finalFrame: CGRect, musicController: MusicController, initialVelocity: CGFloat) {
        self.finalFrame = finalFrame
        self.musicController = musicController
        self.initialVelocity = initialVelocity
    }
}
