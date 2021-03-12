//
//  Network.swift
//  SpaceTraders (iOS)
//
//  Created by Andreas Hausberger on 05.03.21.
//

import Foundation
import Combine

public enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class Network<T: Codable> {
    /**
     Performs a HTTP GET Call.
     
     - parameter urlString: String of the URL
     - parameter urlParameter: Dictionary of URL parameters.
     - parameter httpHeaders: Dictionary of HTTP headers.
     - parameter body: Dictionary of HTTP Body. Must be JSON encodable!
     - returns: AnyPublisher: Publisher for the generic Codable object.
     - throws: APIError.invalidURL: Will be thrown if the supplied URL and/or parameters are not valid
     - throws: APIError.decoding: Will be thrown if the supplied Body dictionary is not valid or encodable.
     */
    public static func get(urlString: String, urlParameter params: [String:String]? = nil, httpHeaders headers: [String: String]? = nil, body: [String: Any]? = nil) throws -> AnyPublisher<T, APIError> {
        
        do {
            return try performNetworkCall(urlString: urlString, method: .get, urlParameter: params, httpHeaders: headers, body: body)
        }
        catch let error {
            throw error
        }
    }
    
    /**
     Performs a HTTP POST Call.
     
     - parameter urlString: String of the URL
     - parameter urlParameter: Dictionary of URL parameters.
     - parameter httpHeaders: Dictionary of HTTP headers.
     - parameter body: Dictionary of HTTP Body. Must be JSON encodable!
     - returns: AnyPublisher: Publisher for the generic Codable object.
     - throws: APIError.invalidURL: Will be thrown if the supplied URL and/or parameters are not valid
     - throws: APIError.decoding: Will be thrown if the supplied Body dictionary is not valid or encodable.
     */
    public static func post(urlString: String, urlParameter params: [String:String]? = nil, httpHeaders headers: [String: String]? = nil, body: [String: Any]? = nil) throws -> AnyPublisher<T, APIError> {
        do {
            return try performNetworkCall(urlString: urlString, method: .post, urlParameter: params, httpHeaders: headers, body: body)
        }
        catch let error {
            throw error
        }
    }
    
    /**
     Performs a HTTP PUT Call.
     
     - parameter urlString: String of the URL
     - parameter urlParameter: Dictionary of URL parameters.
     - parameter httpHeaders: Dictionary of HTTP headers.
     - parameter body: Dictionary of HTTP Body. Must be JSON encodable!
     - returns: AnyPublisher: Publisher for the generic Codable object.
     - throws: APIError.invalidURL: Will be thrown if the supplied URL and/or parameters are not valid
     - throws: APIError.decoding: Will be thrown if the supplied Body dictionary is not valid or encodable.
     */
    public static func put(urlString: String, urlParameter params: [String:String]? = nil, httpHeaders headers: [String: String]? = nil, body: [String: Any]? = nil) throws -> AnyPublisher<T, APIError> {
        do {
            return try performNetworkCall(urlString: urlString, method: .put, urlParameter: params, httpHeaders: headers, body: body)
        }
        catch let error {
            throw error
        }
    }
    
    /**
     Performs a HTTP DELETE Call.
     
     - parameter urlString: String of the URL
     - parameter urlParameter: Dictionary of URL parameters.
     - parameter httpHeaders: Dictionary of HTTP headers.
     - parameter body: Dictionary of HTTP Body. Must be JSON encodable!
     - returns: AnyPublisher: Publisher for the generic Codable object.
     - throws: APIError.invalidURL: Will be thrown if the supplied URL and/or parameters are not valid
     - throws: APIError.decoding: Will be thrown if the supplied Body dictionary is not valid or encodable.
     */
    public static func delete(urlString: String, urlParameter params: [String:String]? = nil, httpHeaders headers: [String: String]? = nil, body: [String: Any]? = nil) throws -> AnyPublisher<T, APIError> {
        do {
            return try performNetworkCall(urlString: urlString, method: .delete, urlParameter: params, httpHeaders: headers, body: body)
        }
        catch let error {
            throw error
        }
    }
    
    private static func performNetworkCall(urlString: String, method: Method, urlParameter params: [String:String]? = nil, httpHeaders headers: [String: String]? = nil, body: [String: Any]? = nil) throws -> AnyPublisher<T,APIError>  {
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
        
        var request = URLRequest(url: url)
        
        if let headers = headers {
            headers.forEach { (key, value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.httpMethod = method.rawValue
        
        if let bodyObject = body {
            guard  let bodyData = try? JSONSerialization.data(withJSONObject: bodyObject, options: .fragmentsAllowed) else {
                throw APIError.decoding
            }
            request.httpBody = bodyData
        }
        
        
        return session.dataTaskPublisher(for: request)
            .tryMap { response in // tries to map the response (data) as a HTTPURLResponse, checks Status code.
                guard let httpURLResponse = response.response as? HTTPURLResponse,
                      (200...299).contains(httpURLResponse.statusCode) else {
                    throw APIError.statusCode
                }
                return response.data
            }
            .decode(type: T.self, decoder: JSONDecoder()) //decodes the response.data as JSON, and tries to map it to a Codable object.
            .mapError { APIError.map($0) } //if an error occurs during any of this, it gets mapped.
            .eraseToAnyPublisher() // all weird stuff is erased, a clean AnyPublisher is returned - just as we want.
        
    }
    
    private static func getConfig() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        return config
    }
}
