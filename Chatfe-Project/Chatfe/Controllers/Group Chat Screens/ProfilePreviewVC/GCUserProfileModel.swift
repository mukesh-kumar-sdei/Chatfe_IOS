
import Foundation

struct GCUserProfileModel : Codable {
	let status : String?
	let code : Int?
	let data : GCUserProfileData?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case code = "code"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		code = try values.decodeIfPresent(Int.self, forKey: .code)
		data = try values.decodeIfPresent(GCUserProfileData.self, forKey: .data)
	}

}


struct GCUserProfileData : Codable {
    let _id : String?
    let profileImg : ProfileImgData?
    let fname : String?
    let lname : String?
    let gender : GenderData?
    let dob : DobData?
    let matchType : String?
    let requestStatus : String?
    let isVotedToRemove : Bool?
    let drink: DrinkData?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case profileImg = "profileImg"
        case fname = "fname"
        case lname = "lname"
        case gender = "gender"
        case dob = "dob"
        case matchType = "matchType"
        case requestStatus = "requestStatus"
        case isVotedToRemove = "isVotedToRemove"
        case drink = "drink"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        profileImg = try values.decodeIfPresent(ProfileImgData.self, forKey: .profileImg)
        fname = try values.decodeIfPresent(String.self, forKey: .fname)
        lname = try values.decodeIfPresent(String.self, forKey: .lname)
        gender = try values.decodeIfPresent(GenderData.self, forKey: .gender)
        dob = try values.decodeIfPresent(DobData.self, forKey: .dob)
        matchType = try values.decodeIfPresent(String.self, forKey: .matchType)
        requestStatus = try values.decodeIfPresent(String.self, forKey: .requestStatus)
        isVotedToRemove = try values.decodeIfPresent(Bool.self, forKey: .isVotedToRemove)
        drink = try values.decodeIfPresent(DrinkData.self, forKey: .drink)
    }

}
