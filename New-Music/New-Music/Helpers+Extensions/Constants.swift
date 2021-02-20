//
//  Constants.swift
//  New-Music
//
//  Created by Michael McGrath on 10/9/20.
//

import SwiftUI

enum NeuButtonType {
    case trackForward
    case trackBackward
    case shuffle
    case menu
    case repeatPlayback
}

enum CardPosition: Double {
    case top = 1.0
    case middle = 0.5
    case bottom = 0.0
    
    var offset: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight - (screenHeight * CGFloat(self.rawValue))
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return CGSize(width: translation.width, height: max(0, translation.height))
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

enum GradientDirection {
    case diagonalTopToBottom
    case leadingToTrailing
    case topTrailingBottomLeading
}

enum AnimationType {
    case present
    case dismiss
}

enum NowPlayingViewState {
    case minimized
    case full
}

enum TransitionType {
    case navigation
    case modal
}

//enum PlayingMediaType {
//    case singleSong
//    case playlist
//    case album
//}

enum MediaType: String, Hashable, Codable {
    case song = "Songs"
    case album = "Albums"
    case artist = "Artists"
}

enum PlaylistMedia: Hashable, SettingItem {
    case song(Song)
    case playlist(Playlist)
	
	var settingType: SettingType {
		switch self {
		case .playlist(_):
			return .addToExistingPlaylist
		case .song(_):
			return .searchedSongSetting
		}
	}
	
	var description: String {
		switch self {
		case .song(let song):
			return song.songName
		case .playlist(let playlist):
			return playlist.playlistName
		}
	}
}
