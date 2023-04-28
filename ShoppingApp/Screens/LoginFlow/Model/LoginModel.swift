//
//  LoginModel.swift
//  ShoppingApp
//
//  Created by apple on 24/04/23.
//

import Foundation

class LoginModel: Encodable {
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
