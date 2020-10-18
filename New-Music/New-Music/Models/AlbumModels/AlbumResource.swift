//
//  AlbumResponse.swift
//  New-Music
//
//  Created by Michael McGrath on 10/16/20.
//

import Foundation

struct AlbumResource: Codable {
    let href: String?
    let next: String?
    let data: [AlbumData]
}
