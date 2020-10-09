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
    var isPlaying = false 
    
    func searchForSongWith(_ searchTerm: String, completion: @escaping (Result<[Song], NetworkError>) -> Void) {
        let term = searchTerm.replacingOccurrences(of: " ", with: "+")
        let storeURL = baseURL.appendingPathComponent("us").appendingPathComponent("search")
        var urlComponents = URLComponents(url: storeURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "limit", value: "25"),
            URLQueryItem(name: "types", value: "songs")
//            URLQueryItem(name: "types", value: "songs,artists,albums")
        ]
        guard let requestURL = urlComponents?.url else {
            completion(.failure(.genericError))
            return
        }
        print("Request URL: \(requestURL)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(authController.developerToken)", forHTTPHeaderField: "Authorization")
        request.setValue(authController.userToken, forHTTPHeaderField: "Music-User-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let networkError = NetworkError(data: data, response: response, error: error) {
                completion(.failure(networkError))
                return
            }
            
            do {
                let jsonResults = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                if let results = Results(dictionary: jsonResults)?.songs {
                    
                    let songData = try JSONSerialization.data(withJSONObject: results, options: [])
                    let songs = try JSONDecoder().decode([Song].self, from: songData)
                    self.searchedSongs = songs
                    print("Songs count: \(self.searchedSongs.count)")
                    completion(.success(songs))
                }
            } catch {
                print("Error pasing json data \(error)")
                completion(.failure(.decodingError(error)))
                return
            }
        }.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfig.urlCache = self.cache
        let urlRequest = URLRequest(url: url)
        if let cachedData = self.cache.cachedResponse(for: urlRequest) {
            print("Cached data in bytes: \(cachedData.data)")
            let image = UIImage(data: cachedData.data)
            completion(.success(image))
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
                    let image = UIImage(data: data)
                    completion(.success(image))
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