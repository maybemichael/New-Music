//
//  Album.swift
//  New-Music
//
//  Created by Michael McGrath on 10/18/20.
//

import Foundation

struct Album: Codable {
    let imageURL: String
    let imageWidth: Int
    let imageHeight: Int
    let accentColorHex: String
    let artistName: String
    let isSingle: Bool
    let genres: [String]
    let trackCount: Int
    let releaseDate: String
    let albumName: String
    let recordLabel: String
    let copyright: String
    let playID: String
    let kind: String
    let isCompilation: Bool
    let contentRating: String?
    
    enum AlbumKeys: CodingKey {
        case artwork
        case playParams
        case width
        case height
        case url
        case bgColor
        case artistName
        case isSingle
        case genreNames
        case trackCount
        case releaseDate
        case name
        case recordLabel
        case copyright
        case isCompilation
        case contentRating
        case id
        case kind
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumKeys.self)
        let artworkContainer = try container.nestedContainer(keyedBy: AlbumKeys.self, forKey: .artwork)
        let playParamsContainer = try container.nestedContainer(keyedBy: AlbumKeys.self, forKey: .playParams)
        var genres = [String]()
        var genreContainer = try container.nestedUnkeyedContainer(forKey: .genreNames)
        while !genreContainer.isAtEnd {
            let genre = try genreContainer.decode(String.self)
            genres.append(genre)
        }
        self.genres = genres
        self.playID = try playParamsContainer.decode(String.self, forKey: .id)
        self.kind = try playParamsContainer.decode(String.self, forKey: .kind)
        self.imageURL = try artworkContainer.decode(String.self, forKey: .url)
        self.imageWidth = try artworkContainer.decode(Int.self, forKey: .width)
        self.imageHeight = try artworkContainer.decode(Int.self, forKey: .height)
        self.accentColorHex = try artworkContainer.decode(String.self, forKey: .bgColor)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.isSingle = try container.decode(Bool.self, forKey: .isSingle)
        self.trackCount = try container.decode(Int.self, forKey: .trackCount)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.albumName = try container.decode(String.self, forKey: .name)
        self.recordLabel = try container.decode(String.self, forKey: .recordLabel)
        self.copyright = try container.decode(String.self, forKey: .copyright)
        self.isCompilation = try container.decode(Bool.self, forKey: .isCompilation)
        self.contentRating = try container.decodeIfPresent(String.self, forKey: .contentRating)
    }
}
