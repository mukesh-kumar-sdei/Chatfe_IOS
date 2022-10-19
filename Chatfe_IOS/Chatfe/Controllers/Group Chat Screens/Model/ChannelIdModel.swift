

import Foundation

struct ChannelIdModel : Codable {
	let status : String?
	let code : Int?
	let data : ChannelIdData?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case code = "code"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		code = try values.decodeIfPresent(Int.self, forKey: .code)
		data = try values.decodeIfPresent(ChannelIdData.self, forKey: .data)
	}

}


struct ChannelIdData : Codable {
    let _id : String?
    let roomId : String?
    let roomName : String?
    let roomClass : String?
    let channelId : String?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case roomId = "roomId"
        case roomName = "roomName"
        case roomClass = "roomClass"
        case channelId = "channelId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        roomId = try values.decodeIfPresent(String.self, forKey: .roomId)
        roomName = try values.decodeIfPresent(String.self, forKey: .roomName)
        roomClass = try values.decodeIfPresent(String.self, forKey: .roomClass)
        channelId = try values.decodeIfPresent(String.self, forKey: .channelId)
    }

}
