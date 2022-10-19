//
//  EventDetailsUserListModel.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 13/06/22.
//

import Foundation

struct EventDetailsUserListModel : Codable {
    let status : String?
    let code : Int?
    let data : EventDetailUserListData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case code = "code"
        case data = "data"
        case message
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        data = try values.decodeIfPresent(EventDetailUserListData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}



struct EventDetailUserListData : Codable {
    let roomData : RoomData?
    let userData : [UserListData]?

    enum CodingKeys: String, CodingKey {

        case roomData = "roomData"
        case userData = "userData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        roomData = try values.decodeIfPresent(RoomData.self, forKey: .roomData)
        userData = try values.decodeIfPresent([UserListData].self, forKey: .userData)
    }

}


struct UserListData : Codable {
    let _id : String?
    let username : String?
    let profileImg : ProfileImgData?
    let email : String?
    let fname : String?
    let lname : String?
    let gender : GenderData?
    let phone : String?
    let aboutYourself : String?
//    let drink : String?
    let drink: DrinkData?
    let hometown : HometownData?
    let dob : DobData?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case username = "username"
        case profileImg = "profileImg"
//        case email = "email"
        case email = "mails"
        case fname = "fname"
        case lname = "lname"
        case gender = "gender"
        case phone = "phone"
        case aboutYourself = "aboutYourself"
        case drink = "drink"
        case hometown = "hometown"
        case dob = "dob"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        profileImg = try values.decodeIfPresent(ProfileImgData.self, forKey: .profileImg)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        fname = try values.decodeIfPresent(String.self, forKey: .fname)
        lname = try values.decodeIfPresent(String.self, forKey: .lname)
        gender = try values.decodeIfPresent(GenderData.self, forKey: .gender)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        aboutYourself = try values.decodeIfPresent(String.self, forKey: .aboutYourself)
//        drink = try values.decodeIfPresent(String.self, forKey: .drink)
        drink = try values.decodeIfPresent(DrinkData.self, forKey: .drink)
        hometown = try values.decodeIfPresent(HometownData.self, forKey: .hometown)
        dob = try values.decodeIfPresent(DobData.self, forKey: .dob)
    }

}
