//
//  Category.swift
//  ShoppingApp
//
//  Created by apple on 27/04/23.
//

import Foundation
import IGListKit

class Category: Codable,ListDiffable {
    let id : Int
    let name : String?
    let image : String?
    let creationAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case image = "image"
        case creationAt = "creationAt"
        case updatedAt = "updatedAt"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        creationAt = try values.decodeIfPresent(String.self, forKey: .creationAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
    
    //MARK: - List Diffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard object !== self else { return true }
        guard let object = object as? Category else {
            return false
        }
        return name == object.name
    }
}
