//
//  UserTypingModel.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 15/07/22.
//

import Foundation

struct UserTypingModel : Codable {

    let isTyping : Bool?
    let chatHeadId : String?
    let senderId : String?
    let receiverId : String?


    enum CodingKeys: String, CodingKey {

        case isTyping = "isTyping"
        case chatHeadId = "chatHeadId"
        case senderId = "senderId"
        case receiverId = "receiverId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isTyping = try values.decodeIfPresent(Bool.self, forKey: .isTyping)
        chatHeadId = try values.decodeIfPresent(String.self, forKey: .chatHeadId)
        senderId = try values.decodeIfPresent(String.self, forKey: .senderId)
        receiverId = try values.decodeIfPresent(String.self, forKey: .receiverId)
    }

}


struct UserTypingGCModel : Codable {

    let isTyping : Bool?
    let channelId : String?
    let senderId : String?


    enum CodingKeys: String, CodingKey {

        case isTyping = "isTyping"
        case channelId = "channelId"
        case senderId = "senderId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isTyping = try values.decodeIfPresent(Bool.self, forKey: .isTyping)
        channelId = try values.decodeIfPresent(String.self, forKey: .channelId)
        senderId = try values.decodeIfPresent(String.self, forKey: .senderId)
    }

}


struct UserOnlineModel : Codable {

    let userId : String?
    let isOnline : Bool?
    
    enum CodingKeys: String, CodingKey {

        case userId = "userId"
        case isOnline = "isOnline"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        isOnline = try values.decodeIfPresent(Bool.self, forKey: .isOnline)
    }

}
