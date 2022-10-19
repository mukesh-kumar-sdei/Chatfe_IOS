
import Foundation

struct RecentConnectionDetailModel : Codable {
    let status : String?
    let code : Int?
    let data : RecentConnectionData?
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
        data = try values.decodeIfPresent(RecentConnectionData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}


struct RecentConnectionData : Codable {
	let fname : String?
	let lname : String?
	let profileImg : String?
	let connectedAt : String?
	let joinedDate : String?
    let requestStatus : String?

	enum CodingKeys: String, CodingKey {

		case fname = "fname"
		case lname = "lname"
		case profileImg = "profileImg"
		case connectedAt = "connectedAt"
		case joinedDate = "joinedDate"
        case requestStatus = "requestStatus"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		fname = try values.decodeIfPresent(String.self, forKey: .fname)
		lname = try values.decodeIfPresent(String.self, forKey: .lname)
		profileImg = try values.decodeIfPresent(String.self, forKey: .profileImg)
		connectedAt = try values.decodeIfPresent(String.self, forKey: .connectedAt)
		joinedDate = try values.decodeIfPresent(String.self, forKey: .joinedDate)
        requestStatus = try values.decodeIfPresent(String.self, forKey: .requestStatus)
	}

}
