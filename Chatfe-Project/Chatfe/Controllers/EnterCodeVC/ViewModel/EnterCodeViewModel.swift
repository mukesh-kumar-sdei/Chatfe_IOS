//
//  EnterCodeViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 25/04/22.
//

import Foundation
import UIKit

class EnterCodeViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    var enterCodeResponseModel: EnterCodeResponse?
    var enterCodeErrorResponse: ErrorBaseModel?
    
    var verifyOTPResponse: SendOTPResponse? {
        didSet {
            self.redirectControllerClosure?()
        }
    }
    
    func verifyPhone(phNo: String, otp: String) {
        let params = ["phone": phNo, "otp": otp] as [String: Any]
        self.isLoading = true
        userService.verifyPhone(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? EnterCodeResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.status
                    return
                }
                self.enterCodeResponseModel = model
                UserDefaultUtility.shared.saveMobileVerified(verify: true)
                self.redirectControllerClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
                UserDefaultUtility.shared.saveMobileVerified(verify: false)
            case .customError(let errorModel):
                self.enterCodeErrorResponse = errorModel
                self.redirectControllerClosure?()
            }
        }
    }
    
    func verifyEmail(email: String, otp: String) {
        let params = ["email": email, "otp": otp, "phone": ""] as [String: Any]
        self.isLoading = true
        userService.verfiyEmail(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? EnterCodeResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.status
                    return
                }
                self.enterCodeResponseModel = model
                UserDefaultUtility.shared.saveEmailVerified(verify: true)
                self.redirectControllerClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
                UserDefaultUtility.shared.saveEmailVerified(verify: false)
            case .customError(let errorModel):
                self.enterCodeErrorResponse = errorModel
                self.redirectControllerClosure?()
             break
            }
        }
    }
    
    func verifyForgotPasswordOTP(email: String, phone: String, otp: String) {
        self.isLoading = true
        userService.verifyForgotPasswordOTPAPI(email: email, phone: phone, otp: otp) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                if let model = data as? SendOTPResponse {
                    if model.status == "SUCCESS" {
                        self.verifyOTPResponse = model
                    } else {
                        self.errorMessage = model.message
                    }
                }
                break
            case .error(let message):
                self.errorMessage = message
                break
            case .customError(let error):
                self.errorMessage = error.message
                break
            }
        }
    }
}
