

import Foundation


struct GetAllFriendRequestData : Codable {
	let requestStatus : String?
	let status : String?
	let _id : String?
	let senderId : SenderIdData?
	let receiverId : String?
	let createdAt : String?
	let updatedAt : String?
    let requestTime : String?
	let __v : Int?
    let notificationType: String?

	enum CodingKeys: String, CodingKey {

		case requestStatus = "requestStatus"
		case status = "status"
		case _id = "_id"
		case senderId = "senderId"
		case receiverId = "receiverId"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
        case requestTime = "requestTime"
		case __v = "__v"
        case notificationType = "notificationType"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		requestStatus = try values.decodeIfPresent(String.self, forKey: .requestStatus)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		senderId = try values.decodeIfPresent(SenderIdData.self, forKey: .senderId)
		receiverId = try values.decodeIfPresent(String.self, forKey: .receiverId)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        requestTime = try values.decodeIfPresent(String.self, forKey: .requestTime)
		__v = try values.decodeIfPresent(Int.self, forKey: .__v)
        notificationType = try values.decodeIfPresent(String.self, forKey: .notificationType)
	}

}
