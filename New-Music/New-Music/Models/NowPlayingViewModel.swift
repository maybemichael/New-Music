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
    lazy var nowPlayingItem = musicPlayer.nowPlayingItem {
        didSet {
            self.artist = nowPlayingItem?.artist ?? ""
            self.songTitle = nowPlayingItem?.title ?? ""
            if let duration = nowPlayingItem?.playbackDuration {
                let durationDate = Date(timeIntervalSinceReferenceDate: duration)
                self.duration = dateFormatter.string(from: durationDate)
            }
            self.albumArtwork = nowPlayingItem?.artwork?.image(at: CGSize(width: 1400, height: 1400))
        }
    }
    var musicPlayer: MPMusicPlayerController
    var didChange = PassthroughSubject<UIImage?, Never>()
    @Published var artist: String = ""
    @Published var songTitle: String = ""
    @Published var duration: String
    @Published var elapsedTime: String
    @Published var isPlaying: Bool = false
    @Published var albumArtwork: UIImage? {
        didSet {
            DispatchQueue.main.async {
                if let artwork = self.albumArtwork {
                    self.didChange.send(artwork)
                }
            }
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "m:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    init(musicPlayer: MPMusicPlayerController, artist: String, songTitle: String, albumArtwork: UIImage?, elapsedTime: String = "0:00", duration: String = "") {
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
    
    @objc func updateElapsedTime(_ notification: Notification) {
        guard let elapsedTime = notification.userInfo?["elapsedTime"] as? TimeInterval else { return }
        let elapsedTimeDate = Date(timeIntervalSinceReferenceDate: elapsedTime)
        self.elapsedTime = self.dateFormatter.string(from: elapsedTimeDate)
    }
    
    @objc func updateNowPlayingItem(_ notification: Notification) {
        if let nowPlayingItem = musicPlayer.nowPlayingItem {
            self.nowPlayingItem = nowPlayingItem
        }
    }
    
    @objc func musicPlayerStateDidChange(_ notification: Notification) {
        let playbackState = musicPlayer.playbackState
        switch playbackState {
        case .stopped:
            isPlaying = false
            self.elapsedTime = "0:00"
//            print("Playback state changed stopped.")
        case .paused:
            isPlaying = false
//            print("Playback state changed paused.")
        case .playing:
            isPlaying = true
//            print("Playback state changed playing.")
        case .interrupted:
            isPlaying = false
//            print("Playback state changed interupted.")
        case .seekingBackward:
            isPlaying = true
//            print("Playback state changed seeking backward.")
        case .seekingForward:
            isPlaying = true
//            print("Playback state changed seeking forward.")
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
