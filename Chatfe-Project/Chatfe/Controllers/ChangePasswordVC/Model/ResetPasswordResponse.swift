//
//  ResetPasswordResponse.swift
//  Chatfe
//
//  Created by Piyush Mohan on 18/05/22.
//

import Foundation

struct ResetPasswordResponse: Decodable {
    var status: String?
    var code: Int?
    var data: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try? container.decodeIfPresent(String.self, forKey: .status)
        code = try? container.decodeIfPresent(Int.self, forKey: .code)
        data = try? container.decodeIfPresent(String.self, forKey: .data)
    }
}


