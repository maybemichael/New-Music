//
//  NowPlayingViewModel.swift
//  New-Music
//
//  Created by Michael McGrath on 10/6/20.
//

import Foundation
import SwiftUI
import MediaPlayer

class NowPlayingViewModel: ObservableObject {
    @Published var artist: String
    @Published var songTitle: String
    @Published var albumArtwork: UIImage?
    
    init(musicController: MusicController) {
        self.artist = musicController.musicPlayer.nowPlayingItem?.albumArtist ?? ""
        self.songTitle = musicController.musicPlayer.nowPlayingItem?.title ?? ""
//        self.albumArtwork = musicController.musicPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 1500, height: 1500))
        self.albumArtwork = musicController.nowPlayingArt
    }
}
