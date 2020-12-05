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
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
//        let artworkView = UIHostingController(rootView: ArtworkView().environmentObject(musicController.nowPlayingViewModel))
        
        let tabBarController = presentingViewController as! UITabBarController
        let nav = tabBarController.viewControllers?[tabBarController.selectedIndex] as! UINavigationController
        artworkView.view.backgroundColor = .clear
        artworkView.view.frame = musicController.nowPlayingViewModel.minimizedImageFrame
        presentedViewController.addChild(artworkView)
        artworkView.didMove(toParent: presentedViewController)
//        containerView?.addSubview(artworkView.view)
//        containerView?.bringSubviewToFront(artworkView.view)
//        presentedView?.insertSubview(self.artworkView.view, at: 5)
        artworkView.view.frame = (containerView?.convert(musicController.nowPlayingViewModel.minimizedImageFrame, to: UIScreen.main.coordinateSpace))!
        containerView?.layoutSubviews()
        print("PresentedViewController: \(presentedViewController.description)")
        coordinator.animate { _ in
            self.artworkView.view.frame = (self.containerView?.convert(self.musicController.nowPlayingViewModel.fullImageFrame, to: UIScreen.main.coordinateSpace))!
        } completion: { _ in
            self.artworkView.view.removeFromSuperview()
            self.artworkView.willMove(toParent: nil)
            self.artworkView.removeFromParent()
        }

//        switch nav.topViewController {
//        case is SearchViewController:
//            let searchVC = nav.topViewController as! SearchViewController
//            searchVC.view.addSubview(artworkView.view)
//            coordinator.animate { _ in
//                artworkView.view.frame = self.musicController.nowPlayingViewModel.fullImageFrame
//            } completion: { _ in
//                artworkView.view.removeFromSuperview()
//            }
//        case is NowPlayingViewController:
//            let nowPlayingVC = nav.topViewController as! NowPlayingViewController
//            nowPlayingVC.view.addSubview(artworkView.view)
//            coordinator.animate { _ in
//                artworkView.view.frame = self.musicController.nowPlayingViewModel.fullImageFrame
//            } completion: { _ in
//                artworkView.view.removeFromSuperview()
//            }
//        case is PlaylistViewController:
//            let playlistVC = nav.topViewController as! PlaylistViewController
//            playlistVC.view.addSubview(artworkView.view)
//            coordinator.animate { _ in
//                artworkView.view.frame = self.musicController.nowPlayingViewModel.fullImageFrame
//            } completion: { _ in
//                artworkView.view.removeFromSuperview()
//            }
//        default:
//            break
//        }
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
//        let artworkView = UIHostingController(rootView: ArtworkView().environmentObject(musicController.nowPlayingViewModel))
        presentedViewController.addChild(self.artworkView)
        self.artworkView.didMove(toParent: presentedViewController)
        presentedView?.insertSubview(self.artworkView.view, at: 5)
        self.artworkView.view.frame = musicController.nowPlayingViewModel.fullImageFrame
        
        coordinator.animate { _ in
            self.artworkView.view.frame = self.musicController.nowPlayingViewModel.minimizedImageFrame
        } completion: { _ in
            self.artworkView.willMove(toParent: nil)
            self.artworkView.removeFromParent()
            self.artworkView.view.removeFromSuperview()
        }

//        let tabBarController = presentingViewController as! UITabBarController
//        let nav = tabBarController.viewControllers?[tabBarController.selectedIndex] as! UINavigationController
//        artworkView.view.backgroundColor = .clear
//        artworkView.view.frame = musicController.nowPlayingViewModel.fullImageFrame
//        switch nav.topViewController {
//        case is SearchViewController:
//            let searchVC = nav.topViewController as! SearchViewController
//            searchVC.view.addSubview(artworkView.view)
//            coordinator.animate { _ in
//                self.artworkView.view.frame = self.musicController.nowPlayingViewModel.minimizedImageFrame
//            } completion: { _ in
//                self.artworkView.view.removeFromSuperview()
//            }
//        case is NowPlayingViewController:
//            let nowPlayingVC = nav.topViewController as! NowPlayingViewController
//            nowPlayingVC.view.addSubview(artworkView.view)
//            coordinator.animate { _ in
//                self.artworkView.view.frame = self.musicController.nowPlayingViewModel.minimizedImageFrame
//            } completion: { _ in
//                self.artworkView.view.removeFromSuperview()
//            }
//        case is PlaylistViewController:
//            let playlistVC = nav.topViewController as! PlaylistViewController
//            playlistVC.view.addSubview(artworkView.view)
//            coordinator.animate { _ in
//                self.artworkView.view.frame = self.musicController.nowPlayingViewModel.minimizedImageFrame
//            } completion: { _ in
//                self.artworkView.view.removeFromSuperview()
//            }
//        default:
//            break
//        }
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, musicController: MusicController) {
        self.musicController = musicController
        self.artworkView = UIHostingController(rootView: ArtworkView().environmentObject(musicController.nowPlayingViewModel))
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.containerView?.backgroundColor = .clear
    }
}
