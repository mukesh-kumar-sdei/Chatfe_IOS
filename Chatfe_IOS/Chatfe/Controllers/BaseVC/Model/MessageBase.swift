//
//  MessageBase.swift
//  Chatfe
//
//  Created by Piyush Mohan on 21/04/22.
//

import Foundation

struct MessageBase: Codable {
    var status: Bool? = true
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

struct SuccessMessageBase: Codable {
    var code: Int?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try? values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try? values.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}

struct VerifyTempPassBase: Codable {
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case token
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
}
