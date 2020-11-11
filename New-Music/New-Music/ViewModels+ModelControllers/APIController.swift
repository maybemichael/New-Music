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
    let baseURL = URL(string: "https://api.music.apple.com/v1/catalog")!
    let cache = URLCache(memoryCapacity: 1373714 * 100, diskCapacity: 1373714 * 100, diskPath: "ImageCache")
    
    var searchedSongs = [Song]()
    var searchedAlbums = [Album]()
    var isPlaying = false 
    
    private func makeSearchRequest(for searchTerm: String) -> URLRequest? {
        let term = searchTerm.replacingOccurrences(of: " ", with: "+")
        print("The search term: \(searchTerm)")
        let storeURL = baseURL.appendingPathComponent("us").appendingPathComponent("search")
        var urlComponents = URLComponents(url: storeURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "limit", value: "25"),
            URLQueryItem(name: "types", value: "songs,artists,albums")
        ]
        guard let requestURL = urlComponents?.url else { return nil }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(authController.developerToken)", forHTTPHeaderField: "Authorization")
        request.setValue(authController.userToken, forHTTPHeaderField: "Music-User-Token")

        return request
    }
    
    func searchForMedia(with searchTerm: String, completion: @escaping (Result<(songs:[Song], albums: [Album]), NetworkError>) -> Void) {
        guard let request = makeSearchRequest(for: searchTerm) else {
            completion(.failure(.genericError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let networkError = NetworkError(data: data, response: response, error: error) {
                completion(.failure(networkError))
                return
            }
            do {
                let searchResults = try JSONDecoder().decode(SearchResult.self, from: data!).results
                let songsResults = searchResults.songs.data
                let albumResults = searchResults.albums.data
                self.searchedSongs = songsResults.map { $0.attributes }
                self.searchedAlbums = albumResults.map { $0.attributes }
                print("Searched Albums Count: \(self.searchedAlbums.count)")
                completion(.success((songs: self.searchedSongs, albums: self.searchedAlbums)))
            } catch {
                print("Error decoding json data \(error)")
                completion(.failure(.decodingError(error)))
                return
            }
        }.resume()
    }
    
    func fetchImage(mediaItem: MediaItem, size: CGFloat, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        let stringURL = mediaItem.stringURL.replacingOccurrences(of: "{w}", with: String(Int(size))).replacingOccurrences(of: "{h}", with: String(Int(size)))
//        print("String URL: \(stringURL)")
        let url = URL(string: stringURL)!
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfig.urlCache = self.cache
        let urlRequest = URLRequest(url: url)
        if let cachedData = self.cache.cachedResponse(for: urlRequest) {
//            let image = UIImage(data: cachedData.data)
            completion(.success(cachedData.data))
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let networkError = NetworkError(data: data, response: nil, error: error) {
                    print("Some error: \(networkError)")
                    completion(.failure(networkError))
                    return
                }
                if let data = data, let response = response as? HTTPURLResponse {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    self.cache.storeCachedResponse(cachedData, for: urlRequest)
//                    let image = UIImage(data: data)
                    completion(.success(data))
                }
            }.resume()
        }
    }
        
    private init(auth: AuthController) {
        self.authController = auth
        self.authController.requestAppleMusicAccess()
        self.authController.getUsersStoreFrontID { _ in
            
        }
    }
}
