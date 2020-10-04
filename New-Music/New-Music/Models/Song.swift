//
//  Song.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import Foundation

struct Song: Codable {
    let songName: String
    let playID: String
    let kind: String
    let albumName: String
    let artistName: String
    let imageURL: URL
    
    enum SongKeys: String, CodingKey {
        case name
        case playParams
        case id
        case kind
        case albumName
        case artistName
        case artwork
        case url
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
        let stringURL = try artworkContainer.decode(String.self, forKey: .url).replacingOccurrences(of: "{w}", with: "300").replacingOccurrences(of: "{h}", with: "300")
        self.imageURL = URL(string: stringURL)!
    }
}
