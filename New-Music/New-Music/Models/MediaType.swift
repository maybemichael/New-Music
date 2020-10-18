//
//  MediaType.swift
//  New-Music
//
//  Created by Michael McGrath on 10/17/20.
//

import Foundation

enum MediaType: String {
    case songs
    case albums
    case artists
}

extension MediaType: Codable {
    enum TypeKeys: CodingKey {
        case songs, albums, artists
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TypeKeys.self)
        let key = container.allKeys.first
        switch key {
        case .songs:
            self = .songs
        case .albums:
            self = .albums
        case .artists:
            self = .artists
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unable to decode MediaType Enum"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TypeKeys.self)
        switch self {
        case .songs:
            try container.encode(rawValue, forKey: .songs)
        case .albums:
            try container.encode(rawValue, forKey: .albums)
        case .artists:
            try container.encode(rawValue, forKey: .artists)
        }
    }
    
}
