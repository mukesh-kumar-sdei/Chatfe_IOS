//
//  SearchRoomModel.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 28/06/22.
//

import Foundation

struct SearchRoomModel : Codable {
    let status : String?
    let code : Int?
    let data : [RoomData]?
    let page : Int?
    let pageSize : Int?
    let totalCount : Int?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case code = "code"
        case data = "data"
        case page = "page"
        case pageSize = "pageSize"
        case totalCount = "totalCount"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        data = try values.decodeIfPresent([RoomData].self, forKey: .data)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        pageSize = try values.decodeIfPresent(Int.self, forKey: .pageSize)
        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
