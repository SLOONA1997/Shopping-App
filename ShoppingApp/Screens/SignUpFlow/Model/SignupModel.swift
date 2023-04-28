//
//  SignupModel.swift
//  ShoppingApp
//
//  Created by apple on 24/04/23.
//

import Foundation

final class SignupModel: LoginModel {
    var name: String
    var avatar: String?
    
    init(email: String, password: String, name: String, avatar: String? = nil) {
        self.name = name
        self.avatar = avatar
        super.init(email: email, password: password)
    }
    
    enum CodingKeys: CodingKey {
        case name, avatar
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(avatar, forKey: .avatar)

        try super.encode(to: encoder)
    }
}
