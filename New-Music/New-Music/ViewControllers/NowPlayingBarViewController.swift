//
//  NowPlayingContainerViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/30/20.
//

import UIKit

class NowPlayingBarViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentFullScreenNowPlaying(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentFullScreenNowPlaying(_ sender: UITapGestureRecognizer) {
        coordinator?.presentNowPlayingFullVC()
    }
}
