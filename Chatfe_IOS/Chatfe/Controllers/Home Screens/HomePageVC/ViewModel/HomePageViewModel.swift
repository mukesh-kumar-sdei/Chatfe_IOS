//
//  HomePageViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 28/04/22.
//

import Foundation

class HomePageViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    var roomResponse: RoomsResponse?
    var roomErrorResponse: ErrorBaseModel?
    var categoriesResponse: CategoriesResponse?
    
    var joinRoomResponse: JoinRoomResponse? {
        didSet {
            self.reloadMenuClosure?()
        }
    }
    var unjoinRoomResponse: SendOTPResponse? {
        didSet {
            self.redirectControllerClosure1?()
        }
    }
    
    var getJoinedRoomsResp: RoomJoinedModel? {
        didSet {
            self.reloadMenuClosure1?()
        }
    }
    
    func getAllRooms(params:[String:Any]) {
        self.isLoading = true
       // let params: [String:Any] = [:]
        userService.getAllRooms(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? RoomsResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.message
                    return
                }
                self.roomResponse = model
                self.getJoinedRooms()
//                AppInstance.shared.allEvents = model
//                CalendarManager.shared.addEventToCalendar(dataArr: model.data ?? [])
                self.redirectControllerClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let errorModel):
//                guard let model = errorModel as? ErrorBaseModel else {
//                    return
//                }
                self.roomErrorResponse = errorModel
                self.redirectControllerClosure?()
            }
        }
    }
    
    func getJoinedRooms() {
//        self.isLoading = true
        userService.getJoinedRooms { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                if let model = data as? RoomJoinedModel {
                    if model.status == "SUCCESS" {
                        self.getJoinedRoomsResp = model
                        AppInstance.shared.allJoinedEvents = model
                        Persistence.cacheJoinedRooms(model.data)
                        NotificationCenter.default.post(name: Notification.Name.JOINED_ROOMS_RESPONSE, object: model.data)
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
    
    func getCategories() {
        self.isLoading = true
        let params: [String:Any] = [:]
        userService.getCategories(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? CategoriesResponse else {
                    return
                }
                self.categoriesResponse = model
                self.reloadListViewClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let errorModel):
                self.errorMessage = errorModel.message
            }
        }
    }
    
    func joinRoom(params: [String:Any]) {
        self.isLoading = true
        userService.joinRoom(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                if let model = data as? JoinRoomResponse {
                    if model.status == APIKeys.success {
                        self.joinRoomResponse = model
                    } else {
                        self.errorMessage = model.message
                    }
                }
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let errorModel):
                self.roomErrorResponse = errorModel
                self.errorMessage = errorModel.message
            }
        }
    }
    
    func unjoinRoom(roomID: String) {
        self.isLoading = true
        userService.unJoinRoom(roomID) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == APIKeys.success {
                            self.unjoinRoomResponse = model
                        } else {
                            self.errorMessage = ""
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
    
    func getUsersCreatedRoom(userId: String) {
        self.isLoading = true
        userService.userCreatedRoomsAPI(userId: userId) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                if let model = data as? RoomsResponse {
                    if model.status == "SUCCESS" {
                        self.roomResponse = model
                        self.redirectControllerClosure?()
                    } else {
                        self.errorMessage = ""
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
