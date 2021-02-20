//
//  Song.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit

struct Song: Codable, Hashable, Identifiable, MediaItem {
    var mediaType: MediaType = .song
    let id: String = UUID().uuidString
    let songName: String
    let playID: String
    let kind: String
    let albumName: String
    let artistName: String
    var isAdded: Bool = false
    var accentColorHex: String
    var textColor1: String
    var textColor2: String
    var textColor3: String
    var textColor4: String
    var albumArtwork: Data?
    var imageURL: URL?
    var stringURL: String 
    var isPlaying = false
    var duration: Double
    
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
        case durationInMillis
        case songName
        case playID
        case stringURL
        case accentColorHex
        case duration
        
    }
    
    init(from decoder: Decoder) throws {
        let dataType = decoder.userInfo[.dataType] as? String
        let container = try decoder.container(keyedBy: SongKeys.self)
        
        switch dataType {
        case .some("plist"):
            self.songName = try container.decode(String.self, forKey: .songName)
            self.artistName = try container.decode(String.self, forKey: .artistName)
            self.albumName = try container.decode(String.self, forKey: .albumName)
            self.playID = try container.decode(String.self, forKey: .playID)
            self.kind = try container.decode(String.self, forKey: .kind)
            self.stringURL = try container.decode(String.self, forKey: .stringURL)
            self.accentColorHex = try container.decode(String.self, forKey: .accentColorHex)
            self.textColor1 = try container.decode(String.self, forKey: .textColor1)
            self.textColor2 = try container.decode(String.self, forKey: .textColor2)
            self.textColor3 = try container.decode(String.self, forKey: .textColor3)
            self.textColor4 = try container.decode(String.self, forKey: .textColor4)
            self.duration = try container.decode(Double.self, forKey: .duration)
        default:
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
            self.textColor1 = try artworkContainer.decode(String.self, forKey: .textColor1)
            self.textColor2 = try artworkContainer.decode(String.self, forKey: .textColor2)
            self.textColor3 = try artworkContainer.decode(String.self, forKey: .textColor3)
            self.textColor4 = try artworkContainer.decode(String.self, forKey: .textColor4)
            let durationInMillis = try container.decode(Int.self, forKey: .durationInMillis)
            self.duration = Double(Double(durationInMillis) / Double(1000)) / Double(60)
        }
        
    }
    
    init(songName: String, artistName: String, imageURL: URL? = nil, playID: String = "", kind: String = "", albumName: String = "", accentColorHex: String = "", stringURL: String = "", textColorHex: String = "", textColor2Hex: String = "", textColor3Hex: String = "", textColor4Hex: String = "", duration: Double = 0) {
        self.songName = songName
        self.artistName = artistName
        self.imageURL = imageURL
        self.playID = playID
        self.kind = kind
        self.albumName = albumName
        self.accentColorHex = accentColorHex
        self.stringURL = stringURL
        self.textColor1 = textColorHex
        self.textColor2 = textColor2Hex
        self.textColor3 = textColor3Hex
        self.textColor4 = textColor4Hex
        self.duration = duration
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
