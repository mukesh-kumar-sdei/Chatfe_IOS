//
//  AccountVisibilityVM.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 28/07/22.
//

import Foundation

class AccountVisibilityVM: BaseViewModel {
    
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    
    //MARK: - INSTANCES
    var getVisibilityResp: VisibilityModel? {
        didSet {
            self.reloadListViewClosure?()
        }
    }

    var updateVisibilityResp: SendOTPResponse? {
        didSet {
            self.redirectControllerClosure?()
        }
    }

    // MARK: - API METHODs
    func getVisibilityData() {
        self.isLoading = true
        userService.getVisibilityAPI { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? VisibilityModel {
                        if model.status == APIKeys.success {
                            self.getVisibilityResp = model
                        } else {
                            self.errorMessage = model.message
                        }
                    }
                case .error(let message):
                    self.errorMessage = message
                case .customError(let errorModel):
                    self.errorMessage = errorModel.message
                }
            }
        }
    }
    
    func updateVisibilityData(params: [String: Any]) {
        self.isLoading = true
        userService.updateVisibilityAPI(params: params) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == APIKeys.success {
                            self.updateVisibilityResp = model
                        } else {
                            self.errorMessage = model.message
                        }
                    }
                case .error(let message):
                    self.errorMessage = message
                case .customError(let errorModel):
                    self.errorMessage = errorModel.message
                }
            }
        }
    }
    
}
