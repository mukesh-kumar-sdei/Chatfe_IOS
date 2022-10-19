//
//  JoinRoomModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 27/05/22.
//

import Foundation

struct JoinRoomResponse: Decodable {
    var status: String?
    var code: Int?
    var data: JoinRoomData?
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
        data = try? values.decodeIfPresent(JoinRoomData.self, forKey: .data)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
    }
}

struct JoinRoomData: Decodable {
    var status: String?
    var _id: String?
    var roomId: JoinedRoomData?
    var userId: String?
    var createdAt: String?
    var updatedAt: String?
    var __v: Int?
    
    enum CodingKeys: String, CodingKey {
        case status
        case _id
        case roomId
        case userId
        case createdAt
        case updatedAt
        case __v
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        _id = try? values.decodeIfPresent(String.self, forKey: ._id)
        roomId = try? values.decodeIfPresent(JoinedRoomData.self, forKey: .roomId)
        userId = try? values.decodeIfPresent(String.self, forKey: .userId)
        createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
        __v = try? values.decodeIfPresent(Int.self, forKey: .__v)
    }
}

struct JoinedRoomData: Decodable {
    var status: String?
    var _id: String?
    var about: String?
    var categoryId: String?
//    var date: String?
    var duration: Double?
    var image: String?
    var roomName: String?
    var roomType: String?
//    var startTime: String?
    var startDate: String?
    var endDate: String?
    var createdAt: String?
    var updatedAt: String?
    var __v: Int?
    
    enum CodingKeys: String, CodingKey {
        case status
        case _id
        case about
        case categoryId
//        case date
        case duration
        case image
        case roomName
        case roomType
//        case startTime
        case startDate
        case endDate
        case createdAt
        case updatedAt
        case __v
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        _id = try? values.decodeIfPresent(String.self, forKey: ._id)
        about = try? values.decodeIfPresent(String.self, forKey: .about)
        categoryId = try? values.decodeIfPresent(String.self, forKey: .categoryId)
//        date = try? values.decodeIfPresent(String.self, forKey: .date)
        duration = try? values.decodeIfPresent(Double.self, forKey: .duration)
        image = try? values.decodeIfPresent(String.self, forKey: .image)
        roomName = try? values.decodeIfPresent(String.self, forKey: .roomName)
        roomType = try? values.decodeIfPresent(String.self, forKey: .roomType)
//        startTime = try? values.decodeIfPresent(String.self, forKey: .startTime)
        startDate = try? values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try? values.decodeIfPresent(String.self, forKey: .endDate)
        createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
        __v = try? values.decodeIfPresent(Int.self, forKey: .__v)
    }
}
