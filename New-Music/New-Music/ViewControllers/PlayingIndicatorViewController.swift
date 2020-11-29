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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    init(song: Song, contentView: PlayingIndicatorView, musicController: MusicController) {
        self.song = song
        self.musicController = musicController
        super.init(rootView: contentView)
        
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard is horrible")
    }
}
