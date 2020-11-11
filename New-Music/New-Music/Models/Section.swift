//
//  Section.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import Foundation

protocol SearchResults {
    var searchType: String { get set }
}

enum SearchType: String {
    case song = "Songs"
    case album = "Albums"
    case artist = "Artists"
}

enum MediaKind: Hashable {
    case song(song: Song)
    case album(album: Album)
}

struct Media: Hashable, MediaItem {
    var stringURL: String
    var mediaType: MediaType
    var id = UUID().uuidString
    var media: MediaItem
    
    static func == (lhs: Media, rhs: Media) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Section: Hashable {
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
    
    var mediaType: MediaType
    let id: String
    var media: [Media]
    
    init(mediaType: MediaType, id: String = UUID().uuidString, media: [Media]) {
        self.mediaType = mediaType
        self.id = id
        self.media = media
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
