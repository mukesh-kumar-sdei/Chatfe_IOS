//
//  ProfilePictureViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 01/06/22.
//

import Foundation

class ProfilePictureViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    var imageUploadResponse: ImageUploadResponse?
    
    func uploadProfilePic(params:[String:Any], files: [File]) {
        self.isLoading = true
        userService.uploadImage(params, files: files) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? ImageUploadResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.message
                    return
                }
                self.imageUploadResponse = model
                self.redirectControllerClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(_):
                break
            }
        }
    }
}
