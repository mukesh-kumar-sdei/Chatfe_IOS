//
//  ErrorBase.swift
//  Chatfe
//
//  Created by Piyush Mohan on 05/04/22.
//

import Foundation

struct ErrorBase: Codable {
    let message: ErrorMessageBase?
    
    enum CodingKeys: String, CodingKey {
        case message
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(ErrorMessageBase.self, forKey: .message)
    }
}

struct ErrorMessageBase: Codable {
    let message: [String]?
    
    enum CodingKeys: String, CodingKey {
        case message
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent([String].self, forKey: .message)
    }
}

struct ErrorBaseModel: Codable {
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
