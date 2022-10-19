//
//  NotificationsViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 26/04/22.
//

import Foundation

class NotificationsViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    var registerResponseModel: RegisterResponseModel?
    var registerErrorResponse: ErrorBaseModel?
    
    func registerUser(params: [String: Any], doc: [File]?) {
        self.isLoading = true
        userService.registerUser(params, fileData: doc) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? RegisterResponseModel else { return }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.message
                    return
                }
                self.registerResponseModel = model
                self.redirectControllerClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let errorModel):
                guard let model = errorModel as? ErrorBaseModel else {
                    return
                }
                self.registerErrorResponse = model
                self.redirectControllerClosure?()
            }
        }
    }
}
