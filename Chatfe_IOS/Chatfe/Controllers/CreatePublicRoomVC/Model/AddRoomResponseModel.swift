//
//  AddRoomResponseModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 03/05/22.
//

import Foundation

struct AddRoomResponse: Decodable {
    var status: String?
    var code: Int?
//    var data: String?
    var data: RoomData?
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
//        data = try? values.decodeIfPresent(String.self, forKey: .data)
        data = try? values.decodeIfPresent(RoomData.self, forKey: .data)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
    }
}
