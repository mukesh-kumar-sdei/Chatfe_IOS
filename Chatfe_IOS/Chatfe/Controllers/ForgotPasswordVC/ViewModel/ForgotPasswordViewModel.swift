//
//  ForgotPasswordViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 18/05/22.
//

import Foundation
import UIKit

class ForgotPasswordViewModel: BaseViewModel {
    
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    
    var OTPResponse: SendOTPResponse? {
        didSet {
            self.redirectControllerClosure?()
        }
    }
    
    
    // MARK: - APIs
    func forgotPswrdPhoneSendOTPAPI(phone: String) {
        self.isLoading = true
        userService.forgotPasswordPhoneSendOTP(phoneNumber: phone) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == "SUCCESS" {
                            self.OTPResponse = model
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
    
    func forgotPswrdEmailSendOTPAPI(email: String) {
        self.isLoading = true
        userService.forgotPasswordEmailSendOTP(emailId: email) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == "SUCCESS" {
                            self.OTPResponse = model
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
    
    
}
