//
//  NowPlayingPresentationController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/20/20.
//

import SwiftUI

final class NowPlayingPresentationController: UIPresentationController {
    
    var musicController: MusicController
    var artworkView: UIViewController
    let shadowView: UIView = {
        let view = UIView()
//        view.contentMode = .scaleAspectFit
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
        self.artworkView = UIHostingController(rootView: ArtworkAnimationView(size: UIScreen.main.bounds.width - 80).environmentObject(musicController.nowPlayingViewModel))
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
        self.artworkView = UIHostingController(rootView: ArtworkView2(size: UIScreen.main.bounds.width - 80).environmentObject(musicController.nowPlayingViewModel))
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
        snapshot?.frame = nowPlayingFull.animationFrame
        presentedView?.addSubview(snapshot!)
        
        coordinator.animate { _ in
            snapshot?.frame = barVC.animationFrame
        } completion: { _ in
            snapshot?.removeFromSuperview()
        }
    }
    
    private func matchImageShadows(snapshot1: UIView?, snapshot2: UIView?) {
//        shadowView.addSubview(snapshot!)
        snapshot1?.layer.shadowColor = UIColor.black.cgColor
        snapshot1?.layer.shadowOffset = CGSize(width: 5, height: 5)
        snapshot1?.layer.shadowRadius = 10
        snapshot1?.layer.shadowOpacity = 0.9
        snapshot2?.layer.shadowColor = UIColor.white.cgColor
        snapshot2?.layer.shadowOffset = CGSize(width: -3, height: -3)
        snapshot2?.layer.shadowRadius = 10
        snapshot2?.layer.shadowOpacity = 0.1
//        snapshot?.frame = shadowView.bounds
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, musicController: MusicController) {
        self.musicController = musicController
        self.artworkView = UIHostingController(rootView: ArtworkView2(size: 60).environmentObject(musicController.nowPlayingViewModel))
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.containerView?.backgroundColor = .clear
    }
}
