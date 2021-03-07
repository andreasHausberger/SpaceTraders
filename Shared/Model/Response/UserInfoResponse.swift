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
    let type: String
    let amount: Int
    let rate: Double
    let termInDays: Int
    let collateralRequired: Bool
}

struct Ship: Codable {
    
}
