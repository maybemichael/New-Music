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
        return  0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        let containerView = transitionContext.containerView
        containerView.backgroundColor = .clear
        
        
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveLinear) {
//            fromVC.view.layer.cornerRadius = 0
//            fromVC.view.frame = self.finalFrame
//            self.musicController.nowPlayingViewModel.isFullScreen = false
//        } completion: { _ in
//            fromVC.view.removeFromSuperview()
//            fromVC.view.layer.cornerRadius = 20
//            self.musicController.nowPlayingViewModel.shouldAnimateColorChange = true
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
        self.musicController.nowPlayingViewModel.isFullScreen = false
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut) {
            fromVC.view.layer.cornerRadius = 0
            fromVC.view.frame = self.finalFrame
            self.musicController.nowPlayingViewModel.shouldAnimateColorChange = false
        } completion: { _ in
            fromVC.view.removeFromSuperview()
            fromVC.view.layer.cornerRadius = 20
            self.musicController.nowPlayingViewModel.shouldAnimateColorChange = true
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    init(finalFrame: CGRect, musicController: MusicController) {
        self.finalFrame = finalFrame
        self.musicController = musicController
    }
}
