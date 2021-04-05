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
		songs.removeAll()
		updatedSongs.forEach {
			addNewSong(song: $0)
		}
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

	func updateAlbumArtwork(completion: @escaping () -> Void) {
		guard !songs.isEmpty else { return }
		for index in (0..<songs.count) {
			guard songs[index].albumArtwork == nil else { continue }
			APIController.shared.fetchImage(mediaItem: songs[index], size: 500) { result in
				switch result {
				case .success(let imageData):
					self.songs[index].albumArtwork = imageData
				case .failure(let error):
					print("Error fetching songs for searchTerm: \(error.localizedDescription)")
				}
			}
		}
	}

	func updateAlbumArtwork(for playlist: Playlist) {
		var updatedSongs = [Song]()
		songs.forEach {
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
			updatedSongs.append(song)
		}
		self.replacePlaylistSongs(with: updatedSongs)
	}

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
