//
//  ProfilePageViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 12/05/22.
//

import Foundation

class ProfilePageViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    var profileResponse: GetProfileResponse? {
        didSet {
            self.reloadListViewClosure?()
        }
    }
    var profileErrorResponse: ErrorBaseModel?
    var favouriteDrinkResponse: FavouriteDrinkResponse?
    var updateProfileResponse: UpdateProfileResponse?
    var updateProfileErrorResponse: ErrorBaseModel?
    var imageUploadResponse: ImageUploadResponse? {
        didSet {
            self.redirectControllerClosure?()
        }
    }
    
    func getProfile(params: [String:Any]) {
        self.isLoading = true
        userService.getProfile(params) { (result) in
            self.isLoading = false
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let model = data as? GetProfileResponse {
                        /*if model.status == APIKeys.success {
                            self.profileResponse = model
                        } else {
                            self.errorMessage = model.message
                        }*/
                        self.profileResponse = model
                    }
                    /*guard let model = data as? GetProfileResponse else {
                        return
                    }
                    if model.status != "SUCCESS" {
                        self.isSuccess = false
                        self.errorMessage = model.status
                        return
                    }
                    self.profileResponse = model
    //                debugPrint("I am ", self.profileResponse)
                    self.reloadListViewClosure?()*/
                case .error(let message):
    //                self.isSuccess = false
                    self.errorMessage = message
                case .customError(let errorModel):
                    self.errorMessage = errorModel.message
                    /*guard let model = errorModel as? ErrorBaseModel else {
                        return
                    }
                    self.profileErrorResponse = model
                    self.redirectControllerClosure?()*/
                }
            }
        }
    }
    
    func getDrinks(params: [String:Any]) {
        self.isLoading = true
        userService.getAllDrinks(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? FavouriteDrinkResponse else {
                    return
                }
                self.favouriteDrinkResponse = model
                self.reloadListViewClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(_):
                break
            }
        }
    }
    
    func updateProfile(params: [String:Any]) {
        self.isLoading = true
        userService.updateProfile(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? UpdateProfileResponse else {
                    return
                }
                self.updateProfileResponse = model
                self.reloadListViewClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let errorModel):
                self.updateProfileErrorResponse = errorModel
                self.reloadListViewClosure?()
            }
        }
    }
    
    func uploadProfilePic(params:[String:Any], files: [File]) {
        self.isLoading = true
        userService.uploadImage(params, files: files) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? ImageUploadResponse else {
                    return
                }
                /*if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.message
                    return
                }*/
                
                if model.status == APIKeys.success {
                    self.imageUploadResponse = model
                } else {
                    self.errorMessage = model.message
                }
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(_):
                break
            }
        }
    }
}
