//
//  CreatePublicRoomViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 03/05/22.
//

import Foundation

class CreatePublicRoomViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    var addRoomResponse: AddRoomResponse? {
        didSet {
            self.redirectControllerClosure?()
        }
    }
    var imageUploadResponse: ImageUploadResponse?
    var addRoomErrorResponse: ErrorBaseModel?
    
    var friendsList: AllFriendsListModel? {
        didSet {
            self.reloadMenuClosure?()
        }
    }
    
    var updateRoomResponse: SendOTPResponse? {
        didSet {
            self.redirectControllerClosure1?()
        }
    }
    
    var suggestionsList: [SearchGetMovieData]? {
        didSet {
            self.reloadMenuClosure1?()
        }
    }
    
    
    func addRoom(params: [String:Any]) {
        self.isLoading = true
        userService.addRoom(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? AddRoomResponse else { return }
                
                if model.status == APIKeys.success {
                    self.addRoomResponse = model
                } else {
                    self.errorMessage = model.message
                }
                /*if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.message
                    return
                }
                self.addRoomResponse = model
                self.redirectControllerClosure?()*/
            case .error(let message):
                self.errorMessage = message
            case .customError(let errorModel):
                self.errorMessage = errorModel.message
                /*guard let model = errorModel as? ErrorBaseModel else {
                    return
                }
                self.addRoomErrorResponse = model
                self.redirectControllerClosure?()*/
            }
        }
    }
    
    func updateRoom(params: [String: Any]) {
        self.isLoading = true
        userService.updateRoom(params: params) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == "SUCCESS" {
                            self.updateRoomResponse = model
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
    
    func uploadImage(params: [String: Any], files: [File]) {
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
                UserDefaultUtility.shared.saveRoomImageUrl(url: model.files?.first ?? "")
                self.reloadListViewClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(_):
                break
            }
        }
    }
    
    func getAllFriendsList() {
        self.isLoading = true
        userService.getFriendsList { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? AllFriendsListModel {
                        if model.status == "SUCCESS" {
                            self.friendsList = model
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
    
    func getMovieSuggestions(searchText: String) {
//        self.isLoading = true
        userService.getMovieSuggestions(searchText: searchText) { (result) in
//            DispatchQueue.main.async {
            DispatchQueue.global(qos: .background).async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? GetMovieModel {
                        if model.status == "SUCCESS" {
                            self.suggestionsList = model.data?.search
                        } /*else {
                            self.errorMessage = model.message
                        }*/
                    }
                case .error(let message):
//                    self.errorMessage = message
                    debugPrint(message)
                case .customError(let model):
//                    self.errorMessage = model.message
                    debugPrint(model.message as Any)
                }
            }
        }
    }
    
}
