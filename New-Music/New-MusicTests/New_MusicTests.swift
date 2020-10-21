//
//  New_MusicTests.swift
//  New-MusicTests
//
//  Created by Michael McGrath on 10/3/20.
//

import XCTest
@testable import New_Music

class New_MusicTests: XCTestCase {

    let json = """
    {
      "results": {
        "songs": {
          "href": "/v1/catalog/us/search?limit=5&term=drake%3D25&types=songs",
          "next": "/v1/catalog/us/search?offset=5&term=drake%3D25&types=songs",
          "data": [
            {
              "id": "1418213269",
              "type": "songs",
              "href": "/v1/catalog/us/songs/1418213269",
              "attributes": {
                "previews": [
                  {
                    "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview128/v4/66/94/d3/6694d3c9-83fd-9d5b-ffcb-faf7f7d43219/mzaf_8250980818169607248.plus.aac.p.m4a"
                  }
                ],
                "artwork": {
                  "width": 3000,
                  "height": 3000,
                  "url": "https://is4-ssl.mzstatic.com/image/thumb/Music128/v4/d5/7d/47/d57d4729-3acf-e6d6-1c75-2074e9cb27ec/00602567892410.rgb.jpg/{w}x{h}bb.jpeg",
                  "bgColor": "2c2c2c",
                  "textColor1": "ebebeb",
                  "textColor2": "cccccc",
                  "textColor3": "c5c5c5",
                  "textColor4": "acacac"
                },
                "artistName": "Drake",
                "url": "https://music.apple.com/us/album/gods-plan/1418213110?i=1418213269",
                "discNumber": 1,
                "genreNames": [
                  "Hip-Hop/Rap",
                  "Music"
                ],
                "durationInMillis": 198973,
                "releaseDate": "2018-01-19",
                "name": "God's Plan",
                "isrc": "USCM51800004",
                "hasLyrics": true,
                "albumName": "Scorpion",
                "playParams": {
                  "id": "1418213269",
                  "kind": "song"
                },
                "trackNumber": 5,
                "composerName": "Matthew Samuels, Aubrey Graham, N. Shebib, Ron Latour, Daveon Jackson & Brock Korsan",
                "contentRating": "explicit"
              }
            }
          ]
        }
      }
    }
    """.data(using: .utf8)
    
    override func setUp() {
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeSongs() throws {
        
//        let searchResults = try! JSONDecoder().decode(SearchResult.self, from: json!).results.songs.data
//        var songs = [Song]()
//
//        searchResults.forEach {
//            let song = $0.attributes
//            songs.append(song)
//        }
//        XCTAssertTrue(songs.count > 0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
