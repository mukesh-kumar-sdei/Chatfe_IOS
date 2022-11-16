//
//  SignInViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import Foundation

class SignInViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    var googleLoginResponse: GoogleLoginResponse?
    var facebookLoginResponse: FacebookLoginResponse?
    var appleLoginResponse: AppleLoginResponse?
    var loginResponse: LoginResponse?
    
    
    // MARK: - API METHODs
    func loginByGoogle(params: [String:Any]) {
        let params = params
        self.isLoading = true
        userService.loginByGoogle(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? GoogleLoginResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.status
                    return
                }
                self.googleLoginResponse = model
                if let token = self.googleLoginResponse?.data?.accessToken {
                    UserDefaultUtility.shared.saveAccessToken(token: token)
                }
                if let id = model.data?.id {
                    UserDefaultUtility.shared.saveUserId(userId: id)
                    AppInstance.shared.userId = id
                }
                if let username = self.googleLoginResponse?.data?.username {
                    UserDefaultUtility.shared.saveUsername(name: username)
                }
                
                if let loginType = self.googleLoginResponse?.data?.loginType {
                    UserDefaultUtility.shared.saveLoginType(type: loginType)
                }
                
                if let strImage = self.googleLoginResponse?.data?.profileImg?.image {
                    if let imageURL = NSURL(string: strImage) {
                        UserDefaultUtility.shared.saveProfileImageURL(url: imageURL)
                    }
                }
                self.redirectControllerClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(_):
                break
            }
        }
    }
    
    /// FACEBOOK LOGIN API
    func loginByFacebook(params: [String:Any]) {
        self.isLoading = true
        userService.loginByFacebook(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? FacebookLoginResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.status
                    return
                }
                self.facebookLoginResponse = model
                if let token = model.data?.accessToken {
                    UserDefaultUtility.shared.saveAccessToken(token: token)
                }
                if let id = model.data?.id {
                    UserDefaultUtility.shared.saveUserId(userId: id)
                    AppInstance.shared.userId = id
                }
                if let username = model.data?.username {
                    UserDefaultUtility.shared.saveUsername(name: username)
                }
                if let loginType = model.data?.loginType {
                    UserDefaultUtility.shared.saveLoginType(type: loginType)
                }
                if let fname = model.data?.fname, let lname = model.data?.lname {
                    UserDefaultUtility.shared.saveFullName(name: "\(fname) \(lname)")
                }
                if let strImage = model.data?.profileImg?.image {
                    if let imageURL = NSURL(string: strImage) {
                        UserDefaultUtility.shared.saveProfileImageURL(url: imageURL)
                    }
                }
                self.redirectControllerClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(_):
                break
            }
        }
    }
    
    func loginByApple(params: [String:Any]) {
        self.isLoading = true
        userService.loginByApple(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? AppleLoginResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.message
                    return
                }
                
                self.appleLoginResponse = model
                if let token = model.data?.accessToken {
                    UserDefaultUtility.shared.saveAccessToken(token: token)
                }
                if let id = model.data?.id {
                    UserDefaultUtility.shared.saveUserId(userId: id)
                    AppInstance.shared.userId = id
                }
                if let username = model.data?.username {
                    UserDefaultUtility.shared.saveUsername(name: username)
                }
                if let loginType = model.data?.loginType {
                    UserDefaultUtility.shared.saveLoginType(type: loginType)
                }
                if let fname = model.data?.fname, let lname = model.data?.lname {
                    UserDefaultUtility.shared.saveFullName(name: "\(fname) \(lname)")
                }
                self.redirectControllerClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(_):
                break
            }
        }
    }
    
    func login(params: [String:Any]) {
        self.isLoading = true
        userService.login(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? LoginResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.message
                    return
                }
                self.loginResponse = model
                if let token = model.data?.accessToken {
                    UserDefaultUtility.shared.saveAccessToken(token: token)
                }
                if let id = model.data?.id {
                    UserDefaultUtility.shared.saveUserId(userId: id)
                    AppInstance.shared.userId = id
                }
                if let username = model.data?.username {
                    UserDefaultUtility.shared.saveUsername(name: username)
                }

                if let loginType = model.data?.loginType {
                    UserDefaultUtility.shared.saveLoginType(type: loginType)
                }
                
                if let strImage = model.data?.profileImg?.image {
//                    UserDefaultUtility.shared.saveProfileImageURL(strURL: image)
                    if let imageURL = NSURL(string: strImage) {
                        UserDefaultUtility.shared.saveProfileImageURL(url: imageURL)
                    }
                }
                self.redirectControllerClosure?()
            case .error(let message):
                print("message",message)
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let modal):
                self.errorMessage = modal.message
                break
            }
        }
    }
}
