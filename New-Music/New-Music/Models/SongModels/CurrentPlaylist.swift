//
//  CurrentPlaylistSong.swift
//  New-Music
//
//  Created by Michael McGrath on 10/23/20.
//

import UIKit

class CurrentPlaylist: ObservableObject {
    @Published var songs = [Song]()
    
    init(songs: [Song]) {
        self.songs = songs
    }
}
