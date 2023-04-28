//
//  Product.swift
//  ShoppingApp
//
//  Created by apple on 27/04/23.
//

import Foundation
import IGListKit

class Product: Codable, ListDiffable {
    let id : Int
    let title : String?
    let price : Int?
    let description : String?
    let images : [String]?
    let creationAt : String?
    let updatedAt : String?
    let category : Category?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case price = "price"
        case description = "description"
        case images = "images"
        case creationAt = "creationAt"
        case updatedAt = "updatedAt"
        case category = "category"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        title = try values.decodeIfPresent(String.self, forKey: .title)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        images = try values.decodeIfPresent([String].self, forKey: .images)
        creationAt = try values.decodeIfPresent(String.self, forKey: .creationAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        category = try values.decodeIfPresent(Category.self, forKey: .category)
    }
    
    //MARK: - List Diffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard object !== self else { return true }
        guard let object = object as? Product else {
            return false
        }
        return title == object.title && (category?.isEqual(toDiffableObject: object.category) ?? true)
    }

}
