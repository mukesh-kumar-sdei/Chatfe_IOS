//
//  FavouriteDrinkResponse.swift
//  Chatfe
//
//  Created by Piyush Mohan on 26/04/22.
//

import Foundation

struct FavouriteDrinkResponse: Decodable {
    var status: String?
    var code: Int?
    var data: [FavouriteDrink]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        code = try? values.decodeIfPresent(Int.self, forKey: .code)
        data = try? values.decodeIfPresent([FavouriteDrink].self, forKey: .data)
    }
}

struct FavouriteDrink: Decodable {
    var status: String?
    var _id: String?
    var image: String?
    var drinkName: String?
    var createdAt: String?
    var updatedAt: String?
    var __v: Int?
    
    enum CodingKeys: String, CodingKey {
        case status
        case _id
        case image
        case drinkName
        case createdAt
        case updatedAt
        case __v
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        _id = try? values.decodeIfPresent(String.self, forKey: ._id)
        image = try? values.decodeIfPresent(String.self, forKey: .image)
        drinkName = try? values.decodeIfPresent(String.self, forKey: .drinkName)
        createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
        __v = try? values.decodeIfPresent(Int.self, forKey: .__v)
    }
}
