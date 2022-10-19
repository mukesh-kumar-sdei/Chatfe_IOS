//
//  ChangePasswordViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 18/05/22.
//

import Foundation

class ChangePasswordViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    var resetPasswordResponse: ResetPasswordResponse?
    var resetPasswordErrorResponse: ErrorBaseModel?
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func resetPassword(params: [String:Any]) {
        self.isLoading = true
        userService.resetPassword(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? ResetPasswordResponse else {
                    return
                }
                if model.status != APIKeys.success {
                    self.isSuccess = false
                    self.errorMessage = model.status
                    return
                }
                self.resetPasswordResponse = model
                self.redirectControllerClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let errorModel):
                self.resetPasswordErrorResponse = errorModel
                self.redirectControllerClosure?()
            }
        }
    }
}
