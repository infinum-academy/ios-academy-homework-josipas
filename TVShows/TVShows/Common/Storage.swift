//
//  Container.swift
//  TVShows
//
//  Created by Infinum on 21/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import Foundation

final class Storage {
    
    static let shared = Storage()
    
    var loginUser: LoginData?
    
    private init() {}

    // UserDefaults
    // Keychain -> KeychainAccess
}
