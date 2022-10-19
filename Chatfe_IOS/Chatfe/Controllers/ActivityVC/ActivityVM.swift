//
//  ActivityVM.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 04/09/22.
//

import Foundation

class ActivityVM: BaseViewModel {
    
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    
    //MARK: - INSTANCES
    var getActivityResp: ActivityModal? {
        didSet {
            self.reloadListViewClosure?()
        }
    }

    var updateActivityResp: ActivityModal? {
        didSet {
            self.redirectControllerClosure?()
        }
    }

    // MARK: - API METHODs
    
    func getActivityData() {
        self.isLoading = true
        userService.getActivityAPI { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? ActivityModal {
                        if model.status == APIKeys.success {
                            self.getActivityResp = model
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

    func updateActivityData(params: [String:Any]) {
        self.isLoading = true
        userService.updateActivityAPI(params: params) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? ActivityModal {
                        if model.status == APIKeys.success {
                            self.updateActivityResp = model
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
