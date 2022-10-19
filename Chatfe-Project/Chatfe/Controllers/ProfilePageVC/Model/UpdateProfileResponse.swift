//
//  UpdateProfileResponse.swift
//  Chatfe
//
//  Created by Piyush Mohan on 26/05/22.
//

import Foundation

struct UpdateProfileResponse: Decodable {
    var status: String?
    var code: Int?
    var data: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        code = try? values.decodeIfPresent(Int.self, forKey: .code)
        data = try? values.decodeIfPresent(String.self, forKey: .data)
    }
}
