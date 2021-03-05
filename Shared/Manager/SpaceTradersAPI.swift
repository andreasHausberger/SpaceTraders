//
//  SpaceTradersAPI.swift
//  SpaceTraders
//
//  Created by Andreas Hausberger on 05.03.21.
//

import Foundation
import Combine

class SpaceTradersAPI {
    
    public static var shared: SpaceTradersAPI {
        let api = SpaceTradersAPI()
        //do additional setup here
        return api
    }
    
    public func getStatus() -> AnyPublisher<StatusResponse, APIError>? {
        let urlString = Constants.API.base + "/game/status"
        
        return try? Network.get(urlString: urlString)
    }
    
    public func postUsername(username: String) -> AnyPublisher<UsernameResponse, APIError>? {
        let url = Constants.API.base + "/users/\(username)/token"
        return try? Network.post(urlString: url)
    }
    
    public func getUserInfo(username: String, token: String) -> AnyPublisher<UserInfoResponse, APIError>? {
        let url = Constants.API.base + "/users/\(username)"
        return try? Network.get(urlString: url, params: [
            "token" :   token
        ])
    }
}
