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

        self.musicController.nowPlayingViewModel.shouldAnimateColorChange = false
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear) { [weak self] in
            guard let self = self else { return }
            self.musicController.nowPlayingViewModel.isFull = false
            fromVC.view.frame = self.finalFrame
            fromVC.view.layer.cornerRadius = 7
        } completion: { _ in
            self.musicController.nowPlayingViewModel.isMinimized = true 
            fromVC.view.removeFromSuperview()
            fromVC.view.layer.cornerRadius = 20
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    init(finalFrame: CGRect, musicController: MusicController) {
        self.finalFrame = finalFrame
        self.musicController = musicController
    }
}
