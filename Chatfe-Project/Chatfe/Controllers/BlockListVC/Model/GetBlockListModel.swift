//
//  GetBlockListModel.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 26/07/22.
//

import Foundation

struct GetBlockListModel : Codable {
	let status : String?
	let code : Int?
	let data : [GetBlockListData]?
	let page : Int?
	let pageSize : Int?
	let totalCount : Int?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case code = "code"
		case data = "data"
		case page = "page"
		case pageSize = "pageSize"
		case totalCount = "totalCount"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		code = try values.decodeIfPresent(Int.self, forKey: .code)
		data = try values.decodeIfPresent([GetBlockListData].self, forKey: .data)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
		pageSize = try values.decodeIfPresent(Int.self, forKey: .pageSize)
		totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
	}

}


struct GetBlockListData : Codable {
    let status : String?
    let _id : String?
    let blockUser : ProfileData?
    let createdBy : String?
    let __v : Int?
    let createdAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case _id = "_id"
        case blockUser = "blockUser"
        case createdBy = "createdBy"
        case __v = "__v"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        blockUser = try values.decodeIfPresent(ProfileData.self, forKey: .blockUser)
        createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}
