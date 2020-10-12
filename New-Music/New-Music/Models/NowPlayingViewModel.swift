//
//  NowPlayingViewModel.swift
//  New-Music
//
//  Created by Michael McGrath on 10/6/20.
//

import UIKit
import MediaPlayer
import Combine

class NowPlayingViewModel: ObservableObject {
    var musicPlayer: MPMusicPlayerController
    var didChange = PassthroughSubject<UIImage?, Never>()
    var timer: Timer?
    @Published var artist: String = ""
    @Published var songTitle: String = ""
    @Published var duration: TimeInterval
    @Published var elapsedTime: TimeInterval
    @Published var isPlaying: Bool = false
    @Published var isSeeking: Bool = false
    @Published var albumArtwork: UIImage? = nil {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self.albumArtwork)
            }
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "m:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    init(musicPlayer: MPMusicPlayerController, artist: String, songTitle: String, albumArtwork: UIImage?, elapsedTime: TimeInterval = 0.0, duration: TimeInterval) {
        self.artist = artist
        self.songTitle = songTitle
        self.albumArtwork = albumArtwork
        self.elapsedTime = elapsedTime
        self.duration = duration
        self.musicPlayer = musicPlayer
        NotificationCenter.default.addObserver(self, selector: #selector(updateElapsedTime(_:)), name: .elapsedTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateNowPlayingItem(_:)), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(musicPlayerStateDidChange(_:)), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
    }
    
    @objc func updateElapsedTime(_ timer: Timer) {
        if musicPlayer.playbackState == .playing {
            self.elapsedTime = musicPlayer.currentPlaybackTime
        }
    }
    
    @objc func updateNowPlayingItem(_ notification: Notification) {
        self.albumArtwork = musicPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 1500, height: 1500))
        self.artist = musicPlayer.nowPlayingItem?.artist ?? ""
        self.songTitle = musicPlayer.nowPlayingItem?.title ?? ""
        if let duration = musicPlayer.nowPlayingItem?.playbackDuration {
            self.duration = duration
        }
        self.elapsedTime = 0.0
    }
    
    @objc func musicPlayerStateDidChange(_ notification: Notification) {
        let playbackState = musicPlayer.playbackState
        switch playbackState {
        case .stopped, .paused, .interrupted:
            self.isPlaying = false
            self.timer?.invalidate()
            self.timer = nil
        case .playing:
            isPlaying = true
            let timer = Timer(timeInterval: 1, target: self, selector: #selector(updateElapsedTime(_:)), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            self.timer = timer
            self.isSeeking = false 
        case .seekingBackward:
            isPlaying = true
        case .seekingForward:
            isPlaying = true
        @unknown default:
            fatalError("Unknown default case for the music players playback state.")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .elapsedTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
    }
}
