//
//  PersistedPlaylist+Convenience.swift
//  New-Music
//
//  Created by Michael McGrath on 11/24/20.
//

import Foundation
import CoreData

extension PersistedPlaylist {
    
    var playlist: Playlist? {
        
        guard
            let playlistName = self.playlistName
        else { return nil }
        
        var songs = [Song]()
        if let playlistSongs = playlistSongs {
            playlistSongs.forEach {
                if let playlistSong = $0 as? PlaylistSong, let song = playlistSong.song {
                    songs.append(song)
                }
            }
        }
        return Playlist(playlistName: playlistName, songs: songs)
    }
    
    @discardableResult convenience init?(identifier: String,
                                         playlistName: String,
                                         songs: NSOrderedSet?,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.playlistName = playlistName
        self.playlistSongs = songs
    }
    
    @discardableResult convenience init?(playlist: Playlist, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        var playlistSongs = [PlaylistSong]()
        
        if playlist.songs.count > 0 {
            playlist.songs.forEach {
                if let song = PlaylistSong(song: $0, context: context) {
                    playlistSongs.append(song)
                }
            }
        }
        
        var playlistSongSet: NSOrderedSet?
        
        if playlistSongs.count > 0 {
            playlistSongSet = NSOrderedSet(array: playlistSongs)
        }
        
        self.init(identifier: playlist.id,
                  playlistName: playlist.playlistName,
                  songs: playlistSongSet,
                  context: context)
    }
}
