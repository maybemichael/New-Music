//
//  PlaylistViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit

class PlaylistViewController: UIViewController {

    var musicController: MusicController!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}