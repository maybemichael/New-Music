//
//  PlaylistSong+Convenience.swift
//  New-Music
//
//  Created by Michael McGrath on 11/24/20.
//

import Foundation
import CoreData

extension PlaylistSong {
    var song: Song? {
        
        guard
            let songTitle = self.songTitle,
            let stringURL = self.stringURL,
            let artist = self.artist,
            let playID = self.playID,
            let kind = self.kind,
            let albumTitle = self.albumTitle,
            let accentColorHex = self.accentColorHex,
            let textColorHex = self.textColorHex,
            let textColor2Hex = self.textColor2Hex,
            let textColor3Hex = self.textColor3Hex,
            let textColor4Hex = self.textColor4Hex
        else { return nil }
        
        return Song(songName: songTitle, artistName: artist, imageURL: nil, playID: playID, kind: kind, albumName: albumTitle, accentColorHex: accentColorHex, stringURL: stringURL, textColorHex: textColorHex, textColor2Hex: textColor2Hex, textColor3Hex: textColor3Hex, textColor4Hex: textColor4Hex)
    }
    
    @discardableResult convenience init?(identifier: String,
                                         songTitle: String,
                                         albumTitle: String,
                                         artist: String,
                                         kind: String,
                                         playID: String,
                                         stringURL: String,
                                         accentColorHex: String,
                                         textColorHex: String,
                                         textColor2Hex: String,
                                         textColor3Hex: String,
                                         textColor4Hex: String,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.songTitle = songTitle
        self.albumTitle = albumTitle
        self.artist = artist
        self.kind = kind
        self.playID = playID
        self.stringURL = stringURL
        self.accentColorHex = accentColorHex
        self.textColorHex = textColorHex
        self.textColor2Hex = textColor2Hex
        self.textColor3Hex = textColor3Hex
        self.textColor4Hex = textColor4Hex
    }
    
    @discardableResult convenience init?(song: Song, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(identifier: song.id,
                  songTitle: song.songName,
                  albumTitle: song.albumName,
                  artist: song.artistName,
                  kind: song.kind,
                  playID: song.playID,
                  stringURL: song.stringURL,
                  accentColorHex: song.accentColorHex,
                  textColorHex: song.textColor1,
                  textColor2Hex: song.textColor2,
                  textColor3Hex: song.textColor3,
                  textColor4Hex: song.textColor4,
                  context: context)
    }
}
