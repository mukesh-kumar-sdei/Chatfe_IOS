//
//  RecentSearchModel.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 01/07/22.
//

import Foundation

struct GetRecentSearchModel : Codable {
	let status : String?
	let code : Int?
	let data : [RecentSearchData]?
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
		data = try values.decodeIfPresent([RecentSearchData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
	}

}


struct AddRecentSearchModel : Codable {
    let status : String?
    let code : Int?
    let data : RecentSearchData?
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
        data = try values.decodeIfPresent(RecentSearchData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}


struct RecentSearchData : Codable {
    let type : String?
    let status : String?
    let _id : String?
    let categoryId : String?
    let createdBy : String?
    let __v : Int?
    let createdAt : String?
    let endDate : String?
//    let endTime : String?
    let fname : String?
    let image : String?
    let lname : String?
    let roomName : String?
    let startDate : String?
//    let startTime : String?
    let updatedAt : String?
    let username : String?

    enum CodingKeys: String, CodingKey {

        case type = "type"
        case status = "status"
        case _id = "_id"
        case categoryId = "categoryId"
        case createdBy = "createdBy"
        case __v = "__v"
        case createdAt = "createdAt"
        case endDate = "endDate"
//        case endTime = "endTime"
        case fname = "fname"
        case image = "image"
        case lname = "lname"
        case roomName = "roomName"
        case startDate = "startDate"
//        case startTime = "startTime"
        case updatedAt = "updatedAt"
        case username = "username"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId)
        createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
//        endTime = try values.decodeIfPresent(String.self, forKey: .endTime)
        fname = try values.decodeIfPresent(String.self, forKey: .fname)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        lname = try values.decodeIfPresent(String.self, forKey: .lname)
        roomName = try values.decodeIfPresent(String.self, forKey: .roomName)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
//        startTime = try values.decodeIfPresent(String.self, forKey: .startTime)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        username = try values.decodeIfPresent(String.self, forKey: .username)
    }

}
