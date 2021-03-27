//
//  Playlist.swift
//  New-Music
//
//  Created by Michael McGrath on 11/24/20.
//

import Foundation

class Playlist: Hashable, Codable {
    
    var id: String = UUID().uuidString
    var playlistName: String
	var songs: [Song]
	
	var songIDs: [String] {
		return songs.map { $0.id }
	}
	
	var songIDSet: Set<String> {
		return Set(songIDs)
	}
	
    var songCount: Int {
        return self.songs.count
    }
    
    var totalDuration: Double {
        return songs.map { $0.duration }.reduce(0, +)
    }
    
    init(playlistName: String, songs: [Song] = []) {
        self.playlistName = playlistName
        self.songs = songs
    }
    
    static func == (lhs: Playlist, rhs: Playlist) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
