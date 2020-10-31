//
//  NowPlayingContainerViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/30/20.
//

import UIKit

class NowPlayingContainerViewController: UIViewController, FullScreenNowPlaying {
    

    let interactor = Interactor()
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    func presentFullScreen() {
        coordinator?.presentFullScreenNowPlaying(fromVC: self)
    }
}

extension NowPlayingContainerViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DismissAnimator(type: .modal, interactor: interactor)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.isStarted ? interactor : nil
    }
}
