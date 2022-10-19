//
//  NotificationsActivityVM.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 14/06/22.
//

import Foundation
import UIKit


class NotificationsActivityVM: BaseViewModel {
    
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    
    //MARK: - INSTANCES
    var allFriendRequests: GetAllFriendRequestModel? {
        didSet {
            self.reloadListViewClosure?()
        }
    }
    
    var allNotificationData: NotificationsData? {
        didSet {
            self.reloadListViewClosure?()
        }
    }
    
    var acceptModel: SendOTPResponse? {
        didSet {
            self.redirectControllerClosure?()
        }
    }
    
    var rejectModel: SendOTPResponse? {
        didSet {
            self.redirectControllerClosure?()
        }
    }
    
    var joinModel: JoinRoomResponse? {
        didSet {
            self.redirectControllerClosure?()
        }
    }
    
    //MARK: - API METHODS
    func getAllNotifications() {
        self.isLoading = true
        userService.getAllNotificationsAPI { (result) in
//        userService.getAllFriendRequestsAPI { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? AllNotificationsModel {
                        if model.status == "SUCCESS" {
                            UIApplication.shared.applicationIconBadgeNumber = 0
                            self.allNotificationData = model.data
                            var count = 0
                            let friendCount = model.data?.friendResult ?? []
                            let inviteCount = model.data?.privateRoomResult ?? []
//                            if friendCount.count > 0 || inviteCount.count > 0 {
//                                count = friendCount.count + inviteCount.count
//                                print("Notification Count:",count)
//                                NotificationCenter.default.post(name: Notification.Name("HOME_NOTIFICATION_TAPPED"), object: count)
//                            }
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
    
    func getAllFriendRequests() {
        self.isLoading = true
        userService.getAllFriendRequestsAPI { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? GetAllFriendRequestModel {
                        if model.status == "SUCCESS" {
                            self.allFriendRequests = model
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
    
    func acceptFriendRequest(userId: String, senderId: String, receiverId: String) {
        self.isLoading = true
        userService.acceptFriendRequestAPI(userId: userId, senderId: senderId, receiverId: receiverId) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
//                    UIApplication.shared.applicationIconBadgeNumber = 0
//                    NotificationCenter.default.post(name: Notification.Name("HOME_NOTIFICATION_TAPPED"), object: 0)
                    if let model = data as? SendOTPResponse {
                        if model.status == "SUCCESS" {
                            self.acceptModel = model
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
    
    func rejectFriendRequest(userId: String, senderId: String, receiverId: String) {
        self.isLoading = true
        userService.rejectFriendRequestAPI(userId: userId, senderId: senderId, receiverId: receiverId) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
//                    UIApplication.shared.applicationIconBadgeNumber = 0
//                    NotificationCenter.default.post(name: Notification.Name("HOME_NOTIFICATION_TAPPED"), object: 0)
                    if let model = data as? SendOTPResponse {
                        if model.status == "SUCCESS" {
                            self.rejectModel = model
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
    
    func joinRoom(params: [String:Any]) {
        self.isLoading = true
        userService.joinRoom(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                if let model = data as? JoinRoomResponse {
                    if model.status == APIKeys.success {
                        self.joinModel = model
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
