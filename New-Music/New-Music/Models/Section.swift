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

struct Section: Hashable, SearchResults {
    let id: String = UUID().uuidString
    var searchType: String
}
