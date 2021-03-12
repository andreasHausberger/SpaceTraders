//
//  AvailableLoansResponse.swift
//  SpaceTraders
//
//  Created by Andreas Hausberger on 06.03.21.
//

import Foundation

struct AvailableLoansResponse: Codable {
    let loans: [AvailableLoan]
}
