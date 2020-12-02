//
//  MusicController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import Foundation
import MediaPlayer

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case transportError(Error)
    case responseError(statusCode: Int)
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case genericError
}

class APIController {
    
    var authController: AuthController
    static let shared = APIController(auth: AuthController())
    let baseURL = URL(string: "https://api.music.apple.com")!
//    let baseURL = URL(string: "https://api.music.apple.com/v1/catalog")!
    let cache = URLCache(memoryCapacity: 1024 * 1024 * 250, diskCapacity: 1024 * 1024 * 100, diskPath: "ImageCache")
    
    var searchedSongs = [Song]()
    var searchedAlbums = [Album]()
    var songsNext: String? = nil {
        didSet {

        }
    }
    var albumsNext: String? = nil {
        didSet {

        }
    }
    
    private func makeSearchRequest(for searchTerm: String) -> URLRequest? {
        let term = searchTerm.replacingOccurrences(of: " ", with: "+")
        print("The search term: \(searchTerm)")
        let storeURL = baseURL.appendingPathComponent("v1/catalog/us/search")
//        let storeURL = baseURL.appendingPathComponent("us").appendingPathComponent("search")
        var urlComponents = URLComponents(url: storeURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "limit", value: "25"),
            URLQueryItem(name: "types", value: "songs,artists,albums")
        ]
        guard let requestURL = urlComponents?.url else { return nil }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        request.setValue(authController.userToken, forHTTPHeaderField: "Music-User-Token")

        return request
    }
    
    private func makeNextRequest(for mediaType: MediaType) -> URLRequest? {
        var nextURL: URL
        if mediaType == .song, let url = songsNext {
            nextURL = URL(string: baseURL.absoluteString + url)!
        } else if mediaType == .album, let url = albumsNext {
            nextURL = baseURL.appendingPathComponent(url)
        } else {
            return nil
        }
        var request = URLRequest(url: nextURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        request.setValue(authController.userToken, forHTTPHeaderField: "Music-User-Token")

        return request
    }
    
    func searchForMedia(with searchTerm: String, completion: @escaping (Result<(songs:[Song], albums: [Album]), NetworkError>) -> Void) {
        guard let request = makeSearchRequest(for: searchTerm) else {
            completion(.failure(.genericError))
            return
        }
        print("Request: \(request)")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let networkError = NetworkError(data: data, response: response, error: error) {
                completion(.failure(networkError))
                return
            }
            do {
                let searchResults = try JSONDecoder().decode(SearchResult.self, from: data!).results
                var searchedSongs = [Song]()
                var searchedAlbums = [Album]()
                if let songsResults = searchResults.songs?.data {
                    searchedSongs = songsResults.map { $0.attributes }
                }
                if let albumResults = searchResults.albums?.data {
                    searchedAlbums = albumResults.map { $0.attributes }
                }
                self.songsNext = searchResults.songs?.next
                self.albumsNext = searchResults.albums?.next
                print("Searched Albums Count: \(self.searchedAlbums.count)")
                completion(.success((songs: searchedSongs, albums: searchedAlbums)))
            } catch {
                print("Error decoding json data \(error)")
                completion(.failure(.decodingError(error)))
                return
            }
        }.resume()
    }
    
    func fetchImage(mediaItem: MediaItem, size: CGFloat, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        let stringURL = mediaItem.stringURL.replacingOccurrences(of: "{w}", with: String(Int(size))).replacingOccurrences(of: "{h}", with: String(Int(size)))
        let url = URL(string: stringURL)!
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfig.urlCache = self.cache
        let urlRequest = URLRequest(url: url)
        if let cachedData = self.cache.cachedResponse(for: urlRequest) {
            completion(.success(cachedData.data))
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let networkError = NetworkError(data: data, response: nil, error: error) {
                    print("Some error: \(networkError)")
                    completion(.failure(networkError))
                    return
                }
                if let data = data, let response = response {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    self.cache.storeCachedResponse(cachedData, for: urlRequest)
                    completion(.success(data))
                }
            }.resume()
        }
    }
    
    func loadNextMedia(mediaType: MediaType, completion: @escaping (Result<[Media], NetworkError>) -> Void) {
        guard let request = makeNextRequest(for: mediaType) else {
            completion(.failure(.genericError))
            return
        }
        print("Request URL: \(request)")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let networkError = NetworkError(data: data, response: response, error: error) {
                completion(.failure(networkError))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("This is the json: \(json)")
                let searchResults = try JSONDecoder().decode(SearchResult.self, from: data!).results
                if mediaType == .song {
                    if let songsResults = searchResults.songs?.data {
                        let nextSongs = songsResults.map { $0.attributes }
                        var songMedia = [Media]()
                        nextSongs.forEach {
                            let media = Media(stringURL: $0.stringURL, mediaType: .song, media: $0)
                            songMedia.append(media)
                        }
                        completion(.success(songMedia))
                    }
                } else if mediaType == .album {
                    if let albumResults = searchResults.albums?.data {
                        let nextAlbums = albumResults.map { $0.attributes }
                        var albumMedia = [Media]()
                        nextAlbums.forEach {
                            let media = Media(stringURL: $0.stringURL, mediaType: .album, media: $0)
                            albumMedia.append(media)
                        }
                        completion(.success(albumMedia))
                    }
                }
            } catch {
                print("Error decoding json data \(error)")
                completion(.failure(.decodingError(error)))
                return
            }
        }.resume()
    }
        
    private init(auth: AuthController) {
        self.authController = auth
        self.authController.requestAppleMusicAccess()
        self.authController.getUsersStoreFrontID { _ in
            
        }
    }
}
