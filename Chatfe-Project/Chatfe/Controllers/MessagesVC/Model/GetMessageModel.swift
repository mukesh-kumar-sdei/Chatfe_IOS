
import Foundation


struct GetMessageModel : Codable {
	let messageType : String?
	let status : String?
	let _id : String?
	let chatHeadId : String?
	let message : String?
	let senderId : String?
    let receiverId : String?
    let receiverData : ReceiverData?
	let createdAt : String?
	let updatedAt : String?
	let __v : Int?
    let reactions : [ReactionData]?
    let reaction : [ReactionData]?
    let readers : [String]?
    let channelId : String?

	enum CodingKeys: String, CodingKey {

		case messageType = "messageType"
		case status = "status"
		case _id = "_id"
		case chatHeadId = "chatHeadId"
		case message = "message"
		case senderId = "senderId"
        case receiverId = "receiverId"
        case receiverData = "receiverData"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
		case __v = "__v"
        case reactions = "reactions"
        case reaction = "reaction"
        case readers = "readers"
        case channelId = "channelId"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		messageType = try values.decodeIfPresent(String.self, forKey: .messageType)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
        chatHeadId = try values.decodeIfPresent(String.self, forKey: .chatHeadId)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		senderId = try values.decodeIfPresent(String.self, forKey: .senderId)
        receiverId = try values.decodeIfPresent(String.self, forKey: .receiverId)
        receiverData = try values.decodeIfPresent(ReceiverData.self, forKey: .receiverData)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		__v = try values.decodeIfPresent(Int.self, forKey: .__v)
        reactions = try values.decodeIfPresent([ReactionData].self, forKey: .reactions)
        reaction = try values.decodeIfPresent([ReactionData].self, forKey: .reaction)
        readers = try values.decodeIfPresent([String].self, forKey: .readers)
        channelId = try values.decodeIfPresent(String.self, forKey: .channelId)
	}

}


struct ReactionData : Codable {
    let senderId : String?
    let reaction : String?
    let fname : String?
    let lname : String?
    

    enum CodingKeys: String, CodingKey {

        case senderId = "senderId"
        case reaction = "reaction"
        case fname = "fname"
        case lname = "lname"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        senderId = try values.decodeIfPresent(String.self, forKey: .senderId)
        reaction = try values.decodeIfPresent(String.self, forKey: .reaction)
        fname = try values.decodeIfPresent(String.self, forKey: .fname)
        lname = try values.decodeIfPresent(String.self, forKey: .lname)
    }

}


struct OnlineStatusModel : Codable {
    let onlineStatus : Bool?
    
    enum CodingKeys: String, CodingKey {

        case onlineStatus = "onlineStatus"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        onlineStatus = try values.decodeIfPresent(Bool.self, forKey: .onlineStatus)
    }

}
