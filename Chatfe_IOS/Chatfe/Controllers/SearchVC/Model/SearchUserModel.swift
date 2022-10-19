
import Foundation

struct SearchUserModel : Codable {
	let status : String?
	let code : Int?
	let data : [SearchUserData]?
	let page : Int?
	let pageSize : Int?
    let totalCount : Int?
    let message : String?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case code = "code"
		case data = "data"
		case page = "page"
		case pageSize = "pageSize"
        case totalCount = "totalCount"
        case message = "message"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		code = try values.decodeIfPresent(Int.self, forKey: .code)
		data = try values.decodeIfPresent([SearchUserData].self, forKey: .data)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
		pageSize = try values.decodeIfPresent(Int.self, forKey: .pageSize)
        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
        message = try values.decodeIfPresent(String.self, forKey: .message)
	}

}


struct SearchUserData : Codable {
    let dob : DobData?
    let gender : GenderData?
    let profileImg : ProfileImgData?
    let _id : String?
    let fname : String?
    let lname : String?
    let username : String?
    let createdAt : String?
    let loginType : String?

    enum CodingKeys: String, CodingKey {

        case dob = "dob"
        case gender = "gender"
        case profileImg = "profileImg"
        case _id = "_id"
        case fname = "fname"
        case lname = "lname"
        case username = "username"
        case createdAt = "createdAt"
        case loginType
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dob = try values.decodeIfPresent(DobData.self, forKey: .dob)
        gender = try values.decodeIfPresent(GenderData.self, forKey: .gender)
        profileImg = try values.decodeIfPresent(ProfileImgData.self, forKey: .profileImg)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        fname = try values.decodeIfPresent(String.self, forKey: .fname)
        lname = try values.decodeIfPresent(String.self, forKey: .lname)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        loginType = try values.decodeIfPresent(String.self, forKey: .loginType)
    }

}
