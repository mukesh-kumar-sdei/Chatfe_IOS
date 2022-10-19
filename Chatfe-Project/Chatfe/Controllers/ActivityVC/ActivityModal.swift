//
//  ActivityModal.swift
//  Chatfe
//
//  Created by Chandani Barsagade on 05/09/22.
//

import Foundation

struct ActivityModal : Codable {
    let code : Int?
    let status : String?
    let data : ActivityData?
    let message : String?

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
        data = try values.decodeIfPresent(ActivityData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}

struct ActivityData : Codable {
    let activity : ActivityInfo?
    let _id: String?

    enum CodingKeys: String, CodingKey {

        case activity = "activity"
        case _id = "_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        activity = try values.decodeIfPresent(ActivityInfo.self, forKey: .activity)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        
    }

}

struct ActivityInfo : Codable {
    let birthday : Bool?
    let invites: Bool?
    let upcomingRooms: Bool?
    let friendsPublicRoom: Bool?

    enum CodingKeys: String, CodingKey {

        case birthday = "birthday"
        case invites = "invites"
        case upcomingRooms = "upcomingRooms"
        case friendsPublicRoom = "friendsPublicRoom"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        birthday = try values.decodeIfPresent(Bool.self, forKey: .birthday)
        invites = try values.decodeIfPresent(Bool.self, forKey: .invites)
        upcomingRooms = try values.decodeIfPresent(Bool.self, forKey: .upcomingRooms)
        friendsPublicRoom = try values.decodeIfPresent(Bool.self, forKey: .friendsPublicRoom)
        
    }

}
