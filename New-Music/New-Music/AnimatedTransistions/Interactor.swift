//
//  Interactor.swift
//  New-Music
//
//  Created by Michael McGrath on 10/19/20.
//

import UIKit

class Interactor: UIPercentDrivenInteractiveTransition {
    var isStarted = false
    var shouldFinish = false
    var contextData: UIViewControllerContextTransitioning?
    var panGesture: UIPanGestureRecognizer?
    weak var nowPlayingVC: NowPlayingViewController?

    
//    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
//        let container = transitionContext.containerView
//        self.contextData = transitionContext
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
//        self.panGesture = panGesture
//        container.addGestureRecognizer(panGesture)
//        nowPlayingVC?.view.addGestureRecognizer(panGesture)
//    }
    
    @objc func handleGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.25
//        guard let container = self.contextData?.containerView else { return }
//         convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: nowPlayingVC?.view)
        let verticalMovement = translation.y / (nowPlayingVC?.view.bounds.height ?? 896 * 1.2)
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
//        let translation = sender.translation(in: container)
//        let percentage = abs(translation.y / container.bounds.height)

        switch sender.state {
        case .began:
            self.isStarted = true
//            sender.setTranslation(CGPoint(x: 0, y: 0), in: container)
            nowPlayingVC?.dismiss(animated: true, completion: nil)
            print("Sender state .began: \(sender.state)")
        case .changed:
            self.shouldFinish = progress > percentThreshold
            self.update(progress)
            print("Sender state .changed: \(sender.state)")
        case .cancelled:
            self.cancel()
            contextData?.cancelInteractiveTransition()
            contextData?.completeTransition(false)
//            present(self, animated: false, completion: nil)
            self.isStarted = false
            print("Sender state .cancelled: \(sender.state)")
        case .ended:
//            self.shouldFinish ? self.finish() : self.cancel()
            if self.shouldFinish {
                contextData?.finishInteractiveTransition()
                contextData?.completeTransition(true)
                nowPlayingVC?.view.removeGestureRecognizer(sender)
                self.finish()
            } else {
                contextData?.cancelInteractiveTransition()
                contextData?.completeTransition(false)
                nowPlayingVC?.view.removeGestureRecognizer(sender)
                self.cancel()
            }
            self.isStarted = false
            print("Sender state .ended: \(sender.state)")
        default:
            break
        }
    }
}
