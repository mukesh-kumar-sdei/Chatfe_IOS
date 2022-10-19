

import Foundation

struct MatchPrefModel : Codable {
	let status : String?
	let code : Int?
	let data : MatchPrefData?
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
		data = try values.decodeIfPresent(MatchPrefData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
	}

}


struct MatchPrefData : Codable {
    let status : String?
    let matchType : String?
    let _id : String?
    let createdBy : String?
    let userId : String?
    let __v : Int?
    let createdAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case matchType = "matchType"
        case _id = "_id"
        case createdBy = "createdBy"
        case userId = "userId"
        case __v = "__v"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        matchType = try values.decodeIfPresent(String.self, forKey: .matchType)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}
