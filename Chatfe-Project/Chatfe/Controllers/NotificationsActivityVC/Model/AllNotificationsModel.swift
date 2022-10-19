

import Foundation


struct AllNotificationsModel : Codable {
	let status : String?
	let code : Int?
	let data : NotificationsData?
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
		data = try values.decodeIfPresent(NotificationsData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
	}

}


struct NotificationsData : Codable {
    let friendResult : [FriendResult]?
    let privateRoomResult : [PrivateRoomResult]?
    let userCreatedResult : [UserCreatedResult]?
    let joinedRoomResult : [JoinedRoomResult]?
    let birthdayResults : [BirthdayResults]?

    enum CodingKeys: String, CodingKey {

        case friendResult = "friendResult"
        case privateRoomResult = "privateRoomResult"
        case userCreatedResult = "userCreatedResult"
        case joinedRoomResult = "joinedRoomResult"
        case birthdayResults = "birthdayResults"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        friendResult = try values.decodeIfPresent([FriendResult].self, forKey: .friendResult)
        privateRoomResult = try values.decodeIfPresent([PrivateRoomResult].self, forKey: .privateRoomResult)
        userCreatedResult = try values.decodeIfPresent([UserCreatedResult].self, forKey: .userCreatedResult)
        joinedRoomResult = try values.decodeIfPresent([JoinedRoomResult].self, forKey: .joinedRoomResult)
        birthdayResults = try values.decodeIfPresent([BirthdayResults].self, forKey: .birthdayResults)
    }

}


struct FriendResult : Codable {
    let requestStatus : String?
    let status : String?
    let _id : String?
    let senderId : String?
    let receiverId : String?
    let requestTime : String?
    let senderData : FriendsData?
    let createdAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case requestStatus = "requestStatus"
        case status = "status"
        case _id = "_id"
        case senderId = "senderId"
        case receiverId = "receiverId"
        case requestTime = "requestTime"
        case senderData = "senderData"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        requestStatus = try values.decodeIfPresent(String.self, forKey: .requestStatus)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        senderId = try values.decodeIfPresent(String.self, forKey: .senderId)
        receiverId = try values.decodeIfPresent(String.self, forKey: .receiverId)
        requestTime = try values.decodeIfPresent(String.self, forKey: .requestTime)
        senderData = try values.decodeIfPresent(FriendsData.self, forKey: .senderData)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}


struct PrivateRoomResult : Codable {
    let status : String?
    let _id : String?
    let senderId : String?
    let receiverId : String?
    let roomId : String?
    let requestTime : String?
    let senderData : FriendsData?
    let createdAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case _id = "_id"
        case senderId = "senderId"
        case receiverId = "receiverId"
        case roomId = "roomId"
        case requestTime = "requestTime"
        case senderData = "senderData"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        senderId = try values.decodeIfPresent(String.self, forKey: .senderId)
        receiverId = try values.decodeIfPresent(String.self, forKey: .receiverId)
        roomId = try values.decodeIfPresent(String.self, forKey: .roomId)
        requestTime = try values.decodeIfPresent(String.self, forKey: .requestTime)
        senderData = try values.decodeIfPresent(FriendsData.self, forKey: .senderData)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}


struct JoinedRoomResult : Codable {
    let _id : String?
    let notificationType : String?
    let roomId : String?
    let roomName : String?
    let roomImage : String?
    let roomJoiningTime : String?
    let senderData : FriendsData?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case notificationType = "notificationType"
        case roomId = "roomId"
        case roomName = "roomName"
        case roomImage = "roomImage"
        case roomJoiningTime = "roomJoiningTime"
        case senderData = "senderData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        notificationType = try values.decodeIfPresent(String.self, forKey: .notificationType)
        roomId = try values.decodeIfPresent(String.self, forKey: .roomId)
        roomName = try values.decodeIfPresent(String.self, forKey: .roomName)
        roomImage = try values.decodeIfPresent(String.self, forKey: .roomImage)
        roomJoiningTime = try values.decodeIfPresent(String.self, forKey: .roomJoiningTime)
        senderData = try values.decodeIfPresent(FriendsData.self, forKey: .senderData)
    }

}

struct BirthdayResults : Codable {
    let message : String?
    let type : String?
    let userId : String?
    let createdAt : String?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case type = "type"
        case userId = "userId"
        case createdAt = "createdAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    }
}

struct UserCreatedResult : Codable {
    let _id : String?
    let notificationType : String?
    let roomId : String?
    let roomName : String?
    let roomImage : String?
    let roomCreationTime : String?
    let createdBy : String?
    let creatorProfileImg : String?
    let creatorfname : String?
    let creatorlname : String?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case notificationType = "notificationType"
        case roomId = "roomId"
        case roomName = "roomName"
        case roomImage = "roomImage"
        case roomCreationTime = "roomCreationTime"
        case createdBy = "createdBy"
        case creatorProfileImg = "creatorProfileImg"
        case creatorfname = "creatorfname"
        case creatorlname = "creatorlname"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        notificationType = try values.decodeIfPresent(String.self, forKey: .notificationType)
        roomId = try values.decodeIfPresent(String.self, forKey: .roomId)
        roomName = try values.decodeIfPresent(String.self, forKey: .roomName)
        roomImage = try values.decodeIfPresent(String.self, forKey: .roomImage)
        roomCreationTime = try values.decodeIfPresent(String.self, forKey: .roomCreationTime)
        createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
        creatorProfileImg = try values.decodeIfPresent(String.self, forKey: .creatorProfileImg)
        creatorfname = try values.decodeIfPresent(String.self, forKey: .creatorfname)
        creatorlname = try values.decodeIfPresent(String.self, forKey: .creatorlname)
    }

}
