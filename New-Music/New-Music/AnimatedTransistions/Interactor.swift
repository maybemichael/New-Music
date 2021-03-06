//
//  Interactor.swift
//  New-Music
//
//  Created by Michael McGrath on 10/19/20.
//

import UIKit

class Interactor: UIPercentDrivenInteractiveTransition {
    let fromVC: UIViewController?
    let toVC: UIViewController?
    var isTransitionInProgress = false
    var shouldFinish = false
    private let threshold: CGFloat = 0.3
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handleGesture(_:)))
        return gesture
    }()

    init(fromVC: UIViewController?, toVC: UIViewController?) {
        self.fromVC = fromVC
        self.toVC = toVC
        super.init()
        fromVC?.view.addGestureRecognizer(panGesture)
//        completionSpeed = 0.6
    }
    
    deinit {
        panGesture.view?.removeGestureRecognizer(panGesture)
    }
    
    @objc func handleGesture(_ sender: UIPanGestureRecognizer) {
        guard let containerView = self.panGesture.view?.superview else { return }
        let verticalMovement = sender.translation(in: self.panGesture.view?.superview).y
        let percentage = verticalMovement / containerView.bounds.height
//        let translation = sender.translation(in: self.panGesture.view?.superview)
//        let verticalMovement = translation.y / (fromVC?.view.bounds.height ?? 896 * 1.2)
//        let downwardMovement = fmax(Float(verticalMovement), 0.0)
//        let downwardMovementPercent = fmin(downwardMovement, 1.0)
//        let progress = CGFloat(downwardMovementPercent)

//        switch sender.state {
//        case .began:
//            isTransitionInProgress = true
//            fromVC?.dismiss(animated: true, completion: nil)
//            print("Sender state .began: \(sender.state)")
//        case .changed:
//            isTransitionInProgress = true
//            shouldFinish = progress > threshold
//            update(progress)
//            print("Sender state .changed: \(sender.state)")
//        case .cancelled:
//            cancel()
//            isTransitionInProgress = false
//            print("Sender state .cancelled: \(sender.state)")
//        case .ended:
//            shouldFinish ? finish() : cancel()
//            isTransitionInProgress = false
//            print("Sender state .ended: \(sender.state)")
//        default:
//            isTransitionInProgress = false
//        }
        
        switch sender.state {
        case .began:
            if verticalMovement <= 0 { return }
            isTransitionInProgress = true
            sender.setTranslation(.zero, in: containerView)
            fromVC?.dismiss(animated: true, completion: nil)
            print("Sender state .began: \(sender.state)")
        case .changed:
            if !isTransitionInProgress { return }
            isTransitionInProgress = true
            shouldFinish = percentage > threshold
            print("Percentage: \(percentage)")
            update(percentage)
            print("Sender state .changed: \(sender.state)")
        case .cancelled:
            cancel()
            isTransitionInProgress = false
            print("Sender state .cancelled: \(sender.state)")
        case .ended:
            shouldFinish ? finish() : cancel()
            isTransitionInProgress = false
            print("Sender state .ended: \(sender.state)")
        default:
            isTransitionInProgress = false
        }
    }
}
