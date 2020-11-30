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
    private var songsAdded = false
    private let library = MPMediaLibrary()
    private var indexOfSongAdded = Int()
    private var isSearchedSong = false
    var sections = [Section]()
    var createPlaylistSongs = [Song]()
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
    
    func addSongToPlaylist(song: Song, isPlaylistSearch: Bool) {
        nowPlayingViewModel.playingMediaType = .playlist
        if isPlaylistSearch {
            createPlaylistSongs.append(song)
        } else {
            currentPlaylist.append(song)
            currentQueue.storeIDs?.append(song.playID)
            songsAdded = true
        }
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
    
    func saveToPersistentStore() {
        guard let playlistURL = self.userPlaylistURL else { return }
        do {
            let playlistData = try PropertyListEncoder().encode(self.userPlaylists)
            try playlistData.write(to: playlistURL)
        } catch {
            print("Error saving users playlists: \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        guard let playlistURL = self.userPlaylistURL else { return }
        do {
            let playlistData = try Data(contentsOf: playlistURL)
            let decoder = PropertyListDecoder()
            decoder.userInfo[.dataType] = "plist"
            self.userPlaylists = try decoder.decode([Playlist].self, from: playlistData)
        } catch {
            print("Error loading users playlists from plist: \(error).")
        }
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
            userPlaylists[index].songs = songs
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
    
//    func saveToPersistentStore() {
//        do {
//            try CoreDataStack.shared.save()
//        } catch {
//            print("Error Saving Managed Object Context: \(error)")
//            CoreDataStack.shared.mainContext.reset()
//        }
//    }
    
    init() {
        musicPlayer.beginGeneratingPlaybackNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChange(_:)), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        loadFromPersistentStore()
//        do {
//            let fetchRequest: NSFetchRequest<PersistedPlaylist> = PersistedPlaylist.fetchRequest()
//            let playlists = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
//            DispatchQueue.global().async { [weak self] in
//                guard let self = self else { return }
//                playlists.forEach {
//                    if let playlist = $0.playlist {
//                        self.userPlaylists.append(playlist)
//                        self.updateAlbumArtwork(for: playlist)
//                    }
//                }
//            }
//        } catch {
//            print("Unable to successfully perform fetch request.")
//        }
    }
    
    deinit {
        musicPlayer.endGeneratingPlaybackNotifications()
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
    }
}
