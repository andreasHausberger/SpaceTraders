//
//  Network.swift
//  SpaceTraders (iOS)
//
//  Created by Andreas Hausberger on 05.03.21.
//

import Foundation
import Combine

class Network<T: Codable> {
    
    public static func get(urlString: String) throws -> AnyPublisher<T, APIError> {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession(configuration: config)
        
        let request = URLRequest(url: url)
        
        return session.dataTaskPublisher(for: request)
            .tryMap { response in
                guard let httpURLResponse = response.response as? HTTPURLResponse,
                      httpURLResponse.statusCode == 200 else {
                    throw APIError.statusCode
                }
                return response.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { APIError.map($0) }
            .eraseToAnyPublisher()
    }
}
