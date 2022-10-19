//
//  RegisterModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 26/04/22.
//

import Foundation

struct RegisterModel: Encodable {
    var dating: DatingModel?
    var designation: String?
    var dob: DobModel?
    var drink: String?
    var email: String?
    var fname: String?
    var gender: GenderModel?
    var hometown: HometownModel?
    var interesetedInDate: Bool?
    var username: String?
    var lname: String?
    var password: String?
    var phone: String?
    var profileImg: ProfileImageModel?
    var notification: String?
    var isEmailVerified: Bool?
    var isMobileVerfied: Bool?
    
    enum CodingKeys: String, CodingKey {
        case dating
        case designation
        case dob
        case drink
        case email
        case fname
        case gender
        case hometown
        case interestedInDate
        case username
        case lname
        case password
        case phone
        case profileImg
        case notification
        case isEmailVerified
        case isMobileVerified
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.dating, forKey: .dating)
        try container.encode(self.designation, forKey: .designation)
        try container.encode(self.dob, forKey: .dob)
        try container.encode(self.drink, forKey: .drink)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.fname, forKey: .fname)
        try container.encode(self.gender, forKey: .gender)
        try container.encode(self.hometown, forKey: .hometown)
        try container.encode(self.interesetedInDate, forKey: .interestedInDate)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.lname, forKey: .lname)
        try container.encode(self.password, forKey: .password)
        try container.encode(self.phone, forKey: .phone)
        try container.encode(self.profileImg, forKey: .profileImg)
        try container.encode(self.notification, forKey: .notification)
        try container.encode(self.isEmailVerified, forKey: .isEmailVerified)
        try container.encode(self.isMobileVerfied, forKey: .isMobileVerified)
    }
}

struct DatingModel: Codable {
    var datings: String?
    var privacy: String?
    
    enum CodingKeys: String, CodingKey {
        case datings
        case privacy
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.datings, forKey: .datings)
        try container.encode(self.privacy, forKey: .privacy)
    }
}

struct DobModel: Codable {
    var birthdate: String?
    var privacy: String?
    
    enum CodingKeys: String, CodingKey {
        case birthdate
        case privacy
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.birthdate, forKey: .birthdate)
        try container.encode(self.privacy, forKey: .privacy)
    }
}

struct GenderModel: Codable {
    var gen: String?
    var privacy: String?
    
    enum CodingKeys: String, CodingKey {
        case gen
        case privacy
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.gen, forKey: .gen)
        try container.encode(self.privacy, forKey: .privacy)
    }
}

struct HometownModel: Codable {
    var homeTown: String?
    var privacy: String?
    
    enum CodingKeys: String, CodingKey {
        case homeTown
        case privacy
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.homeTown, forKey: .homeTown)
        try container.encode(self.privacy, forKey: .privacy)
    }
}

struct ProfileImageModel: Codable {
    var image: String?
    var privacy: String?
    
    enum CodingKeys: String, CodingKey {
        case image
        case privacy
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.image, forKey: .image)
        try container.encode(self.privacy, forKey: .privacy)
    }
}


