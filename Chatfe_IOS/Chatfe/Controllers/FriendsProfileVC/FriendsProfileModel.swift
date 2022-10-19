//
//  FriendsProfileModel.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 14/06/22.
//

import Foundation

struct FriendsProfileModel : Codable {
    let status : String?
    let code : Int?
    let data : [FriendsProfileData]?
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
        data = try values.decodeIfPresent([FriendsProfileData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}


struct FriendsProfileData : Codable {
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
    let designation : String?
    let drink : DrinkData?
    let email : String?
    let fname : String?
    let lname : String?
    let notification : Bool?
    let password : String?
    let phone : String?
    let username : String?
    let createdAt : String?
    let updatedAt : String?
    let __v : Int?
    let googleId : String?
    let otp : String?
    let isFriendRequest : Bool?
    let friends : [FriendsProfileData]?
    let chatHeadId : String?
    let requestStatus : String? //  Pending (For request sent), Confirmed (Request accepted), PendingTOAccept (if reciever sees sender profile), '<blank>' (if no request)
    let isBlocked : Bool?
    let matchType : String?

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
        case designation = "designation"
        case drink = "drink"
        case email = "email"
        case fname = "fname"
        case lname = "lname"
        case notification = "notification"
        case password = "password"
        case phone = "phone"
        case username = "username"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case __v = "__v"
        case googleId = "googleId"
        case otp = "otp"
        case isFriendRequest = "isFriendRequest"
        case friends = "friendsArr"
        case chatHeadId = "chatHeadId"
        case requestStatus = "requestStatus"
        case isBlocked = "isBlocked"
        case matchType = "matchType"
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
        designation = try values.decodeIfPresent(String.self, forKey: .designation)
        drink = try values.decodeIfPresent(DrinkData.self, forKey: .drink)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        fname = try values.decodeIfPresent(String.self, forKey: .fname)
        lname = try values.decodeIfPresent(String.self, forKey: .lname)
        notification = try values.decodeIfPresent(Bool.self, forKey: .notification)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
        googleId = try values.decodeIfPresent(String.self, forKey: .googleId)
        otp = try values.decodeIfPresent(String.self, forKey: .otp)
        isFriendRequest = try values.decodeIfPresent(Bool.self, forKey: .isFriendRequest)
        friends = try values.decodeIfPresent([FriendsProfileData].self, forKey: .friends)
        chatHeadId = try values.decodeIfPresent(String.self, forKey: .chatHeadId)
        requestStatus = try values.decodeIfPresent(String.self, forKey: .requestStatus)
        isBlocked = try values.decodeIfPresent(Bool.self, forKey: .isBlocked)
        matchType = try values.decodeIfPresent(String.self, forKey: .matchType)
    }

}
