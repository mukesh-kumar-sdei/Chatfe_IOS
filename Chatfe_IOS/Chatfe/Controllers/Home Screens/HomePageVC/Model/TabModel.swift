//
//  TabModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 28/04/22.
//

import Foundation

struct TabBarVM: Equatable {
    let tabs: [String]
    let selectedTab: Int
    
    func shouldReload(from oldModel: Self?) -> Bool {
        return self.tabs != oldModel?.tabs || self.selectedTab != oldModel?.selectedTab
    }
}

struct RoomsResponse: Codable {
    var status: String?
    var code: Int?
    var data: [RoomData]?
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
        data = try? values.decodeIfPresent([RoomData].self, forKey: .data)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
    }
}

struct RoomData: Codable {
    var _id: String?
    var image: String?
    var categoryId: String?
    var roomName: String?
//    var date: String?
//    var startTime: String?
//    var endTime: String?
    var duration: Double?
    var about: String?
    var roomType: String?
    var createdAt: String?
    var updatedAt: String?
    var hasRoomJoined: Bool?
    var roomClass: String?
    var createdBy: String?
    var startDate: String?
    var endDate: String?
    var __v: Int?
    var friendsArr: [FriendsData]?
    var emails: String?
    var userData: [SenderIdData]?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case image
        case categoryId
        case roomName
//        case date
//        case startTime
//        case endTime
        case duration
        case about
        case roomType
        case createdAt
        case updatedAt
        case hasRoomJoined
        case roomClass
        case createdBy
        case startDate
        case endDate
        case __v
        case friendsArr
        case emails = "mails"
        case userData
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try? values.decodeIfPresent(String.self, forKey: ._id)
        image = try? values.decodeIfPresent(String.self, forKey: .image)
        categoryId = try? values.decodeIfPresent(String.self, forKey: .categoryId)
        roomName = try? values.decodeIfPresent(String.self, forKey: .roomName)
//        date = try? values.decodeIfPresent(String.self, forKey: .date)
//        startTime = try? values.decodeIfPresent(String.self, forKey: .startTime)
//        endTime = try? values.decodeIfPresent(String.self, forKey: .endTime)
        duration = try? values.decodeIfPresent(Double.self, forKey: .duration)
        about = try? values.decodeIfPresent(String.self, forKey: .about)
        roomType = try? values.decodeIfPresent(String.self, forKey: .roomType)
        createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
        hasRoomJoined = try? values.decodeIfPresent(Bool.self, forKey: .hasRoomJoined)
        roomClass = try? values.decodeIfPresent(String.self, forKey: .roomClass)
        createdBy = try? values.decodeIfPresent(String.self, forKey: .createdBy)
        startDate = try? values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try? values.decodeIfPresent(String.self, forKey: .endDate)
        __v = try? values.decodeIfPresent(Int.self, forKey: .__v)
        friendsArr = try? values.decodeIfPresent([FriendsData].self, forKey: .friendsArr)
        emails = try? values.decodeIfPresent(String.self, forKey: .emails)
        userData = try? values.decodeIfPresent([SenderIdData].self, forKey: .userData)
    }
}

struct CategoriesResponse: Codable {
    var status: String?
    var code: Int?
    var data: [CategoriesData]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent( String.self, forKey: .status)
        code = try? values.decodeIfPresent(Int.self, forKey: .code)
        data = try? values.decodeIfPresent([CategoriesData].self, forKey: .data)
    }
}

struct CategoriesData: Codable {
    var status: String?
    var _id: String?
    var title: String?
    var createdAt: String?
    var updatedAt: String?
    var __v: Int?
    
    enum CodingKeys: String, CodingKey {
        case status
        case _id
        case title
        case createdAt
        case updatedAt
        case __v
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        _id = try? values.decodeIfPresent(String.self, forKey: ._id)
        title = try? values.decodeIfPresent(String.self, forKey: .title)
        createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
        __v = try? values.decodeIfPresent(Int.self, forKey: .__v)
    }
}


struct FriendsData: Codable {
    var _id: String?
    var fname: String?
    var lname: String?
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case fname
        case lname
        case image
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try? values.decodeIfPresent(String.self, forKey: ._id)
        fname = try? values.decodeIfPresent(String.self, forKey: .fname)
        lname = try? values.decodeIfPresent(String.self, forKey: .lname)
        image = try? values.decodeIfPresent(String.self, forKey: .image)
    }
}
