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
