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
    var didChange = PassthroughSubject<UIImage?, Never>()
    @Published var artist: String
    @Published var songTitle: String
    @Published var duration: String
    @Published var elapsedTime: String
    @Published var albumArtwork: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self.albumArtwork!)
            }
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "m:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    init(artist: String, songTitle: String, albumArtwork: UIImage?, currentTime: String = "", duration: String = "") {
        self.artist = artist
        self.songTitle = songTitle
        self.albumArtwork = albumArtwork
        self.elapsedTime = currentTime
        self.duration = duration
        NotificationCenter.default.addObserver(forName: .elapsedTime, object: nil, queue: nil) { notification in
            guard let elapsedTime = notification.userInfo?["elapsedTime"] as? TimeInterval else { return }
            let elapsedTimeDate = Date(timeIntervalSinceReferenceDate: elapsedTime)
            self.elapsedTime = self.dateFormatter.string(from: elapsedTimeDate)
        }
    }
    
    func updateNowPlaying(mediaItem: MPMediaItem) {
        self.artist = mediaItem.artist ?? "0:00"
        self.songTitle = mediaItem.title ?? ""
        self.albumArtwork = mediaItem.artwork?.image(at: CGSize(width: 1400, height: 1400))
        let currentTimeDate = Date(timeIntervalSinceReferenceDate: MusicController.shared.musicPlayer.currentPlaybackTime)
        let durationDate = Date(timeIntervalSinceReferenceDate: mediaItem.playbackDuration)
        self.elapsedTime = dateFormatter.string(from: currentTimeDate)
        self.duration = dateFormatter.string(from: durationDate)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .elapsedTime, object: nil)
    }
}
