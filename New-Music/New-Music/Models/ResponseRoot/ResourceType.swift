//
//  ResponseTypes.swift
//  New-Music
//
//  Created by Michael McGrath on 10/16/20.
//

import Foundation

struct ResourceType: Codable {
    let songs: SongResource
    let albums: AlbumResource
}
