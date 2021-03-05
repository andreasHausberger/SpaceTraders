//
//  Network.swift
//  SpaceTraders (iOS)
//
//  Created by Andreas Hausberger on 05.03.21.
//

import Foundation
import Combine

class Network<T: Codable> {
    
    public static func get(urlString: String, params: [String:String]? = nil) throws -> AnyPublisher<T, APIError> {
        guard var urlComponents = URLComponents(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let config = getConfig()
        let session = URLSession(configuration: config)
        
        
        if let params = params {
            urlComponents.queryItems = [URLQueryItem]()
            params.forEach { (key, value) in
                let item = URLQueryItem(name: key, value: value)
                urlComponents.queryItems?.append(item)
            }
        }
        guard let url = urlComponents.url else { throw APIError.invalidURL }
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
    
    public static func post(urlString: String) throws -> AnyPublisher<T, APIError> {
        guard let url = URL (string: urlString) else {
            throw APIError.invalidURL
        }
        
        let config = getConfig()
        let session = URLSession(configuration: config)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
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
    
    private static func getConfig() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        return config
    }
}
