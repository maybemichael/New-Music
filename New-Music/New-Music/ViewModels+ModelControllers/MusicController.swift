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
    private var songsAdded = false
    var currentPlaylist = [Song]() {
        didSet {
            self.nowPlayingViewModel.songs = self.currentPlaylist
        }
    }
    var searchedSongs = [Media]() {
        didSet {
            print("Searched Songs: \(self.searchedSongs.count)")
        }
    }
    var searchedAlbums = [Media]() {
        didSet {
            print("Searched Albums: \(self.searchedAlbums.count)")
        }
    }
    
    var searchedMedia = [Media]()
    
    lazy var nowPlayingViewModel: NowPlayingViewModel = {
        let viewModel = NowPlayingViewModel(musicPlayer: musicPlayer, artist: "", songTitle: "", duration: 0, songs: currentPlaylist)
        return viewModel
    }()
    
    func play() {
        if musicPlayer.isPreparedToPlay {
            musicPlayer.play()
        } else {
            musicPlayer.prepareToPlay()
            self.musicPlayer.play()
        }
    }
    
    func pause() {
        musicPlayer.pause()
    }
    
    func nextTrack() {
//        musicPlayer.prepareToPlay()
//        musicPlayer.skipToNextItem()
//        musicPlayer.play()
        if musicPlayer.playbackState == .playing {
            if songsAdded {
                musicPlayer.prepareToPlay()
                musicPlayer.skipToNextItem()
                musicPlayer.play()
                songsAdded = false
            } else {
                musicPlayer.skipToNextItem()
            }
        } else {
            musicPlayer.skipToNextItem()
        }
    }
    
    func previousTrack() {
        if musicPlayer.playbackState == .playing {
            if songsAdded {
                musicPlayer.prepareToPlay()
                musicPlayer.skipToPreviousItem()
                musicPlayer.play()
                songsAdded = false
            } else {
                musicPlayer.skipToPreviousItem()
            }
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
//        let playIDs = currentPlaylist.map { $0.playID }
        currentQueue.storeIDs?.append(song.playID)
        musicPlayer.setQueue(with: currentQueue)
        songsAdded = true
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
        musicPlayer.endGeneratingPlaybackNotifications()
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
    }
}
