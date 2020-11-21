//
//  PlayingIndicatorViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 11/18/20.
//

import SwiftUI

class PlayingIndicatorViewController: UIHostingController<PlayingIndicatorView> {

    var song: Song {
        didSet {
            rootView.song = self.song
        }
    }
    
    var musicController: MusicController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    init(song: Song, contentView: PlayingIndicatorView, musicController: MusicController) {
        self.song = song
        self.musicController = musicController
        super.init(rootView: contentView)
        
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
