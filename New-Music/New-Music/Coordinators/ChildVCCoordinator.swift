//
//  ChildVCCoordinator.swift
//  New-Music
//
//  Created by Michael McGrath on 11/17/20.
//

import SwiftUI

class ChildVCCoordinator: NSObject {
    var viewControllersByIndexPath = [IndexPath: UIViewController]()
    var unusedViewControllers = Set<UIViewController>()
    
    func addChild(parent: UIViewController, indexPath: IndexPath, musicController: MusicController, song: Song) -> UIViewController {
        var child: PlayingIndicatorViewController
        if unusedViewControllers.count > 0 {
            child = unusedViewControllers.popFirst()! as! PlayingIndicatorViewController
        } else {
            child = PlayingIndicatorViewController(song: song, contentView: PlayingIndicatorView(nowPlayingViewModel: musicController.nowPlayingViewModel, song: song, size: UIScreen.main.bounds.width / 10), musicController: musicController)
        }
        viewControllersByIndexPath[indexPath] = child
        return child
    }
    
    func remove(at indexPath: IndexPath) {
        guard let viewController = viewControllersByIndexPath[indexPath] else { return }
        viewController.view.removeFromSuperview()
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewControllersByIndexPath.removeValue(forKey: indexPath)
        unusedViewControllers.insert(viewController)
    }
}
