//
//  RegisterResponseModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 26/04/22.
//

import Foundation

struct RegisterResponseModel: Decodable {
    var status: String?
    var code: Int?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try? container.decodeIfPresent(String.self, forKey: .status)
        code = try? container.decodeIfPresent(Int.self, forKey: .code)
        message = try? container.decodeIfPresent(String.self, forKey: .message)
    }
}
