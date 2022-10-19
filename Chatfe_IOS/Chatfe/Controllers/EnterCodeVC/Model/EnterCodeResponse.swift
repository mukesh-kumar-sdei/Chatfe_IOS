//
//  EnterCodeResponse.swift
//  Chatfe
//
//  Created by Piyush Mohan on 25/04/22.
//

import Foundation
enum Response: Decodable {
    case success(EnterCodeResponse)
    case failure(EnterCodeErrorResponse)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let codeResponse = try container.decode(EnterCodeResponse.self)
            self = .success(codeResponse)
        } catch DecodingError.typeMismatch {
            let errorData = try container.decode(EnterCodeErrorResponse.self)
            self = .failure(errorData)
        }
    }
}

struct EnterCodeResponse: Decodable {
    var status: String
    var code: Int
    var data: String?
    
   
   
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case data
        
    
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(String.self, forKey: .status)
        code = try values.decode(Int.self, forKey: .code)
        data = try? values.decode(String.self, forKey: .data)
        
        
    }
}

struct EnterCodeErrorResponse: Decodable {
    var status: String?
    var code: Int?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case message
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        code = try? values.decodeIfPresent(Int.self, forKey: .code)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
    }
}
