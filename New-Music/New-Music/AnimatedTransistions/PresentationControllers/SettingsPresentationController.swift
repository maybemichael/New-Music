//
//  SettingsPresentationController.swift
//  New-Music
//
//  Created by Michael McGrath on 1/23/21.
//

import UIKit

final class SettingsPresentationController: UIPresentationController {
	
	var animator = UIViewPropertyAnimator()
	lazy var tapGesture: UITapGestureRecognizer = {
		let tapGesture = UITapGestureRecognizer()
		tapGesture.addTarget(self, action: #selector(dismissSettings))
		return tapGesture
	}()
	
	lazy var panGesture: UIPanGestureRecognizer = {
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
		return panGesture
	}()
	
	lazy var backgroundView: UIView = {
		let view = UIView(frame: containerView!.bounds)
		view.backgroundColor = .clear
		view.addGestureRecognizer(tapGesture)
		return view
	}()
	
	override var frameOfPresentedViewInContainerView: CGRect {
		return CGRect(x: 0, y: containerView!.bounds.height - (containerView!.bounds.height / 3.25), width: containerView!.bounds.width, height: UIScreen.main.bounds.height)
	}
	
	override func containerViewDidLayoutSubviews() {
		super.containerViewDidLayoutSubviews()
		self.presentedView?.frame = frameOfPresentedViewInContainerView
	}
	
	override func containerViewWillLayoutSubviews() {
		super.containerViewWillLayoutSubviews()
		presentedView?.layer.masksToBounds = true
		presentedView?.layer.cornerRadius = 20
	}
	
	override func presentationTransitionWillBegin() {
		super.presentationTransitionWillBegin()
		containerView?.insertSubview(backgroundView, belowSubview: presentedView!)
//		let settingsNav = presentedViewController as! UINavigationController
//		let settingsVC = settingsNav.topViewController as! SettingsViewController
//		settingsVC.collectionView.addGestureRecognizer(panGesture)
//		settingsVC.collectionView.frame = settingsVC.view.bounds
//		settingsVC.collectionView.layoutIfNeeded()
//		settingsVC.view.layoutIfNeeded()
//        presentedView?.layoutIfNeeded()
	}
	
	override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
//		presentedView?.frame.size = CGSize(width: 300, height: 400)
//        presentedView?.layoutIfNeeded()
	}
	
	@objc private func dismissSettings() {
		presentedViewController.dismiss(animated: true, completion: nil)
	}
	
	@objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
		
		let translation = gesture.translation(in: containerView)
		gesture.allowedScrollTypesMask = .all
		switch gesture.state {
		case .began:
			gesture.setTranslation(presentedView!.frame.origin, in: presentedView)
		case .changed:
			presentedView?.frame.origin = CGPoint(x: max(min(translation.x, containerView!.bounds.width - presentedView!.frame.width), 0), y: max(min(translation.y, containerView!.bounds.height - presentedView!.frame.height), 0))
		case .ended:
			let velocity = gesture.velocity(in: containerView)
			createAnimator(center: velocity)
		default:
			break
		}
	}
	
	enum SideX {
		case leading
		case trailing
	}
	
	enum SideY {
		case top
		case bottom
	}
	
	enum Corner {
		case topLeading
		case topTrailing
		case bottomLeading
		case bottomTrailing
	}
	
	private func createAnimator(center: CGPoint) {
		let corner = cornerForAnimation(center: center)
		let originPoint = originForCorner(corner: corner)
		let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeOut) { [weak self] in
			guard let self = self else { return }
			self.presentedView?.frame.origin = originPoint
//            self.presentedView?.frame.origin = CGPoint(x: max(min(velocity.x, self.containerView!.bounds.width - self.presentedView!.frame.width), 0), y: max(min(velocity.y, self.containerView!.bounds.height - self.presentedView!.frame.height), 0))
		}
		animator.startAnimation()
	}
	
	private func cornerForAnimation(center: CGPoint) -> Corner {
		let midX = containerView!.bounds.midX
		let midY = containerView!.bounds.midY
		var xSide: SideX = .leading
		var ySide: SideY = .top
		if center.x <= midX {
			xSide = .leading
		} else {
			xSide = .trailing
		}
		
		if center.y <= midY {
			ySide = .top
		} else {
			ySide = .bottom
		}
		
		if xSide == .leading && ySide == .top {
			return .topLeading
		} else if xSide == .trailing && ySide == .top {
			return .topTrailing
		} else if xSide == .leading && ySide == .bottom {
			return .bottomLeading
		} else {
			return .bottomTrailing
		}
	}
	
	private func originForCorner(corner: Corner) -> CGPoint {
		switch corner {
		case .topLeading:
			return CGPoint(x: 0, y: 0)
		case .topTrailing:
			return CGPoint(x: containerView!.bounds.width - presentedView!.frame.width, y: 0)
		case .bottomLeading:
			return CGPoint(x: 0, y: containerView!.bounds.height - presentedView!.frame.height)
		case .bottomTrailing:
			return CGPoint(x: containerView!.bounds.width - presentedView!.frame.width, y: containerView!.bounds.height - presentedView!.frame.height)
		}
	}
	
//    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
//
//        let translation = gesture.translation(in: containerView)
//        gesture.allowedScrollTypesMask = .all
//        switch gesture.state {
//        case .began:
//            print("Pan Gesture began... Translation: \(translation)")
//            gesture.setTranslation(CGPoint(x: translation.x, y: containerView!.frame.minY), in: presentedView)
//        case .changed:
//            presentedView?.frame = containerView!.bounds.offsetBy(dx: 0, dy: max(containerView!.safeAreaInsets.top, translation.y))
//        case .ended:
//            ()
//        default:
//            break
//        }
//    }
}
