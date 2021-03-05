//
//  UserInfo.swift
//  SpaceTraders (iOS)
//
//  Created by Andreas Hausberger on 05.03.21.
//

import Foundation

struct UserInfoResponse: Codable {
    let user: UserInfo
}

struct UserInfo: Codable {
    let credits: Int
    let loans: [Loan]
    let ships: [Ship]
    let username: String?
}

struct Loan: Codable {
    
}

struct Ship: Codable {
    
}
