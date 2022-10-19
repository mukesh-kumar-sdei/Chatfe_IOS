//
//  UserDetailsVM.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 08/06/22.
//

import Foundation

class UserDetailsVM: BaseViewModel {
    
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    var phoneEmailResponse: SendOTPResponse? {
        didSet {
            self.redirectControllerClosure?()
        }
    }
    
    
    // MARK: - APIs
    
    func checkPhoneOrEmail(phone: String, email: String) {
        self.isLoading = true
        userService.checkPhoneAndEmailAPI(phone: phone, email: email) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == "SUCCESS" {
                            self.phoneEmailResponse = model
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
