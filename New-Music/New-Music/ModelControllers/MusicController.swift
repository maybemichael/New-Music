//
//  MusicController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/4/20.
//

import Foundation
import MediaPlayer

class MusicController: ObservableObject {

    let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    private var currentQueue = MPMusicPlayerStoreQueueDescriptor(storeIDs: [])
    private var timer: Timer?
    var currentPlaylist = [Song]() {
        didSet {
            if let lastAdded = currentPlaylist.last {
                currentQueue.storeIDs?.append(lastAdded.playID)
                musicPlayer.setQueue(with: self.currentQueue)
            }
        }
    }
    var searchedSongs = [Song]()
    lazy var nowPlayingViewModel = NowPlayingViewModel(musicPlayer: musicPlayer, artist: "", songTitle: "", albumArtwork: UIImage())
    
    func play() {
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
    
    init() {
        musicPlayer.beginGeneratingPlaybackNotifications()
    }
    
    deinit {
        timer?.invalidate()
        musicPlayer.endGeneratingPlaybackNotifications()
    }
}
