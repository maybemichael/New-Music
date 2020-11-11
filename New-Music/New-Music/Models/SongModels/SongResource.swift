//
//  SongResponse.swift
//  New-Music
//
//  Created by Michael McGrath on 10/16/20.
//

import Foundation

struct SongResource: Decodable {
    let href: String?
    let next: String?
    let data: [SongData]
}
