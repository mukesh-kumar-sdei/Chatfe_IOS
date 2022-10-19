

import Foundation

struct GetEventChatsModel : Codable {
	let messageType : String?
	let reaction : [ReactionData]?
	let readers : [String]?
	let status : String?
	let _id : String?
	let channelId : String?
	let message : String?
	var senderId : SenderData?
	let createdAt : String?
	let updatedAt : String?
	let __v : Int?

	enum CodingKeys: String, CodingKey {

		case messageType = "messageType"
		case reaction = "reaction"
		case readers = "readers"
		case status = "status"
		case _id = "_id"
		case channelId = "channelId"
		case message = "message"
		case senderId = "senderId"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
		case __v = "__v"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		messageType = try values.decodeIfPresent(String.self, forKey: .messageType)
		reaction = try values.decodeIfPresent([ReactionData].self, forKey: .reaction)
		readers = try values.decodeIfPresent([String].self, forKey: .readers)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		channelId = try values.decodeIfPresent(String.self, forKey: .channelId)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		senderId = try values.decodeIfPresent(SenderData.self, forKey: .senderId)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		__v = try values.decodeIfPresent(Int.self, forKey: .__v)
	}

}


struct SenderData : Codable {
    let _id : String?
    let fname : String?
    let lname : String?
    var color : String?
    var matchType : String?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case fname = "fname"
        case lname = "lname"
        case color
        case matchType
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        fname = try values.decodeIfPresent(String.self, forKey: .fname)
        lname = try values.decodeIfPresent(String.self, forKey: .lname)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        matchType = try values.decodeIfPresent(String.self, forKey: .matchType)
    }

}


struct UnreadCountModel : Codable {
    let unreadMsgCount : Int?
    let unreadGrpMsgCount : Int?
    
    enum CodingKeys: String, CodingKey {

        case unreadMsgCount = "unreadMsgCount"
        case unreadGrpMsgCount = "unreadGrpMsgCount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        unreadMsgCount = try values.decodeIfPresent(Int.self, forKey: .unreadMsgCount)
        unreadGrpMsgCount = try values.decodeIfPresent(Int.self, forKey: .unreadGrpMsgCount)
    }

}
