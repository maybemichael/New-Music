//
//  NowPlayingViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit

class NowPlayingViewController: UIViewController {

    let imageView = UIImageView()
    let playButton = UIButton()
    let trackForwardButton = UIButton()
    let trackBackwardButton = UIButton()
    let musicControlView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundColor
    }
    
    private func configureMusicControlls() {
        view.addSubview(musicControlView)
        musicControlView.setSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 8)
        playButton.setImage(UIImage(systemName: "play"), for: .normal)
        trackForwardButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        trackBackwardButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
    }
}
