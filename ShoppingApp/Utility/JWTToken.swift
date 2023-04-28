//
//  JWTToken.swift
//  ShoppingApp
//
//  Created by apple on 25/04/23.
//

import Foundation

typealias HTTPHeaders = [String: String]

struct JWTToken {
    static let accessTokenKey = "access_token"
    static let refreshTokenKey = "refresh_token"
    
    static func saveToken(accessToken: String, refreshToken: String) {
        UserDefaults.standard.set(accessToken, forKey: accessTokenKey)
        UserDefaults.standard.set(accessToken, forKey: refreshTokenKey)
    }
    
    static func clearCache() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    }
    
    static func getJwtToken() -> String? {
        if let accessToken = UserDefaults.standard.value(forKey: accessTokenKey) as? String {
            return "bearer \(accessToken)"
        } else {
            return nil
        }
    }
    
}
