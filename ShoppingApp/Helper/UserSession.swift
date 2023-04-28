//
//  UserSession.swift
//  ShoppingApp
//
//  Created by apple on 27/04/23.
//

import UIKit

class UserSession {
    
    static let shared = UserSession()
    
    var isLoggedIn: Bool {
        return JWTToken.getJwtToken() != nil
    }
    
    func saveSession(json: [String: String]) {
        if let accessToken = json["access_token"],let refreshToken = json["refresh_token"] {
            JWTToken.saveToken(accessToken: accessToken, refreshToken: refreshToken)
        }
    }
    
    func clearSession() {
        JWTToken.clearCache()
    }
    
    func checkIfUserLoggedIn() {
        let rootVc: UIViewController?
        if isLoggedIn {
            rootVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
             
        } else {
            rootVc = UIStoryboard.init(name: "Onboarding", bundle: nil).instantiateInitialViewController()
        }
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = rootVc
        }
    }
}
