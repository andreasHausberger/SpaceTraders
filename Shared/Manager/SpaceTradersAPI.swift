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
        let urlString = Constants.API.base
        
        return try? Network.get(urlString: urlString)
    }
}
