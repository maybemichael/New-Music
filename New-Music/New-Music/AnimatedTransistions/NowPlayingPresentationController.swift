//
//  NowPlayingPresentationController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/20/20.
//

import SwiftUI

final class NowPlayingPresentationController: UIPresentationController {
    
    var musicController: MusicController
    let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height)
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        let artworkView = UIHostingController(rootView: ArtworkAnimationView(size: UIScreen.main.bounds.width - 80).environmentObject(musicController.nowPlayingViewModel))
        let nowPlayingFull = presentedViewController as! NowPlayingFullViewController
        let tabBarController = presentingViewController as! UITabBarController
        let nav = tabBarController.viewControllers?[tabBarController.selectedIndex] as! UINavigationController
        var nowPlayingMinimized: NowPlayingMinimizedViewController? = nil
        switch nav.topViewController {
        case is SearchViewController:
            let vc = nav.topViewController as! SearchViewController
            let barVC = vc.children.first(where: { $0 is NowPlayingMinimizedViewController }) as! NowPlayingMinimizedViewController
            nowPlayingMinimized = barVC
        case is NowPlayingViewController:
            let vc = nav.topViewController as! NowPlayingViewController
            let barVC = vc.children.first(where: { $0 is NowPlayingMinimizedViewController }) as! NowPlayingMinimizedViewController
            nowPlayingMinimized = barVC
        case is PlaylistViewController:
            let vc = nav.topViewController as! PlaylistViewController
            let barVC = vc.children.first(where: { $0 is NowPlayingMinimizedViewController }) as! NowPlayingMinimizedViewController
            nowPlayingMinimized = barVC
        default:
            break
        }
        
        guard
            let coordinator = presentedViewController.transitionCoordinator,
            let barVC = nowPlayingMinimized
        else { return }
        artworkView.view.frame = nowPlayingFull.animationFrame
        let snapshot = artworkView.view.snapshotView(afterScreenUpdates: true)
        let snapshot2 = artworkView.view.snapshotView(afterScreenUpdates: true)
        matchImageShadows(snapshot1: snapshot, snapshot2: snapshot2)
        snapshot?.frame = barVC.animationFrame
        snapshot2?.frame = barVC.animationFrame

        
        presentedView?.addSubview(snapshot2!)
        presentedView?.addSubview(snapshot!)
        containerView?.layoutIfNeeded()
        presentedView?.layoutIfNeeded()

        coordinator.animateAlongsideTransition(in: containerView) { _ in
            snapshot?.frame = nowPlayingFull.animationFrame
            snapshot2?.frame = nowPlayingFull.animationFrame
        } completion: { _ in
            snapshot?.removeFromSuperview()
            snapshot2?.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let artworkView = UIHostingController(rootView: ArtworkView2(size: UIScreen.main.bounds.width - 80).environmentObject(musicController.nowPlayingViewModel))
        let barView = UIHostingController(rootView: NowPlayingMinimized3(musicController: musicController, height: 60).environmentObject(musicController.nowPlayingViewModel))
        barView.view.backgroundColor = .clear
        let nowPlayingFull = presentedViewController as! NowPlayingFullViewController
        let tabBarController = presentingViewController as! UITabBarController
        let nav = tabBarController.viewControllers?[tabBarController.selectedIndex] as! UINavigationController
        var nowPlayingMinimized: NowPlayingMinimizedViewController? = nil
        switch nav.topViewController {
        case is SearchViewController:
            let vc = nav.topViewController as! SearchViewController
            let barVC = vc.children.first(where: { $0 is NowPlayingMinimizedViewController }) as! NowPlayingMinimizedViewController
            nowPlayingMinimized = barVC
        case is NowPlayingViewController:
            let vc = nav.topViewController as! NowPlayingViewController
            let barVC = vc.children.first(where: { $0 is NowPlayingMinimizedViewController }) as! NowPlayingMinimizedViewController
            nowPlayingMinimized = barVC
        case is PlaylistViewController:
            let vc = nav.topViewController as! PlaylistViewController
            let barVC = vc.children.first(where: { $0 is NowPlayingMinimizedViewController }) as! NowPlayingMinimizedViewController
            nowPlayingMinimized = barVC
        default:
            break
        }
        guard
            let coordinator = presentedViewController.transitionCoordinator,
            let barVC = nowPlayingMinimized
        else { return }

        barView.view.frame = barVC.view.frame
        artworkView.view.frame = nowPlayingFull.animationFrame
        let artworkSnapshot = artworkView.view.snapshotView(afterScreenUpdates: true)
        let artworkSnapshot2 = artworkView.view.snapshotView(afterScreenUpdates: true)
        let barViewSnapshot = barView.view.snapshotView(afterScreenUpdates: true)
        barViewSnapshot?.frame = barVC.view.bounds
        barViewSnapshot?.center = CGPoint(x: containerView!.center.x, y: getStartingY(barVC: barVC))
        barViewSnapshot!.alpha = 0
        artworkSnapshot?.frame = nowPlayingFull.animationFrame
        artworkSnapshot2?.frame = nowPlayingFull.animationFrame
        containerView?.addSubview(barViewSnapshot!)
        presentedView?.addSubview(artworkSnapshot!)
        presentedView?.addSubview(artworkSnapshot2!)
        barVC.view.isHidden = true
        coordinator.animate { _ in
            UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseIn) {
                artworkSnapshot?.frame = barVC.animationFrame
                artworkSnapshot2?.frame = barVC.animationFrame
                barViewSnapshot?.alpha = 1
                barViewSnapshot?.frame = barVC.view.frame
            } completion: { _ in
                barVC.view.isHidden = false
                barViewSnapshot?.removeFromSuperview()
                artworkSnapshot?.removeFromSuperview()
                artworkSnapshot2?.removeFromSuperview()
                
            }
        } completion: { [weak self] _ in
//            guard let self = self else { return }
//            self.presentedView?.sendSubviewToBack(artworkSnapshot!)
//            self.presentedView?.sendSubviewToBack(artworkSnapshot2!)
        }
    }
    
    private func matchImageShadows(snapshot1: UIView?, snapshot2: UIView?) {
        snapshot1?.layer.shadowColor = UIColor.black.cgColor
        snapshot1?.layer.shadowOffset = CGSize(width: 5, height: 5)
        snapshot1?.layer.shadowRadius = 10
        snapshot1?.layer.shadowOpacity = 0.9
        snapshot2?.layer.shadowColor = UIColor.white.cgColor
        snapshot2?.layer.shadowOffset = CGSize(width: -3, height: -3)
        snapshot2?.layer.shadowRadius = 10
        snapshot2?.layer.shadowOpacity = 0.1
    }
    
    private func getStartingY(barVC: NowPlayingMinimizedViewController) -> CGFloat {
        return presentedView!.frame.minY > barVC.view.frame.minY ? barVC.view.frame.minY + (barVC.view.frame.height / 2) : presentedView!.frame.minY + barVC.view.frame.height
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, musicController: MusicController) {
        self.musicController = musicController
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.containerView?.backgroundColor = .clear
    }
}
