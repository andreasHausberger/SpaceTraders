//
//  Storage.swift
//  SpaceTraders (iOS)
//
//  Created by Andreas Hausberger on 05.03.21.
//

import Foundation

class Storage {
    
    public static var shared: Storage {
        let storage = Storage()
        
        return storage
    }
    
    public static func getUsernameAndToken() -> (username: String, token: String)? {
        if let username = UserDefaults.standard.string(forKey: Constants.Defaults.username),
           let token = UserDefaults.standard.string(forKey: Constants.Defaults.token) {
            return (username: username, token: token)
        }
        return nil
    }
    
    public static func logout() {
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.username)
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.token)
    }
}
