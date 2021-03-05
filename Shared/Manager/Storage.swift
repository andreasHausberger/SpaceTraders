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
    
    public func writeToUserDefaults<T: Any>(for key: String, value: T) {
        UserDefaults.standard.setValue(T.self, forKey: key)
    }
    
    public func readFromUserDefaults<T: Any>(for key: String) -> T? {
        UserDefaults.value(forKey: key) as? T
    }
}
