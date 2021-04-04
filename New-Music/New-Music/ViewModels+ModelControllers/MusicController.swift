//
//  MusicController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/4/20.
//

import Foundation
import MediaPlayer
import CoreData

class MusicController: ObservableObject {

    let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    private var currentQueue = MPMusicPlayerStoreQueueDescriptor(storeIDs: [])
	var songsAdded = false
	var addSongToPlaylistTuple: (playlist: Playlist, song: Song)?
    private let library = MPMediaLibrary()
    private var indexOfSongAdded = Int()
    private var isSearchedSong = false
	var userPlaylistsBackingStore = Dictionary<String, Any>()
    var sections = [Section]()
	var createPlaylistSongs = [Song]() {
		didSet {
			songsAdded = true
		}
	}
    var userPlaylists = [Playlist]() {
        didSet {
            self.saveToPersistentStore()
        }
    }
    
    var userPlaylistURL: URL? {
        let fileManager = FileManager.default
        guard let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let playlistURL = documentsDir.appendingPathComponent("UserPlaylist.plist")
        return playlistURL
    }
    
    var nowPlayingPlaylist: Playlist? {
        didSet {
            guard let songs = self.nowPlayingPlaylist?.songs else { return }
            self.nowPlayingViewModel.songs = songs
			UserDefaults.standard.setValue(nowPlayingPlaylist?.id, forKey: UserDefaults.nowPlayingPlaylistID)
        }
    }
    
	var currentPlaylist = Playlist(playlistName: "") {
        didSet {
//            self.nowPlayingViewModel.songs = self.currentPlaylist
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
    
    lazy var nowPlayingViewModel = NowPlayingViewModel(musicPlayer: musicPlayer, artist: "", songTitle: "", duration: 0, songs: [])
    
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
    
    func addSongToPlaylist(song: Song, isPlaylistSearch: Bool) {
		currentPlaylist.addNewSong(song: song)
		currentQueue.storeIDs?.append(song.playID)
		songsAdded = true
    }
    
    func playlistSongTapped(index: Int) {
        musicPlayer.stop()
        currentQueue.storeIDs?.removeAll()
		currentQueue.storeIDs = currentPlaylist.songs.map { $0.playID }
		currentQueue.startItemID = nowPlayingPlaylist?.songs[index].playID
//        currentQueue.startItemID = currentPlaylist[index].playID
//        currentPlaylist[index].isPlaying = true
        musicPlayer.setQueue(with: currentQueue)
		nowPlayingViewModel.nowPlayingSong = currentPlaylist.songs[index]
        musicPlayer.prepareToPlay()
        musicPlayer.play()
    }
    
    func shufflePlaylist() {
        nowPlayingPlaylist?.shufflePlaylistSongs()
        let shuffledPlaylist = nowPlayingPlaylist?.songs.map { $0.playID }
        if musicPlayer.playbackState == .playing {
            pause()
            musicPlayer.setQueue(with: shuffledPlaylist!)
            nowPlayingViewModel.songs = nowPlayingPlaylist!.songs
            play()
        } else {
            musicPlayer.setQueue(with: shuffledPlaylist!)
            nowPlayingViewModel.songs = nowPlayingPlaylist!.songs
            play()
        }
    }
    
    func saveToPersistentStore() {
        guard let playlistURL = self.userPlaylistURL else { return }
        do {
            let playlistData = try PropertyListEncoder().encode(self.userPlaylists)
            try playlistData.write(to: playlistURL)
        } catch {
            print("Error saving users playlists: \(error)")
        }
    }
    
    private func loadFromPersistentStore() {
        guard let playlistURL = self.userPlaylistURL else { return }
        do {
            let playlistData = try Data(contentsOf: playlistURL)
            let decoder = PropertyListDecoder()
            decoder.userInfo[.dataType] = "plist"
            self.userPlaylists = try decoder.decode([Playlist].self, from: playlistData)
        } catch {
            print("Error loading users playlists from plist: \(error).")
        }
		userPlaylists.forEach { playlist in
			userPlaylistsBackingStore[playlist.id] = playlist
			playlist.songs.forEach { song in
				var newSong = song
				if userPlaylistsBackingStore.keys.contains(song.id) {
					newSong = Song(copiedFrom: song)
				}
				userPlaylistsBackingStore[newSong.id] = newSong
			}
		}
		print("This is it: \(userPlaylistsBackingStore["A88F38AC-C783-459E-9111-123AB1809B3E"])")
    }
    
    func updateAlbumArtwork(for playlist: Playlist) {
        var songs = [Song]()
            playlist.songs.forEach {
                var song = $0
                if song.albumArtwork == nil {
                    APIController.shared.fetchImage(mediaItem: song, size: 500) { result in
                        switch result {
                        case .success(let imageData):
                            song.albumArtwork = imageData
                        case .failure(let error):
                            print("Error fetching songs for searchTerm: \(error.localizedDescription)")
                        }
                    }
                }
                songs.append(song)
            }
        if let index = userPlaylists.firstIndex(of: playlist) {
			userPlaylists[index].replacePlaylistSongs(with: songs)
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
        loadFromPersistentStore()
		guard let currentPlaylistID = UserDefaults.standard.string(forKey: UserDefaults.nowPlayingPlaylistID) else { return }
		self.nowPlayingPlaylist = userPlaylists.first(where: { $0.id == currentPlaylistID })
		guard nowPlayingPlaylist != nil else { return }
		let index = UserDefaults.standard.integer(forKey: UserDefaults.lastPlayedSongIndex)
		nowPlayingViewModel.nowPlayingSong = nowPlayingPlaylist?.songs[index]
    }
    
    deinit {
        musicPlayer.endGeneratingPlaybackNotifications()
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
    }
}
