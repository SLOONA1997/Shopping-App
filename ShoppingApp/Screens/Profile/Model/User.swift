//
//  User.swift
//  ShoppingApp
//
//  Created by apple on 27/04/23.
//

import Foundation

struct User : Codable {
    let email : String?
    let password : String?
    let name : String?
    let avatar : String?
    let role : String?
    let id : Int?
    let creationAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case email = "email"
        case password = "password"
        case name = "name"
        case avatar = "avatar"
        case role = "role"
        case id = "id"
        case creationAt = "creationAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
        role = try values.decodeIfPresent(String.self, forKey: .role)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        creationAt = try values.decodeIfPresent(String.self, forKey: .creationAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}
