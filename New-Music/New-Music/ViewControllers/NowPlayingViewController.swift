//
//  NowPlayingViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI
import MediaPlayer

class NowPlayingViewController: UIViewController {

//    let imageView = UIImageView()
//    let playButton = UIButton()
//    let trackForwardButton = UIButton()
//    let trackBackwardButton = UIButton()
//    let musicControlView = UIView()
//    let artist = UILabel()
//    let songTitle = UILabel()
//    var isPlaying = false
    
    var viewModel = NowPlayingViewModel(artist: " ", songTitle: " ", albumArtwork: UIImage())
    
    var musicController: MusicController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentView = UIHostingController(rootView: NowPlayingView(viewModel: viewModel))
        view.backgroundColor = .backgroundColor
        addChild(contentView)
        view.addSubview(contentView.view)
        contentView.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
        musicPlayerNotifications()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    private func musicPlayerNotifications() {
        NotificationCenter.default.addObserver(forName: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil, queue: nil) { _ in
            if let nowPlayingItem = MusicController.shared.musicPlayer.nowPlayingItem {
                self.viewModel.updateNowPlaying(mediaItem: nowPlayingItem)
                
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
    }
}


