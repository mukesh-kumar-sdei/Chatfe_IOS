//
//  RoomJoinedModel.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 20/07/22.
//

import Foundation

struct RoomJoinedModel : Codable {
	let status : String?
	let code : Int?
	let data : [RoomJoinedData]?
    let message : String?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case code = "code"
		case data = "data"
        case message = "message"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		code = try values.decodeIfPresent(Int.self, forKey: .code)
		data = try values.decodeIfPresent([RoomJoinedData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
	}

}


struct RoomJoinedData : Codable {
    let status : String?
    let _id : String?
    let roomId : RoomData?
    let userId : String?
    let addedBy : String?
    let createdAt : String?
    let updatedAt : String?
    let __v : Int?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case _id = "_id"
        case roomId = "roomId"
        case userId = "userId"
        case addedBy = "addedBy"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case __v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        roomId = try values.decodeIfPresent(RoomData.self, forKey: .roomId)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        addedBy = try values.decodeIfPresent(String.self, forKey: .addedBy)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
    }

}
