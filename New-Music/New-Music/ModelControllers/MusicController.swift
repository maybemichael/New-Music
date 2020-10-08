//
//  MusicController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/4/20.
//

import Foundation
import MediaPlayer

class MusicController: ObservableObject {
    static let shared = MusicController()
    let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    var isPlaying = false
    private var currentQueue = MPMusicPlayerStoreQueueDescriptor(storeIDs: [])
    var timer: Timer?
    var currentPlaylist = [Song]() {
        didSet {
            if let lastAdded = currentPlaylist.last {
                currentQueue.storeIDs?.append(lastAdded.playID)
                self.musicPlayer.setQueue(with: self.currentQueue)
            }
        }
    }
    var searchedSongs = [Song]()
    var nowPlayingSong: MPMediaItem?
    
    func play() {
        isPlaying = true
        musicPlayer.beginGeneratingPlaybackNotifications()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateElapsedTime(_:)), userInfo: nil, repeats: true)
        if musicPlayer.isPreparedToPlay {
            musicPlayer.play()
        } else {
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        }
        timer?.fire()
    }
    func pause() {
        isPlaying = false
        musicPlayer.pause()
        timer?.invalidate()
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
    
    func addSongToPlaylist(song: Song) {
        currentPlaylist.append(song)
    }
    
    @objc func updateElapsedTime(_ timer: Timer) {
        let elapsedTime = musicPlayer.currentPlaybackTime
        let elapsedTimeDictionary: [String: TimeInterval] = ["elapsedTime": elapsedTime]
        NotificationCenter.default.post(name: .elapsedTime, object: nil, userInfo: elapsedTimeDictionary)
    }
    
    deinit {
        timer?.invalidate()
    }
}
