
import Foundation


struct SenderIdData : Codable {
	let dating : DatingData?
	let dob : DobData?
	let gender : GenderData?
	let hometown : HometownData?
	let profileImg : ProfileImgData?
	let aboutYourself : String?
	let interestedInDate : Bool?
	let loginType : String?
	let status : String?
	let _id : String?
	let lname : String?
	let notification : Bool?
	let fname : String?
	let email : String?
	let designation : String?
	let password : String?
	let drink : String?
	let isMobileVerified : Bool?
	let username : String?
	let isEmailVerified : Bool?
	let phone : String?
	let createdAt : String?
	let updatedAt : String?
	let __v : Int?
    let isBlocked : Bool?
    let chatHeadId : String?

	enum CodingKeys: String, CodingKey {

		case dating = "dating"
		case dob = "dob"
		case gender = "gender"
		case hometown = "hometown"
		case profileImg = "profileImg"
		case aboutYourself = "aboutYourself"
		case interestedInDate = "interestedInDate"
		case loginType = "loginType"
		case status = "status"
		case _id = "_id"
		case lname = "lname"
		case notification = "notification"
		case fname = "fname"
		case email = "email"
		case designation = "designation"
		case password = "password"
		case drink = "drink"
		case isMobileVerified = "isMobileVerified"
		case username = "username"
		case isEmailVerified = "isEmailVerified"
		case phone = "phone"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
		case __v = "__v"
        case isBlocked = "isBlocked"
        case chatHeadId = "chatHeadId"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dating = try values.decodeIfPresent(DatingData.self, forKey: .dating)
		dob = try values.decodeIfPresent(DobData.self, forKey: .dob)
		gender = try values.decodeIfPresent(GenderData.self, forKey: .gender)
		hometown = try values.decodeIfPresent(HometownData.self, forKey: .hometown)
		profileImg = try values.decodeIfPresent(ProfileImgData.self, forKey: .profileImg)
		aboutYourself = try values.decodeIfPresent(String.self, forKey: .aboutYourself)
		interestedInDate = try values.decodeIfPresent(Bool.self, forKey: .interestedInDate)
		loginType = try values.decodeIfPresent(String.self, forKey: .loginType)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		lname = try values.decodeIfPresent(String.self, forKey: .lname)
		notification = try values.decodeIfPresent(Bool.self, forKey: .notification)
		fname = try values.decodeIfPresent(String.self, forKey: .fname)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		designation = try values.decodeIfPresent(String.self, forKey: .designation)
		password = try values.decodeIfPresent(String.self, forKey: .password)
		drink = try values.decodeIfPresent(String.self, forKey: .drink)
		isMobileVerified = try values.decodeIfPresent(Bool.self, forKey: .isMobileVerified)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		isEmailVerified = try values.decodeIfPresent(Bool.self, forKey: .isEmailVerified)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		__v = try values.decodeIfPresent(Int.self, forKey: .__v)
        isBlocked = try values.decodeIfPresent(Bool.self, forKey: .isBlocked)
        chatHeadId = try values.decodeIfPresent(String.self, forKey: .chatHeadId)
	}

}
