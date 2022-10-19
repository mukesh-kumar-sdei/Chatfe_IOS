
import Foundation
//import FirebaseDatabaseSwift

struct ParticipantsModel : Codable {
	let status : String?
	let code : Int?
	let data : [ParticipantsData]?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case code = "code"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		code = try values.decodeIfPresent(Int.self, forKey: .code)
		data = try values.decodeIfPresent([ParticipantsData].self, forKey: .data)
	}

}


struct ParticipantsData : Codable {
    let _id : String?
    let fname : String?
    let lname : String?
    let drinkImg : String?
    let matchType : String?
    var color : String?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case fname = "fname"
        case lname = "lname"
        case drinkImg = "drinkImg"
        case matchType = "matchType"
        case color = "colorCode"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        fname = try values.decodeIfPresent(String.self, forKey: .fname)
        lname = try values.decodeIfPresent(String.self, forKey: .lname)
        drinkImg = try values.decodeIfPresent(String.self, forKey: .drinkImg)
        matchType = try values.decodeIfPresent(String.self, forKey: .matchType)
        color = try values.decodeIfPresent(String.self, forKey: .color)
    }

}


struct VoteMessageModel: Codable {
    let messageType: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        
        case messageType = "messageType"
        case message = "message"
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        messageType = try values.decodeIfPresent(String.self, forKey: .messageType)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}
