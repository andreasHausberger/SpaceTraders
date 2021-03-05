//
//  UsernameResponse.swift
//  SpaceTraders (iOS)
//
//  Created by Andreas Hausberger on 05.03.21.
//

import Foundation

struct UsernameResponse: Codable {
    let token: String
    let user: SpaceTradersUser
}

struct SpaceTradersUser: Codable {
    let createdAt: Date
    let credits: Int
    let email: String?
    let id: String
    let picture: String?
    let updateAt: Date?
    let name: String
    
    public enum codingKeys: String, CodingKey {
        case name = "username"
    }
}
