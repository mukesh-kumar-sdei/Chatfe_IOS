//
//  ProfilePreviewVM.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 01/08/22.
//

import Foundation

class ProfilePreviewVM: BaseViewModel {
    
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    
    //MARK: - INSTANCES
    var matchPreferenceResp: MatchPrefData? {
        didSet {
            self.reloadListViewClosure?()
        }
    }

    var voteRemoveResp: SendOTPResponse? {
        didSet {
            self.reloadListViewClosure1?()
        }
    }
    
    var cancelVoteRemoveResp: SendOTPResponse? {
        didSet {
            self.reloadMenuClosure1?()
        }
    }
    
    var userProfileResp: GCUserProfileModel? {
        didSet {
            self.redirectControllerClosure?()
        }
    }

    // MARK: - API METHODs
    func postUserMatchPreferences(params: [String: Any]) {
        self.isLoading = true
        userService.matchPreferenceAPI(params: params) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? MatchPrefModel {
                        if model.status == APIKeys.success {
                            self.matchPreferenceResp = model.data
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

    func getUserMatchPreferences() {
        self.isLoading = true
        userService.getMatchPreferenceAPI { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? MatchPrefModel {
                        if model.status == APIKeys.success {
                            self.matchPreferenceResp = model.data
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
    
    func voteToRemoveAPI(params: [String: Any]) {
        self.isLoading = true
        userService.voteToRemoveAPI(params: params) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == APIKeys.success {
                            self.voteRemoveResp = model
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
    
    func cancelVoteToRemoveAPI(params: [String: Any]) {
        self.isLoading = true
        userService.cancelVoteToRemoveAPI(params: params) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == APIKeys.success {
                            self.cancelVoteRemoveResp = model
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
    
    func eventUserProfile(params: [String: Any]) {
        self.isLoading = true
        userService.eventChatMemberProfileAPI(params: params) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? GCUserProfileModel {
                        if model.status == APIKeys.success {
                            self.userProfileResp = model
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
