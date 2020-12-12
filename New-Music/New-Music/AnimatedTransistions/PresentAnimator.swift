//
//  PresentAnimator.swift
//  New-Music
//
//  Created by Michael McGrath on 12/4/20.
//

import SwiftUI

class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var startFrame: CGRect
    var musicController: MusicController
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let nowPlayingFullVC = transitionContext.viewController(forKey: .to) as? NowPlayingFullViewController else { return }
        
        let containerView = transitionContext.containerView
        containerView.backgroundColor = .clear
        let finalFrame = transitionContext.finalFrame(for: nowPlayingFullVC)
        print("Final Frame: \(finalFrame)")
        containerView.addSubview(nowPlayingFullVC.view)
        nowPlayingFullVC.view.frame = startFrame
        self.musicController.nowPlayingViewModel.shouldAnimateColorChange = true
        self.musicController.nowPlayingViewModel.isMinimized = false
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseOut) {
            nowPlayingFullVC.view.frame = finalFrame
        } completion: { _ in
            self.musicController.nowPlayingViewModel.isFull = true
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    init(startFrame: CGRect, musicController: MusicController) {
        self.startFrame = startFrame
        self.musicController = musicController
    }
}
