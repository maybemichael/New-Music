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
    
    func addChild(parent: UIViewController, indexPath: IndexPath, musicController: MusicController) -> UIViewController {
        var child: UIViewController
        if unusedViewControllers.count > 0 {
            child = unusedViewControllers.popFirst()!
        } else {
            child = CurrentPlaylistCellViewController(musicController: musicController)
        }
        viewControllersByIndexPath[indexPath] = child
        parent.addChild(child)
        child.didMove(toParent: parent)
        return child
    }
    
//    func getVC(for indexPath: IndexPath, musicController: MusicController) -> UIViewController {
//        if let childVC = viewControllersByIndexPath[indexPath] {
//            return childVC
//        } else {
//            return CurrentPlaylistCellViewController(musicController: musicController)
//        }
//    }
    
    func remove(at indexPath: IndexPath) {
        guard let viewController = viewControllersByIndexPath[indexPath] else { return }
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        viewControllersByIndexPath.removeValue(forKey: indexPath)
        unusedViewControllers.insert(viewController)
    }
}
