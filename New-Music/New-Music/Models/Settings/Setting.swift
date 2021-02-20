//
//  Setting.swift
//  New-Music
//
//  Created by Michael McGrath on 1/23/21.
//

import UIKit

protocol SettingItem: CustomStringConvertible {
	var settingType: SettingType { get }
}

struct Setting: Hashable {
	
	var id = UUID().uuidString
	var setting: SettingItem
	
	static func == (lhs: Setting, rhs: Setting) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

enum SettingType {
	case searchedSongSetting
	case addToExistingPlaylist
	case playlistSetting
}

enum SettingsObject: Hashable, SettingItem {
	var settingType: SettingType {
		get {
			return .searchedSongSetting
		}
	}
	
	case song(Song)
	case closeButton
	
	var description: String {
		switch self {
		case .song(let song):
			return song.songName
		case .closeButton:
			return "Playlist Actions..."
		}
	}
}

enum SearchedSongSetting: Int, CaseIterable, Hashable, CustomStringConvertible, SettingItem {

	case playSong
	case createNewPlaylist
	case addToExistingPlaylist
	
	var settingType: SettingType {
		return .searchedSongSetting
	}
	
	var description: String {
		switch self {
		case .playSong:
			return "Play Song"
		case .createNewPlaylist:
			return "Create a new playlist..."
		case .addToExistingPlaylist:
			return "Add to existing playlist..."
		}
	}
	
	var image: UIImage {
		switch self {
		case .playSong:
			return UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium, scale: .default).configurationWithoutPointSizeAndWeight()) ?? UIImage()
		case .createNewPlaylist:
			return UIImage(systemName: "music.note.list", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium, scale: .default).configurationWithoutPointSizeAndWeight()) ?? UIImage()
		case .addToExistingPlaylist:
			return UIImage(systemName: "text.badge.plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium, scale: .default).configurationWithoutPointSizeAndWeight()) ?? UIImage()
		}
	}
}

enum PlaylistSetting: Int, CaseIterable, Hashable, CustomStringConvertible, SettingItem {
	case createNewPlaylist
	case editPlaylists
	case sortPlaylists
	
	var settingType: SettingType {
		return .playlistSetting
	}
	
	var description: String {
		switch self {
		case .editPlaylists:
			return "Edit Playlists"
		case .createNewPlaylist:
			return "Create a New Playlist..."
		case .sortPlaylists:
			return "Sort Playlists"
		}
	}
	
	var image: UIImage {
		switch self {
		case .editPlaylists:
			return UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium, scale: .default).configurationWithoutPointSizeAndWeight()) ?? UIImage()
		case .createNewPlaylist:
			return UIImage(systemName: "music.note.list", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium, scale: .default).configurationWithoutPointSizeAndWeight()) ?? UIImage()
		case .sortPlaylists:
			return UIImage(systemName: "arrow.up.arrow.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium, scale: .default).configurationWithoutPointSizeAndWeight()) ?? UIImage()
		}
	}
}


