//
//  NetworkError+Init.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import Foundation

extension NetworkError {
    init?(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            self = .transportError(error)
            return
        }
        
        if let response = response as? HTTPURLResponse, !(200...299 ~= response.statusCode) {
            self = .responseError(statusCode: response.statusCode)
        }
        
        if data == nil {
            self = .noData
        }
        
        return nil
    }
}
