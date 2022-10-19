//
//  GetProfileResponse.swift
//  Chatfe
//
//  Created by Piyush Mohan on 12/05/22.
//

import Foundation

struct GetProfileResponse: Codable {
    var status: String?
    var code: Int?
    var data: ProfileData?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case data
        case message
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        code = try? values.decodeIfPresent(Int.self, forKey: .code)
        data = try? values.decodeIfPresent(ProfileData.self, forKey: .data)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
    }
}

struct ProfileData: Codable {
    var dating: DatingData?
    var dob: DobData?
    var gender: GenderData?
    var hometown: HometownData?
    var profileImg: ProfileImgData?
    var aboutYourself: String?
    var interestedInDate: Bool?
    var loginType: String?
    var status: String?
    var _id: String?
    var lname: String?
    var drink: DrinkData?
    var designation: String?
    var notification: Bool?
    var isEmailVerified: Bool?
    var fname: String?
    var isMobileVerified: Bool?
    var username: String?
    var password: String?
    var phone: String?
    var email: String?
    var createdAt: String?
    var updatedAt: String?
    var __v: Int?
    var googleId: String?
    var friendsArr: [ProfileData]?
    
    enum CodingKeys: String, CodingKey {
        case dating
        case dob
        case gender
        case hometown
        case profileImg
        case aboutYourself
        case interestedInDate
        case loginType
        case status
        case _id
        case lname
        case drink
        case designation
        case notification
        case isEmailVerified
        case fname
        case isMobileVerified
        case username
        case password
        case phone
        case email
        case createdAt
        case updatedAt
        case __v
        case googleId
        case friendsArr
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dating = try? values.decodeIfPresent(DatingData.self, forKey: .dating)
        dob = try? values.decodeIfPresent(DobData.self, forKey: .dob)
        gender = try? values.decodeIfPresent(GenderData.self, forKey: .gender)
        hometown = try? values.decodeIfPresent(HometownData.self, forKey: .hometown)
        profileImg = try? values.decodeIfPresent(ProfileImgData.self, forKey: .profileImg)
        aboutYourself = try? values.decodeIfPresent(String.self, forKey: .aboutYourself)
        interestedInDate = try? values.decodeIfPresent(Bool.self, forKey: .interestedInDate)
        loginType = try? values.decodeIfPresent(String.self, forKey: .loginType)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        _id = try? values.decodeIfPresent(String.self, forKey: ._id)
        lname = try? values.decodeIfPresent(String.self, forKey: .lname)
        drink = try? values.decodeIfPresent(DrinkData.self, forKey: .drink)
        designation = try? values.decodeIfPresent(String.self, forKey: .designation)
        notification = try? values.decodeIfPresent(Bool.self, forKey: .notification)
        isEmailVerified = try? values.decodeIfPresent(Bool.self, forKey: .isEmailVerified)
        fname = try? values.decodeIfPresent(String.self, forKey: .fname)
        isMobileVerified = try? values.decodeIfPresent(Bool.self, forKey: .isMobileVerified)
        username = try? values.decodeIfPresent(String.self, forKey: .username)
        password = try? values.decodeIfPresent(String.self, forKey: .password)
        phone = try? values.decodeIfPresent(String.self, forKey: .phone)
        email = try? values.decodeIfPresent(String.self, forKey: .email)
        createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
        __v = try? values.decodeIfPresent(Int.self, forKey: .__v)
        googleId = try? values.decodeIfPresent(String.self, forKey: .googleId)
        friendsArr = try? values.decodeIfPresent([ProfileData].self, forKey: .friendsArr)
    }
}

struct DatingData: Codable {
    var privacy: String?
    var datings: String?
    
    enum CodingKeys: String, CodingKey {
        case privacy
        case datings
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        privacy = try? values.decodeIfPresent(String.self, forKey: .privacy)
        datings = try? values.decodeIfPresent(String.self, forKey: .datings)
    }
}

struct DobData: Codable {
    var privacy: String?
    var birthdate: String?
    
    enum CodingKeys: String, CodingKey {
        case privacy
        case birthdate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        privacy = try? values.decodeIfPresent(String.self, forKey: .privacy)
        birthdate = try? values.decodeIfPresent(String.self, forKey: .birthdate)
    }
}

struct GenderData: Codable {
    var privacy: String?
    var gen: String?
    
    enum CodingKeys: String, CodingKey {
        case privacy
        case gen
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        privacy = try? values.decodeIfPresent(String.self, forKey: .privacy)
        gen = try? values.decodeIfPresent(String.self, forKey: .gen)
    }
}

struct HometownData: Codable {
    var privacy: String?
    var homeTown: String?
    
    enum CodingKeys: String, CodingKey {
        case privacy
        case homeTown
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        privacy = try? values.decodeIfPresent(String.self, forKey: .privacy)
        homeTown = try? values.decodeIfPresent(String.self, forKey: .homeTown)
    }
}

struct ProfileImgData: Codable {
    var image: String?
    var privacy: String?
    
    enum CodingKeys: String, CodingKey {
        case image
        case privacy
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image = try? values.decodeIfPresent(String.self, forKey: .image)
        privacy = try? values.decodeIfPresent(String.self, forKey: .privacy)
    }
}

struct DrinkData: Codable {
    var status: String?
    var _id: String?
    var image: String?
    var drinkName: String?
    var createdAt: String?
    var updatedAt: String?
    var __v: Int?
    
    enum CodingKeys: String, CodingKey {
        case status
        case _id
        case image
        case drinkName
        case createdAt
        case updatedAt
        case __v
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        _id = try? values.decodeIfPresent(String.self, forKey: ._id)
        image = try? values.decodeIfPresent(String.self, forKey: .image)
        drinkName = try? values.decodeIfPresent(String.self, forKey: .drinkName)
        createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
        __v = try? values.decodeIfPresent(Int.self, forKey: .__v)
    }
}
