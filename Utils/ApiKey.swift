//
//  ApiKey.swift
//  Speaker
//
//  Created by Тихон on 22.08.2021.
//

import Foundation
import SwiftKeychainWrapper


let apiKeyKeychainKey: String = "telepat_token"

class KeyChainTokenViewModel {
    var token: String? {
        return KeychainWrapper.standard.string(forKey: apiKeyKeychainKey)
    }
    
    func insertToken(validToken: String) {
        if !KeychainWrapper.standard.set(validToken, forKey: apiKeyKeychainKey) {
            fatalError("Error saving token.")
        }
    }
    
    func deleteTokens() {
        if !KeychainWrapper.standard.removeObject(forKey: apiKeyKeychainKey) {
            fatalError("Error removing token.")
        }
    }
}
