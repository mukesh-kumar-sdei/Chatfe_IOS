

import Foundation

struct RecentConnectionModel : Codable {
	let recentSuggestions : [RecentSuggestions]?
	let conversationResult : [ConversationResult]?

	enum CodingKeys: String, CodingKey {

		case recentSuggestions = "recentSuggestions"
		case conversationResult = "conversationResult"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		recentSuggestions = try values.decodeIfPresent([RecentSuggestions].self, forKey: .recentSuggestions)
		conversationResult = try values.decodeIfPresent([ConversationResult].self, forKey: .conversationResult)
	}

}


struct RecentSuggestions : Codable {
    let _id : String?
    let profileImg : String?
    let fname : String?
    let lname : String?
    let chatHeadId : String?
    let isOnline : Bool?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case profileImg = "profileImg"
        case fname = "fname"
        case lname = "lname"
        case chatHeadId = "chatHeadId"
        case isOnline = "isOnline"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        profileImg = try values.decodeIfPresent(String.self, forKey: .profileImg)
        fname = try values.decodeIfPresent(String.self, forKey: .fname)
        lname = try values.decodeIfPresent(String.self, forKey: .lname)
        chatHeadId = try values.decodeIfPresent(String.self, forKey: .chatHeadId)
        isOnline = try values.decodeIfPresent(Bool.self, forKey: .isOnline)
    }

}



struct ConversationResult : Codable {
    let _id : String?
    let senderId : String?
    let senderFirstName : String?
    let senderLastName : String?
    let profileImg : String?
    var receiverData : ReceiverData?
    let msg : String?
    let msgDate : String?
    let messageSender : String?
    let readers : [String]?
    let messageType : String?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case senderId = "senderId"
        case senderFirstName = "senderFirstName"
        case senderLastName = "senderLastName"
        case profileImg = "profileImg"
        case receiverData = "receiverData"
        case msg = "msg"
        case msgDate = "msgDate"
        case messageSender = "messageSender"
        case readers = "readers"
        case messageType = "messageType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        senderId = try values.decodeIfPresent(String.self, forKey: .senderId)
        senderFirstName = try values.decodeIfPresent(String.self, forKey: .senderFirstName)
        senderLastName = try values.decodeIfPresent(String.self, forKey: .senderLastName)
        profileImg = try values.decodeIfPresent(String.self, forKey: .profileImg)
        receiverData = try values.decodeIfPresent(ReceiverData.self, forKey: .receiverData)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
        msgDate = try values.decodeIfPresent(String.self, forKey: .msgDate)
        messageSender = try values.decodeIfPresent(String.self, forKey: .messageSender)
        readers = try values.decodeIfPresent([String].self, forKey: .readers)
        messageType = try values.decodeIfPresent(String.self, forKey: .messageType)
    }

}


struct ReceiverData : Codable {
    let receiverId : String?
    let receiverFirstName : String?
    let receiverLastName : String?
    let profileImg : String?
    var isOnline : Bool?

    enum CodingKeys: String, CodingKey {

        case receiverId = "receiverId"
        case receiverFirstName = "receiverFirstName"
        case receiverLastName = "receiverLastName"
        case profileImg = "profileImg"
        case isOnline = "isOnline"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        receiverId = try values.decodeIfPresent(String.self, forKey: .receiverId)
        receiverFirstName = try values.decodeIfPresent(String.self, forKey: .receiverFirstName)
        receiverLastName = try values.decodeIfPresent(String.self, forKey: .receiverLastName)
        profileImg = try values.decodeIfPresent(String.self, forKey: .profileImg)
        isOnline = try values.decodeIfPresent(Bool.self, forKey: .isOnline)
    }

}
