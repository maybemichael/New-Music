//
//  Results.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import Foundation

struct Results {
    var songs: [Dictionary<String, Any>]
    
    enum ResultKeys: String, CodingKey {
        case results
        case songs
        case data
        case attributes
    }
    
    init?(dictionary: Dictionary<String, Any>) {
        guard
            let resultsDictionary = dictionary[ResultKeys.results.rawValue] as? [String: Any],
            let songsDictionary = resultsDictionary[ResultKeys.songs.rawValue] as? [String: Any],
            let dataArray = songsDictionary[ResultKeys.data.rawValue] as? [[String: Any]]
        else { return nil }
        
        var songsArray = [Dictionary<String, Any>]()
        dataArray.forEach { songsArray.append($0[ResultKeys.attributes.rawValue]! as! Dictionary<String, Any>) }
        self.songs = songsArray
    }
}

