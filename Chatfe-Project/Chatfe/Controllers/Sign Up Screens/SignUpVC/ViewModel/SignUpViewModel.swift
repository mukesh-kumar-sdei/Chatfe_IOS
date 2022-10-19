//
//  SignUpViewModel.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 07/06/22.
//

import Foundation


class SignUpViewModel: BaseViewModel {
    
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    var usernameResponse: SendOTPResponse? {
        didSet {
            self.redirectControllerClosure?()
        }
    }
    
    
    // MARK: - APIs
    
    func checkUsername(username: String) {
        self.isLoading = true
        userService.checkUsernameAPI(username: username) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == "SUCCESS" {
                            self.usernameResponse = model
                        } else {
                            self.errorMessage = model.message
                        }
                    }
                case .error(let message):
                    self.errorMessage = message
                case .customError(let model):
                    self.errorMessage = model.message
                }
            }
        }
    }
}
