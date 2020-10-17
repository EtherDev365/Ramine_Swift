//
//  UserDefaultManager.swift
//  Tivovi
//
//  Created by zapbuild on 30/08/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import Foundation
class UserDefaultManager {
    struct Key {
        static let favoriteArray = "favoriteArray"
    }
    func saveFavorite(_ array: [Any]) {
        UserDefaults.standard.set(array, forKey: Key.favoriteArray)
    }
    func fetchFavorites() -> [Any] {
        return UserDefaults.standard.array(forKey: Key.favoriteArray) ?? []
    }
    
}
