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
    private let library = MPMediaLibrary()
    private var indexOfSongAdded = Int()
    private var isSearchedSong = false 
    
    var currentPlaylist = [Song]() {
        didSet {
            self.nowPlayingViewModel.songs = self.currentPlaylist
        }
    }
    var searchedSongs = [Media]() {
        didSet {

        }
    }
    var searchedAlbums = [Media]() {
        didSet {

        }
    }
    
    var searchedMedia = [Media]()
    
    lazy var nowPlayingViewModel: NowPlayingViewModel = {
        let viewModel = NowPlayingViewModel(musicPlayer: musicPlayer, artist: "", songTitle: "", duration: 0, songs: currentPlaylist)
        return viewModel
    }()
    
    func play() {
        musicPlayer.prepareToPlay()
        musicPlayer.play()
    }
    
    func pause() {
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
    
    func addSongToPlaylist(song: Song) {
        currentPlaylist.append(song)
        currentQueue.storeIDs?.append(song.playID)
        nowPlayingViewModel.playingMediaType = .playlist
        songsAdded = true
    }
    
    func playlistSongTapped(index: Int) {
        musicPlayer.stop()
        currentQueue.storeIDs?.removeAll()
        currentQueue.storeIDs = currentPlaylist.map { $0.playID }
        currentQueue.startItemID = currentPlaylist[index].playID
        currentPlaylist[index].isPlaying = true
        musicPlayer.setQueue(with: currentQueue)
        nowPlayingViewModel.playingMediaType = .playlist
        nowPlayingViewModel.nowPlayingSong = currentPlaylist[index]
        musicPlayer.prepareToPlay()
        musicPlayer.play()
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
