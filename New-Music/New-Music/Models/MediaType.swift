//
//  MediaType.swift
//  New-Music
//
//  Created by Michael McGrath on 10/17/20.
//

import Foundation



//extension MediaType: Codable {
//    enum TypeKeys: CodingKey {
//        case songs, albums, artists
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: TypeKeys.self)
//        let key = container.allKeys.first
//        switch key {
//        case .songs:
//            self = .song
//        case .albums:
//            self = .album
//        case .artists:
//            self = .artist
//        default:
//            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unable to decode MediaType Enum"))
//        }
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: TypeKeys.self)
//        switch self {
//        case .song:
//            try container.encode(rawValue, forKey: .songs)
//        case .album:
//            try container.encode(rawValue, forKey: .albums)
//        case .artist:
//            try container.encode(rawValue, forKey: .artists)
//        }
//    }
//
//}
