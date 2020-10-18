//
//  SongData.swift
//  New-Music
//
//  Created by Michael McGrath on 10/16/20.
//

import Foundation

struct SongData: Codable {
    let id: String
    let type: String
    let attributes: Song
}
