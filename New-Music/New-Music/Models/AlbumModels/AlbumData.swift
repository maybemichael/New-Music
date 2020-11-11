//
//  AlbumData.swift
//  New-Music
//
//  Created by Michael McGrath on 10/18/20.
//

import Foundation

struct AlbumData: Decodable {
    let id: String
    let type: String
    let attributes: Album
}
