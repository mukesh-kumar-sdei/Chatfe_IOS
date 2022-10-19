//
//  ImageUploadModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 11/05/22.
//

import Foundation

struct ImageUploadResponse: Decodable {
    var status: String?
    var files: [String]?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case files
        case message
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        files = try? values.decodeIfPresent([String].self, forKey: .files)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
    }
}
