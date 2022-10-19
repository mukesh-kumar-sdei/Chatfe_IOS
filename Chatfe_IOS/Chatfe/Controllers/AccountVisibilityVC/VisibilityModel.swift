//
//  VisibilityModel.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 28/07/22.
//

import Foundation

struct VisibilityModel : Codable {
    let code : Int?
    let status : String?
    let data : VisibilityData?
    let message: String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case status = "status"
        case data = "data"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        data = try values.decodeIfPresent(VisibilityData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}


struct VisibilityData : Codable {
    let dating : DatingData?
    let dob : DobData?
    let gender : GenderData?
    let hometown : HometownData?
    let profileImg : ProfileImgData?

    enum CodingKeys: String, CodingKey {

        case dating = "dating"
        case dob = "dob"
        case gender = "gender"
        case hometown = "hometown"
        case profileImg = "profileImg"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dating = try values.decodeIfPresent(DatingData.self, forKey: .dating)
        dob = try values.decodeIfPresent(DobData.self, forKey: .dob)
        gender = try values.decodeIfPresent(GenderData.self, forKey: .gender)
        hometown = try values.decodeIfPresent(HometownData.self, forKey: .hometown)
        profileImg = try values.decodeIfPresent(ProfileImgData.self, forKey: .profileImg)
    }

}
