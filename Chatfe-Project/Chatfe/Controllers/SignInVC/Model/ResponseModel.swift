//
//  ResponseModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 28/04/22.
//

import Foundation

struct GoogleLoginResponse: Decodable {
    var status: String?
    var code: Int?
    var data: GoogleResponse?
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        code = try? values.decodeIfPresent(Int.self, forKey: .code)
        data = try? values.decodeIfPresent(GoogleResponse.self, forKey: .data)
    }
}

struct GoogleResponse: Decodable {
    var id: String?
    let fname: String?
    var lname: String?
    var email: String?
    var username: String?
    var loginType: String?
    var designation: String?
    var accessToken: String?
    var profileImg: ProfileImgData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fname
        case lname
        case email
        case username
        case loginType
        case designation
        case accessToken
        case profileImg
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decodeIfPresent(String.self, forKey: .id)
        fname = try? values.decodeIfPresent(String.self, forKey: .fname)
        lname = try? values.decodeIfPresent(String.self, forKey: .lname)
        email = try? values.decodeIfPresent(String.self, forKey: .email)
        username = try? values.decodeIfPresent(String.self, forKey: .username)
        loginType = try? values.decodeIfPresent(String.self, forKey: .loginType)
        designation = try? values.decodeIfPresent(String.self, forKey: .designation)
        accessToken = try? values.decodeIfPresent(String.self, forKey: .accessToken)
        profileImg = try? values.decodeIfPresent(ProfileImgData.self, forKey: .profileImg)
    }
}

struct FacebookLoginResponse: Decodable {
    var status: String?
    var code: Int?
    var data: FacebookResponse?
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        code = try? values.decodeIfPresent(Int.self, forKey: .code)
        data = try? values.decodeIfPresent(FacebookResponse.self, forKey: .data)
    }
}

struct FacebookResponse: Decodable {
    var id: String?
    var fname: String?
    var lname: String?
    var email: String?
    var username: String?
    var loginType: String?
    var designation: String?
    var accessToken: String?
    var profileImg: ProfileImgData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fname
        case lname
        case email
        case username
        case loginType
        case designation
        case accessToken
        case profileImg
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decodeIfPresent(String.self, forKey: .id)
        fname = try? values.decodeIfPresent(String.self, forKey: .fname)
        lname = try? values.decodeIfPresent(String.self, forKey: .lname)
        email = try? values.decodeIfPresent(String.self, forKey: .email)
        username = try? values.decodeIfPresent(String.self, forKey: .username)
        loginType = try? values.decodeIfPresent(String.self, forKey: .loginType)
        designation = try? values.decodeIfPresent(String.self, forKey: .designation)
        accessToken = try? values.decodeIfPresent(String.self, forKey: .accessToken)
        profileImg = try? values.decodeIfPresent(ProfileImgData.self, forKey: .profileImg)
    }
}

struct LoginResponse: Decodable {
    var status: String?
    var code: Int?
    var data: LoginData?
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
        data = try? values.decodeIfPresent(LoginData.self, forKey: .data)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
    }
}

struct LoginData: Decodable {
    var id: String?
    var email: String?
    let username: String?
    var designation: String?
    var fname: String?
    var lname: String?
    var phone: String?
    var accessToken: String?
    var profileImg: ProfileImgData?
    var loginType: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case username
        case designation
        case fname
        case lname
        case phone
        case accessToken
        case profileImg
        case loginType
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decodeIfPresent(String.self, forKey: .id)
        email = try? values.decodeIfPresent(String.self, forKey: .email)
        username = try? values.decodeIfPresent(String.self, forKey: .username)
        designation = try? values.decodeIfPresent(String.self, forKey: .designation)
        fname = try? values.decodeIfPresent(String.self, forKey: .fname)
        lname = try? values.decodeIfPresent(String.self, forKey: .lname)
        phone = try? values.decodeIfPresent(String.self, forKey: .phone)
        accessToken = try? values.decodeIfPresent(String.self, forKey: .accessToken)
        profileImg = try? values.decodeIfPresent(ProfileImgData.self, forKey: .profileImg)
        loginType = try? values.decodeIfPresent(String.self, forKey: .loginType)
    }
}


struct AppleLoginResponse: Decodable {
    var status: String?
    var code: Int?
    var data: AppleResponse?
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
        data = try? values.decodeIfPresent(AppleResponse.self, forKey: .data)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
    }
}

struct AppleResponse: Decodable {
    var id: String?
    var fname: String?
    var lname: String?
    var email: String?
    var username: String?
    var accessToken: String?
    var loginType: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fname
        case lname
        case email
        case username
        case accessToken
        case loginType
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decodeIfPresent(String.self, forKey: .id)
        fname = try? values.decodeIfPresent(String.self, forKey: .fname)
        lname = try? values.decodeIfPresent(String.self, forKey: .lname)
        email = try? values.decodeIfPresent(String.self, forKey: .email)
        username = try? values.decodeIfPresent(String.self, forKey: .username)
        accessToken = try? values.decodeIfPresent(String.self, forKey: .accessToken)
        loginType = try? values.decodeIfPresent(String.self, forKey: .loginType)
    }
}
