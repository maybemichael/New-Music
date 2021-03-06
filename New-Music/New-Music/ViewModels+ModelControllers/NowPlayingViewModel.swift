//
//  NowPlayingViewModel.swift
//  New-Music
//
//  Created by Michael McGrath on 10/6/20.
//

import SwiftUI
import MediaPlayer
import Combine

class NowPlayingViewModel: ObservableObject {
    var musicPlayer: MPMusicPlayerController
    var didChange = PassthroughSubject<UIImage?, Never>()
	private var displaylink: CADisplayLink? {
		willSet {
			displaylink?.invalidate()
		}
	}
    var searchedSong: Song?
    @Published var nowPlayingSong: Song? {
        didSet {
            playID = nowPlayingSong?.playID
			UserDefaults.standard.set(index, forKey: UserDefaults.lastPlayedSongIndex)
			if isInitial {
				setLastSongOnInitialAppLoad()
				isInitial = false
			}
        }
    }
	var isInitial = true
    @Published var playID: String?
    @Published var songs: [Song]
    @Published var artist: String = ""
    @Published var songTitle: String = ""
    @Published var duration: TimeInterval
    @Published var elapsedTime: TimeInterval
    @Published var timeRemaining: TimeInterval
    @Published var isPlaying: Bool = false
    @Published var whiteLevel: CGFloat = 0
    @Published var lighterAccentColor: Color
    @Published var darkerAccentColor: Color
    @Published var isTooLight = false
    @Published var isFull = false
    @Published var isMinimized = true 
    @Published var shouldAnimateColorChange = false 
    @Published var getFrame = false
    @Published var shouldGetPrefChange = false
    @Published var textColor1: Color
    @Published var textColor2: Color
    @Published var textColor3: Color
    @Published var textColor4: Color
    @Published var lighterUIColor: UIColor 
    @Published var darkerUIColor: UIColor
    @Published var lighterTextColor2: UIColor
    @Published var darkerTextColor2: UIColor
    @Published var minimizedImageFrame: CGRect = CGRect()
    @Published var fullImageFrame: CGRect = CGRect()
    @Published var albumArtwork: UIImage? = nil {
        didSet {
            DispatchQueue.main.async {
                if self.albumArtwork == nil && self.nowPlayingSong != nil {
                    if let data = self.nowPlayingSong?.albumArtwork {
                        self.albumArtwork = UIImage(data: data)
                    } else {
                        self.updateAlbumArtwork { _ in
                            self.didChange.send(self.albumArtwork)
                        }
                    }
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
    
    @objc func updateElapsedTime(_ displayLink: CADisplayLink) {
		if let duration = musicPlayer.nowPlayingItem?.playbackDuration {
			let currentElapsedTime = musicPlayer.currentPlaybackTime
			let currentTimeRemaining = duration - currentElapsedTime
			timeRemaining = max(0, currentTimeRemaining)
			elapsedTime = min(duration, currentElapsedTime)
		}
    }
    
    @objc func updateNowPlayingItem(_ notification: Notification) {
        self.albumArtwork = musicPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 1500, height: 1500))
        self.artist = musicPlayer.nowPlayingItem?.artist ?? ""
        self.songTitle = musicPlayer.nowPlayingItem?.title ?? ""
        if let duration = musicPlayer.nowPlayingItem?.playbackDuration {
            self.duration = duration
            self.timeRemaining = duration
        }
        self.elapsedTime = 0.0
        let index = musicPlayer.indexOfNowPlayingItem
        self.nowPlayingSong = songs[index]
        if let colors = getGradientColors() {
            self.lighterAccentColor = colors.lighter
            self.darkerAccentColor = colors.darker
        }
        getTextColors()
    }

	private func setLastSongOnInitialAppLoad() {
		albumArtwork = nowPlayingSong?.albumArtwork == nil ? nil : UIImage(data: nowPlayingSong?.albumArtwork ?? Data())
		artist = nowPlayingSong?.artistName ?? ""
		songTitle = nowPlayingSong?.songName ?? ""
		duration = nowPlayingSong?.duration ?? 0.0
		timeRemaining = nowPlayingSong?.duration ?? 0.0
		elapsedTime = 0.0
		if let colors = getGradientColors() {
			self.lighterAccentColor = colors.lighter
			self.darkerAccentColor = colors.darker
		}
		getTextColors()
	}
    
    @objc
	func musicPlayerStateDidChange(_ notification: Notification) {
        determinePlaybackState()
        switch musicPlayer.playbackState {
        case .stopped, .paused, .interrupted:
			displaylink?.isPaused = true
        case .playing:
			createDisplayLink()
        default:
			break
        }
    }
    
    private func updateAlbumArtwork(completion: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        guard var stringURL = nowPlayingSong?.stringURL else { return }
        stringURL = stringURL.replacingOccurrences(of: "{w}", with: String(Int(500))).replacingOccurrences(of: "{h}", with: String(Int(500)))
        let imageURL = URL(string: stringURL)!
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let networkError = NetworkError(data: data, response: nil, error: error) {
                print("Error retrieving image data: \(networkError.localizedDescription)")
                completion(.failure(networkError))
                return
            }
            DispatchQueue.main.async {
                self.albumArtwork = UIImage(data: data!)
            }
            completion(.success(self.albumArtwork))
        }.resume()
    }
    
    private func getGradientColors() -> (lighter: Color, darker: Color)? {
        guard let hexString = self.nowPlayingSong?.accentColorHex else { return nil }
        
        let apiColor = hexStringToUIColor(hex: hexString)
        var secondColor = UIColor()
        
        if isLightColor(color: apiColor, threshold: 0.5) {
            secondColor = apiColor.darker()
            if isLightColor(color: apiColor, threshold: 0.7) && isLightColor(color: secondColor, threshold: 0.7) {
                self.isTooLight = true
            } else {
                self.isTooLight = false
            }
            self.lighterUIColor = apiColor
            self.darkerUIColor = secondColor
            return (Color(apiColor), Color(secondColor))
        } else {
            secondColor = apiColor.lighter()
            if isLightColor(color: apiColor, threshold: 0.7) && isLightColor(color: secondColor, threshold: 0.7) {
                self.isTooLight = true
            } else {
                self.isTooLight = false
            }
            self.lighterUIColor = secondColor
            self.darkerUIColor = apiColor
            return (Color(secondColor), Color(apiColor))
        }
    }
    
    private func getTextColors() {
        guard
            let text1String = self.nowPlayingSong?.textColor1,
            let text2String = self.nowPlayingSong?.textColor2,
            let text3String = self.nowPlayingSong?.textColor3,
            let text4String = self.nowPlayingSong?.textColor4
        else { return }
        
        let text1UIColor = hexStringToUIColor(hex: text1String)
        let text2UIColor = hexStringToUIColor(hex: text2String)
        let text3UIColor = hexStringToUIColor(hex: text3String)
        let text4UIColor = hexStringToUIColor(hex: text4String)
        
        self.textColor1 = Color(text1UIColor)
        self.textColor2 = Color(text2UIColor)
        self.textColor3 = Color(text3UIColor)
        self.textColor4 = Color(text4UIColor)
        
        self.lighterTextColor2 = text2UIColor
        self.darkerTextColor2 = text2UIColor.darker()
    }
    
    private func isLightColor(color: UIColor, threshold: CGFloat) -> Bool {
        var white: CGFloat = 0.0
        color.getWhite(&white, alpha: nil)
        self.whiteLevel = white
        return white >= threshold
    }
    
    private func hexStringToUIColor (hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    private func determinePlaybackState() {
		let isMusicPlaying = musicPlayer.playbackState == .playing
		if isPlaying != isMusicPlaying {
			isPlaying = isMusicPlaying
		}
    }

	private func createDisplayLink() {
		self.displaylink = CADisplayLink(target: self, selector: #selector (updateElapsedTime))
		self.displaylink?.preferredFramesPerSecond = 30
		self.displaylink?.add(to: .current, forMode: .common)
	}

	func startDisplayLink() {
		guard displaylink != nil else {
			createDisplayLink()
			return
		}
		displaylink?.isPaused = false
	}

	func stopDisplayLink() {
		displaylink?.isPaused = true
	}

	func setLastNowPlayingSong() {
		guard let nowPlayingSong = self.nowPlayingSong else { return }
		self.albumArtwork = UIImage(data: nowPlayingSong.albumArtwork ?? Data())
		self.artist = nowPlayingSong.artistName
		self.songTitle = nowPlayingSong.songName
		self.duration = nowPlayingSong.duration
		self.timeRemaining = nowPlayingSong.duration
		self.elapsedTime = 0.0
		if let colors = getGradientColors() {
			self.lighterAccentColor = colors.lighter
			self.darkerAccentColor = colors.darker
		}
		getTextColors()
	}

	init(musicPlayer: MPMusicPlayerController, artist: String, songTitle: String, albumArtwork: UIImage? = UIImage(), elapsedTime: TimeInterval = 0.0, duration: TimeInterval, songs: [Song], lighterAccentColor: Color = Color(UIColor.systemGraySix!), darkerAccentColor: Color = Color.black) {
		self.artist = artist
		self.songTitle = songTitle
		self.albumArtwork = albumArtwork
		self.elapsedTime = elapsedTime
		self.duration = duration
		self.musicPlayer = musicPlayer
		self.lighterAccentColor = lighterAccentColor
		self.darkerAccentColor = darkerAccentColor
		self.songs = songs
		self.textColor1 = Color.black
		self.textColor2 = Color.white
		self.textColor3 = Color.lightTextColor
		self.textColor4 = Color.black
		self.timeRemaining = 0.0
		self.lighterUIColor = UIColor.systemBlue.lighter()
		self.darkerUIColor = .systemBlue
		self.lighterTextColor2 = .black
		self.darkerTextColor2 = .black
		NotificationCenter.default.addObserver(self, selector: #selector(updateElapsedTime(_:)), name: .elapsedTime, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateNowPlayingItem(_:)), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(musicPlayerStateDidChange(_:)), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
		determinePlaybackState()
	}

    deinit {
		displaylink?.invalidate()
		displaylink = nil
        NotificationCenter.default.removeObserver(self, name: .elapsedTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
    }
}

