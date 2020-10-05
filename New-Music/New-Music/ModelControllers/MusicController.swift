//
//  MusicController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/4/20.
//

import Foundation
import MediaPlayer

class MusicController {
    let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    var isPlaying = false
    var currentQueue = MPMusicPlayerStoreQueueDescriptor(storeIDs: [])
    var currentPlaylist = [Song]() {
        didSet {
            if let lastAdded = currentPlaylist.last {
                currentQueue.storeIDs?.append(lastAdded.playID)
                self.musicPlayer.setQueue(with: self.currentQueue)
            }
        }
    }
    var searchedSongs = [Song]()
    
    func play() {
        isPlaying = true
        if musicPlayer.isPreparedToPlay {
            musicPlayer.play()
        } else {
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        }
    }
    func pause() {
        isPlaying = false
        musicPlayer.pause()
    }
    
    func nextTrack() {
        musicPlayer.skipToNextItem()
    }
    
    func previousTrack() {
        musicPlayer.skipToPreviousItem()
    }
    
    func removeSongFromPlaylist(song: Song) {
        if let index = currentPlaylist.firstIndex(of: song) {
            currentPlaylist.remove(at: index)
        }
    }
    
    func addSongToPlaylist(indexPath: IndexPath) {
        let song = searchedSongs[indexPath.item]
        currentPlaylist.append(song)
    }
}
