//
//  Song.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit

struct Song: Codable, Hashable, Identifiable {
    let id: UUID = UUID()
    let songName: String
    let playID: String
    let kind: String
    let albumName: String
    let artistName: String
    var isAdded: Bool = false
    var accentColorHex: String
    var textColor: String
    var textColor2: String
    var textColor3: String
    var textColor4: String
    var albumArtwork: Data?
    var imageURL: URL
    var stringURL: String
    
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
        case textColor2
        case textColor3
        case textColor4
        case attributes
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
        self.stringURL = try artworkContainer.decode(String.self, forKey: .url)
        let stringURL = try artworkContainer.decode(String.self, forKey: .url).replacingOccurrences(of: "{w}", with: "1500").replacingOccurrences(of: "{h}", with: "1500")
        self.imageURL = URL(string: stringURL)!
        self.accentColorHex = try artworkContainer.decode(String.self, forKey: .bgColor)
        self.textColor = try artworkContainer.decode(String.self, forKey: .textColor1)
        self.textColor2 = try artworkContainer.decode(String.self, forKey: .textColor2)
        self.textColor3 = try artworkContainer.decode(String.self, forKey: .textColor3)
        self.textColor4 = try artworkContainer.decode(String.self, forKey: .textColor4)
    }
    
    init(songName: String, artistName: String, imageURL: URL) {
        self.songName = songName
        self.artistName = artistName
        self.imageURL = imageURL
        self.playID = ""
        self.kind = ""
        self.albumName = ""
        self.accentColorHex = ""
        self.stringURL = ""
        self.textColor = ""
        self.textColor2 = ""
        self.textColor3 = ""
        self.textColor4 = ""
    }
}

extension Song {
    var image: UIImage? {
        if let data = albumArtwork {
            return UIImage(data: data)
        } else {
            return UIImage()
        }
    }
}
