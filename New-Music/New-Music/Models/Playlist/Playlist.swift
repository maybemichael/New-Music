//
//  Playlist.swift
//  New-Music
//
//  Created by Michael McGrath on 11/24/20.
//

import UIKit

class Playlist: Hashable, Codable, MediaItem {

	private(set) var id: String = UUID().uuidString

	var mediaType: MediaType = .playlist

	var stringURL: String = ""

	var playlistName: String

	private(set) var songs: [Song] {
		didSet {
			totalSongDuration = songs.map { $0.duration }.reduce(0, +)
		}
	}

	var songsAddedFromSearch: [Song] = []

	var songsAddedPlaylistMedia: [PlaylistMedia] {
		return songsAddedFromSearch.map { PlaylistMedia.song($0) }
	}

	var songIDs: [String] {
		return songs.map { $0.id }
	}
	
	var songIDSet: Set<String> {
		return Set(songIDs)
	}

	var songSet: Set<Song> {
		return Set(songs)
	}

	var playlistMedia: [PlaylistMedia] {
		return songs.map { PlaylistMedia.song($0) }
	}
	
	var songCount: Int {
		return self.songs.count
	}

	var totalSongDuration: Double?
	
	var totalDuration: Double {
		get {
			return songs.map { $0.duration }.reduce(0, +)
		}
		set {
			totalSongDuration = newValue
		}
	}

	func replacePlaylistSongs(with updatedSongs: [Song]) {
		songs = updatedSongs
	}

	func updatePlaylistSongsAfterEditing(updatedSongs: [PlaylistMedia]) {
		let difference = updatedSongs.difference(from: self.playlistMedia)
		guard let updatedPlaylistMedia = self.playlistMedia.applying(difference) else { return }
		var updatedPlaylistSongs: [Song] = []
		updatedPlaylistMedia.forEach {
			if case PlaylistMedia.song(let song) = $0 {
				updatedPlaylistSongs.append(song)
				print("\nSong Name: \(song.songName)\n")
			}
		}
		self.songs = updatedPlaylistSongs

	}

	func addNewSong(song: Song) {
		var songToAdd: Song
		if songSet.contains(song) {
			songToAdd = Song(copiedFrom: song)
		} else {
			songToAdd = song
		}
		songs.append(songToAdd)
	}

	func removeSong(song: Song) {
		guard let indexToRemove = songs.firstIndex(of: song) else { return }
		songs.remove(at: indexToRemove)
	}

	func shufflePlaylistSongs() {
		songs.shuffle()
	}

//	@objc
//	private func updatePlaylistDuration() {
//		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(updatePlaylistDuration), object: nil)
//		perform(#selector(updatePlaylistDuration), with: nil, afterDelay: 0.5)
//	}

	init(playlistName: String, songs: [Song] = []) {
		self.playlistName = playlistName
		self.songs = songs
	}

	static func == (lhs: Playlist, rhs: Playlist) -> Bool {
		lhs.id == rhs.id && lhs.songs == rhs.songs
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(songs)
		hasher.combine(totalDuration)
	}
}
