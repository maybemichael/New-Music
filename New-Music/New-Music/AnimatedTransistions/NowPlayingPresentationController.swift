//
//  NowPlayingPresentationController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/20/20.
//

import UIKit

final class NowPlayingPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
