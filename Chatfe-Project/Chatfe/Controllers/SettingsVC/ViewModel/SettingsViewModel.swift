//
//  SettingsViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 13/05/22.
//

import Foundation

class SettingsViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    var logoutResponse: LogoutResponse?
    var logoutErrorResponse: ErrorBaseModel?
    var deleteAccountResponse: deleteAccountResponse?
    var deleteAccountErrorResponse: ErrorBaseModel?
    
    var joinRoomResponse: JoinRoomResponse? {
        didSet {
            self.reloadMenuClosure?()
        }
    }
    
    func logout(params: [String:Any]) {
        self.isLoading = true
        userService.logout(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? LogoutResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.message
                    return
                }
                self.logoutResponse = model
                UserDefaultUtility.shared.removeFullName()
                UserDefaultUtility.shared.removeProfileImage()
                self.reloadListViewClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let errorModel):
//                self.errorMessage = model.message
                self.logoutErrorResponse = errorModel
                self.reloadListViewClosure?()
            }
        }
    }
    
    func deleteAccount(params: [String:Any]) {
        self.isLoading = true
        userService.deleteAccount(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? deleteAccountResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.message
                    return
                }
                self.deleteAccountResponse = model
                UserDefaultUtility.shared.removeFullName()
                UserDefaultUtility.shared.removeProfileImage()
                self.reloadListViewClosure1?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let errorModel):
//                self.errorMessage = model.message
                self.deleteAccountErrorResponse = errorModel
                self.reloadListViewClosure1?()
            }
        }
    }
}
