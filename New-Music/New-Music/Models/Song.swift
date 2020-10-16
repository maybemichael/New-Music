//
//  Song.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import Foundation
import UIKit

struct Song: Codable, Hashable, SearchResults {
    
    var searchType: String = SearchType.song.rawValue
    
    let songName: String
    let playID: String
    let kind: String
    let albumName: String
    let artistName: String
    let imageURL: URL
    var isAdded: Bool = false
    var albumArtwork: Data?
    var accentColorHex: String
    var textColor: String
    
    enum SongKeys: String, CodingKey {
        case name
        case playParams
        case id
        case kind
        case albumName
        case artistName
        case artwork
        case url
        case bgColor
        case textColor1
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SongKeys.self)
        let playParamsContainer = try container.nestedContainer(keyedBy: SongKeys.self, forKey: .playParams)
        let artworkContainer = try container.nestedContainer(keyedBy: SongKeys.self, forKey: .artwork)
        
        self.songName = try container.decode(String.self, forKey: .name)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.albumName = try container.decode(String.self, forKey: .albumName)
        self.playID = try playParamsContainer.decode(String.self, forKey: .id)
        self.kind = try playParamsContainer.decode(String.self, forKey: .kind)
        let stringURL = try artworkContainer.decode(String.self, forKey: .url).replacingOccurrences(of: "{w}", with: "1500").replacingOccurrences(of: "{h}", with: "1500")
        self.imageURL = URL(string: stringURL)!
        self.accentColorHex = try artworkContainer.decode(String.self, forKey: .bgColor)
        self.textColor = try artworkContainer.decode(String.self, forKey: .textColor1)
    }
    
    init(songName: String, artistName: String, imageURL: URL) {
        self.songName = songName
        self.artistName = artistName
        self.imageURL = imageURL
        self.playID = ""
        self.kind = ""
        self.albumName = ""
        self.accentColorHex = ""
        self.textColor = ""
    }
}
