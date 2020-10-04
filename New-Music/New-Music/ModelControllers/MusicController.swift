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

class MusicController {
    
    var authController: AuthController
    static let shared = MusicController(auth: AuthController())
    let baseURL = URL(string: "https://api.music.apple.com/v1/catalog")!
    static let player = MPMusicPlayerController.applicationMusicPlayer
    var songs = [Song]()
    
    func searchForSongWith(_ searchTerm: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
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
                    self.songs = songs
                    print("Songs count: \(self.songs.count)")
                    completion(.success(true))
                }
            } catch {
                print("Error pasing json data \(error)")
                completion(.failure(.decodingError(error)))
                return
            }
        }.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let networkError = NetworkError(data: data, response: nil, error: error) {
                print("Some error: \(networkError)")
                completion(.failure(networkError))
                return
            }
            
            let image = UIImage(data: data!)
            completion(.success(image))
        }.resume()
    }
    
    
    private init(auth: AuthController) {
        self.authController = auth
        self.authController.requestAppleMusicAccess()
        self.authController.getUsersStoreFrontID { _ in
            
        }
    }
}
