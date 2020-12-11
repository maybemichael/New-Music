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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return  0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        let containerView = transitionContext.containerView
        containerView.backgroundColor = .clear

        self.musicController.nowPlayingViewModel.shouldAnimateColorChange = false
        self.musicController.nowPlayingViewModel.isFullScreen = true
        self.musicController.nowPlayingViewModel.isFullScreen = false
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseOut) {
            fromVC.view.layer.cornerRadius = 7
            fromVC.view.frame = self.finalFrame
//            self.musicController.nowPlayingViewModel.isFullScreen = false
        } completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
                fromVC.view.layer.cornerRadius = 0
                fromVC.view.alpha = 0
            } completion: { _ in
                self.musicController.nowPlayingViewModel.shouldAnimateColorChange = true
                fromVC.view.removeFromSuperview()
                fromVC.view.layer.cornerRadius = 20
//                fromVC.view.backgroundColor = .clear
                fromVC.view.alpha = 1
            }

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    init(finalFrame: CGRect, musicController: MusicController) {
        self.finalFrame = finalFrame
        self.musicController = musicController
    }
}
