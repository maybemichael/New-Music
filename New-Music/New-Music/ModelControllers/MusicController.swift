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
    var currentPlaylist = [Song]()
    var searchedSongs = [Song]()
    lazy var nowPlayingViewModel = NowPlayingViewModel(musicPlayer: musicPlayer, artist: "", songTitle: "", albumArtwork: UIImage(), duration: 0.0)
    
    func play() {
        musicPlayer.setQueue(with: currentQueue)
        if musicPlayer.isPreparedToPlay {
            musicPlayer.play()
        } else {
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        }
    }
    
    func pause() {
        musicPlayer.pause()
    }
    
    func nextTrack() {
        if musicPlayer.playbackState == .playing {
            musicPlayer.pause()
            musicPlayer.prepareToPlay()
            musicPlayer.skipToNextItem()
            musicPlayer.play()
        } else {
            musicPlayer.skipToNextItem()
        }
    }
    
    func previousTrack() {
        if musicPlayer.playbackState == .playing {
            musicPlayer.pause()
            musicPlayer.prepareToPlay()
            musicPlayer.skipToPreviousItem()
            musicPlayer.play()
        } else {
            musicPlayer.skipToPreviousItem()
        }
    }
    
    func removeSongFromPlaylist(song: Song) {
        if let index = currentPlaylist.firstIndex(of: song) {
            currentPlaylist.remove(at: index)
        }
    }
    
    func addSongToPlaylist(song: Song) {
        currentPlaylist.append(song)
        currentQueue.storeIDs?.append(song.playID)
        musicPlayer.setQueue(with: currentQueue)
    }
    
    @objc func updateElapsedTime(_ timer: Timer) {
        if musicPlayer.playbackState == .playing {
            let elapsedTime = musicPlayer.currentPlaybackTime
            let elapsedTimeDictionary: [String: TimeInterval] = ["elapsedTime": elapsedTime]
            NotificationCenter.default.post(name: .elapsedTime, object: nil, userInfo: elapsedTimeDictionary)
        }
    }
    
    @objc func playbackStateDidChange(_ notification: Notification) {
        let playbackState = musicPlayer.playbackState
        switch playbackState {
        case .stopped:
            print("Music Player Playback State is Stopped.")
        case .paused:
            print("Music Player Playback State is Paused.")
        case .playing:
            print("Music Player Playback State is Playing.")
        case .interrupted:
            print("Playback state changed interupted.")
        case .seekingBackward:
            print("Playback state changed seeking backward.")
        case .seekingForward:
            print("Playback state changed seeking forward.")
        @unknown default:
            fatalError("Unknown default case for the music players playback state.")
        }
    }
    
    init() {
        musicPlayer.beginGeneratingPlaybackNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChange(_:)), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
    }
    
    deinit {
        timer?.invalidate()
        musicPlayer.endGeneratingPlaybackNotifications()
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
    }
}
