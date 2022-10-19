
import Foundation

struct GetAllFriendRequestModel : Codable {
	let status : String?
	let code : Int?
	let data : [GetAllFriendRequestData]?
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
		data = try values.decodeIfPresent([GetAllFriendRequestData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
	}

}
