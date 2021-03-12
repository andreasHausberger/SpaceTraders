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
    
    //MARK: - Username
    
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
        return try? Network.get(urlString: url, urlParameter: [
            "token" :   token
        ])
    }
    
    //MARK: - Loans
    
    public func getAvailableLoans() -> AnyPublisher<AvailableLoansResponse, APIError>? {
        let url = Constants.API.base + "/game/loans"
        if let token = UserDefaults.standard.string(forKey: Constants.Defaults.token) {
            return try? Network.get(urlString: url, urlParameter: [
                "token": token
            ])
        }
        return nil
    }
    
    public func applyForLoan(loanType: String) -> AnyPublisher<UserInfoResponse, APIError>? {
        if let token = UserDefaults.standard.string(forKey: Constants.Defaults.token),
           let username = UserDefaults.standard.string(forKey: Constants.Defaults.username) {
            let url = Constants.API.base + "/users\(username)/loans"
            return try? Network.post(urlString: url, urlParameter: [
                "token": token,
                "type": loanType
            ])
        }
        return nil
    }
}
