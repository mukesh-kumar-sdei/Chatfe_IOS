//
//  BlockListVM.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 26/07/22.
//

import Foundation

class BlockListVM: BaseViewModel {
    
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    // PROPERTIES
    var unblockUserResp: SendOTPResponse? {
        didSet {
            self.reloadListViewClosure?()
        }
    }
    
    var getBlockListResp: GetBlockListModel? {
        didSet {
            self.redirectControllerClosure?()
        }
    }
    var errorResponse: ErrorBaseModel?
    
    
    // API METHODs
    func getblockUserList() {
        self.isLoading = true
        userService.getBlockListAPI { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? GetBlockListModel {
                        if model.status == APIKeys.success {
                            self.getBlockListResp = model
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
    
    func unblockUser(id: String) {
        self.isLoading = true
        userService.unblockUserAPI(Id: id) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == APIKeys.success {
                            self.unblockUserResp = model
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
