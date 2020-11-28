//
//  Playlist.swift
//  New-Music
//
//  Created by Michael McGrath on 11/24/20.
//

import Foundation

struct Playlist: Hashable {
    var id: String = UUID().uuidString
    var playlistName: String
    var songs: [Song]
}
