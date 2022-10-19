//
//  SendOTPViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import Foundation

class SendOTPViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    var sendOTPResponseModel: SendOTPResponse?
    
    func sendOTP(key: String, values: String) {
        let params = ["\(key)": values] as [String : Any]
        self.isLoading = true
        userService.sendOTP(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? SendOTPResponse else { return }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.message
                    return
                }
                self.sendOTPResponseModel = model
                self.redirectControllerClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
                
            case .customError(_):
                break
            }
        }
    }
    
    func sendEmail(key: String, values: String) {
        let params = ["\(key)": values, "phone": ""] as [String: Any]
        self.isLoading = true
        userService.sendEmail(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? SendOTPResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.data
                    return
                }
                self.sendOTPResponseModel = model
                self.redirectControllerClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(_):
                break
            }
        }
    }
}
