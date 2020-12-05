//
//  AppTabBarViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/30/20.
//

import UIKit

class AppTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private var nowPlayingBarVC =  NowPlayingBarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if tabBarController.selectedIndex == 0 {
//            print("SearchViewController: \(viewController)")
//            let nav = viewController as! UINavigationController
//            let vc = nav.topViewController as! SearchViewController
//            nowPlayingBarVC.view.removeFromSuperview()
//            nowPlayingBarVC.willMove(toParent: nil)
//            nowPlayingBarVC.removeFromParent()
//            vc.addChild(nowPlayingBarVC)
//            nowPlayingBarVC.didMove(toParent: vc)
//            vc.view.addSubview(nowPlayingBarVC.view)
//            nowPlayingBarVC.view.anchor(leading: vc.view.leadingAnchor, trailing: vc.view.trailingAnchor, bottom: vc.separatorView.topAnchor)
//        } else if tabBarController.selectedIndex == 1 {
//            print("NowPlayingViewController: \(viewController)")
//            let nav = viewController as! UINavigationController
//            let vc = nav.topViewController as! NowPlayingViewController
//            nowPlayingBarVC.view.removeFromSuperview()
//            nowPlayingBarVC.willMove(toParent: nil)
//            nowPlayingBarVC.removeFromParent()
//            vc.addChild(nowPlayingBarVC)
//            nowPlayingBarVC.didMove(toParent: vc)
//            vc.view.addSubview(nowPlayingBarVC.view)
//            nowPlayingBarVC.view.anchor(leading: vc.view.leadingAnchor, trailing: vc.view.trailingAnchor, bottom: vc.separatorView.topAnchor)
//        } else if tabBarController.selectedIndex == 2 {
//            print("PlaylistViewController: \(viewController)")
//            let nav = viewController as! UINavigationController
//            let vc = nav.topViewController as! PlaylistViewController
//            nowPlayingBarVC.view.removeFromSuperview()
//            nowPlayingBarVC.willMove(toParent: nil)
//            nowPlayingBarVC.removeFromParent()
//            vc.addChild(nowPlayingBarVC)
//            nowPlayingBarVC.didMove(toParent: vc)
//            vc.view.addSubview(nowPlayingBarVC.view)
//            nowPlayingBarVC.view.anchor(leading: vc.view.leadingAnchor, trailing: vc.view.trailingAnchor, bottom: vc.separatorView.topAnchor)
//        }
//        if viewController is SearchViewController {
//            print("SearchViewController: \(viewController)")
//        } else if viewController is NowPlayingViewController {
//            print("NowPlayingViewController: \(viewController)")
//        } else if viewController is PlaylistViewController {
//            print("PlaylistViewController: \(viewController)")
//        }
//        switch viewController {
//        case is SearchViewController:
//            let vc = viewController as! SearchViewController
//            nowPlayingBarVC.view.removeConstraints()
//            nowPlayingBarVC.view.removeFromSuperview()
//            nowPlayingBarVC.willMove(toParent: nil)
//            nowPlayingBarVC.removeFromParent()
//            vc.addChild(nowPlayingBarVC)
//            nowPlayingBarVC.didMove(toParent: vc)
//            vc.view.addSubview(nowPlayingBarVC.view)
//            nowPlayingBarVC.view.anchor(leading: vc.view.leadingAnchor, trailing: vc.view.trailingAnchor, bottom: vc.separatorView.topAnchor)
//        case is NowPlayingViewController:
//            let vc = viewController as! NowPlayingViewController
//            nowPlayingBarVC.view.removeFromSuperview()
//            nowPlayingBarVC.willMove(toParent: nil)
//            nowPlayingBarVC.removeFromParent()
//            vc.addChild(nowPlayingBarVC)
//            nowPlayingBarVC.didMove(toParent: vc)
//            vc.view.addSubview(nowPlayingBarVC.view)
//            nowPlayingBarVC.view.anchor(leading: vc.view.leadingAnchor, trailing: vc.view.trailingAnchor, bottom: vc.separatorView.topAnchor)
//        case is PlaylistViewController:
//            let vc = viewController as! PlaylistViewController
//            nowPlayingBarVC.view.removeFromSuperview()
//            nowPlayingBarVC.willMove(toParent: nil)
//            nowPlayingBarVC.removeFromParent()
//            vc.addChild(nowPlayingBarVC)
//            nowPlayingBarVC.didMove(toParent: vc)
//            vc.view.addSubview(nowPlayingBarVC.view)
//            nowPlayingBarVC.view.anchor(leading: vc.view.leadingAnchor, trailing: vc.view.trailingAnchor, bottom: vc.separatorView.topAnchor)
//        default:
//            break
//        }
    }
}
