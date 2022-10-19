//
//  EventDetailViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 05/05/22.
//

import Foundation

class EventDetailViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    
    // MARK: - CUSTOM PROPERTIES
    var errorResponse: ErrorBaseModel?
    
    var eventDataResponse: EventDataResponse? {
        didSet { self.reloadListViewClosure?() }
    }
    
    var eventDetailsUserList: EventDetailsUserListModel? {
        didSet { self.reloadListViewClosure?() }
    }
    
    var deleteRoomResponse: SendOTPResponse? {
        didSet { self.redirectControllerClosure?() }
    }
    
    var addRecentSearchResponse: AddRecentSearchModel? {
        didSet { self.redirectControllerClosure1?() }
    }
    
    
    // MARK: - API METHODs
    func getRoom(params: [String:Any]) {
        self.isLoading = true
        userService.getRoom(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? EventDataResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.message
                    return
                }
                self.eventDataResponse = model
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let errorModel):
                self.errorMessage = errorModel.message
            }
        }
    }
    
    func deleteRoom(roomId: String) {
        self.isLoading = true
        userService.deleteRoom(roomId: roomId) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        self.deleteRoomResponse = model
                        /*if model.status == "SUCCESS" {
                            self.deleteRoomResponse = model
                        } else {
                            self.errorMessage = model.message
                        }*/
                    }
                case .error(let message):
                    self.errorMessage = message
                case .customError(let errorModel):
                    self.errorResponse = errorModel
                    self.errorMessage = errorModel.message
                }
            }
        }
    }
    
    func getUsersListWithRoomDetails(roomId: String) {
        self.isLoading = true
        userService.usersListWithRoomDetailsAPI(roomId: roomId) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? EventDetailsUserListModel {
                        if model.status == "SUCCESS" {
                            self.eventDetailsUserList = model
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
    
    func addRecentSearch(params: [String: Any]) {
//        self.isLoading = true
        userService.addRecentSearchAPI(params: params) { (result) in
            DispatchQueue.global(qos: .background).async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? AddRecentSearchModel {
                        if model.status == APIKeys.success {
                            self.addRecentSearchResponse = model
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
