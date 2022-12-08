//
//  FriendsProfileVM.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 13/06/22.
//

import Foundation

class FriendsProfileVM: BaseViewModel {
    
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    
    // MARK: - INSTANCES
    var friendsProfileModel: FriendsProfileModel? {
        didSet {
            self.reloadListViewClosure?()
        }
    }
    
    var sendFriendRequestModel: SendOTPResponse? {
        didSet {
            self.redirectControllerClosure?()
        }
    }
    
    var unFriendResponse: SendOTPResponse? {
        didSet {
            self.reloadMenuClosure?()
        }
    }
    
    var addRecentSearchResponse: AddRecentSearchModel? {
        didSet {
            self.redirectControllerClosure1?()
        }
    }
    
    var blockUserResp: SendOTPResponse? {
        didSet {
            self.reloadMenuClosure1?()
        }
    }
    
    var unblockUserResp: SendOTPResponse? {
        didSet {
            self.reloadMenuClosure1?()
        }
    }
    
    var matchPreferenceResp: MatchPrefData? {
        didSet {
            self.reloadListViewClosure1?()
        }
    }
    
    var recentConnDetails: RecentConnectionDetailModel? {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    // MARK: - API METHODS
    func getFriendsProfile(userId: String) {
        self.isLoading = true
        userService.friendUserProfile(userId: userId) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? FriendsProfileModel {
                        if model.status == "SUCCESS" {
                            self.friendsProfileModel = model
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
    
    func sendFriendRequest(senderId: String, receiverId: String) {
        self.isLoading = true
        userService.sendFriendRequestAPI(senderId: senderId, receiverId: receiverId) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == "SUCCESS" {
                            self.sendFriendRequestModel = model
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
    
    func unFriendRequest(userId: String, friendID: String) {
        self.isLoading = true
        userService.unfriendAPI(userId: userId, friendID: friendID) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == "SUCCESS" {
                            self.unFriendResponse = model
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
    
    func blockUser(id: String) {
        self.isLoading = true
        userService.userBlockAPI(Id: id) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == APIKeys.success {
                            self.blockUserResp = model
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
    
    // -------------------------------------
    func recentConnectionDetails(userID: String, recentUserID: String) {
//        self.isLoading = true
        userService.recentConnectionDetailsAPI(userID: userID, recentUserID: recentUserID) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? RecentConnectionDetailModel {
                        if model.status == APIKeys.success {
                            self.recentConnDetails = model
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
    
    //MARK: - SOCKET EVENT METHODs
    func createNewChatAPI(receiverID: String, message: String) {
        self.isLoading = true
        DispatchQueue.main.async {
            self.isLoading = false
            if SocketIOManager.shared.isSocketConnected() {
                if let userID = UserDefaultUtility.shared.getUserId() {
                    SocketIOManager.shared.createNewChat(senderId: userID, receiverId: receiverID) { data in
                        if let resp = data?.first, let chatData = resp as? [String:Any] {
                            if let chatID = chatData[APIKeys._id] as? String {
                                self.sendTextMessageAPI(chatID: chatID, receiverID: receiverID, message: message, type: "message")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func sendTextMessageAPI(chatID: String, receiverID: String, message: String, type: String) {
        let params = ["chatHeadId"  : chatID,
                      "message"     : message,
                      "messageType" : type, // "message",
                      "senderId"    : UserDefaultUtility.shared.getUserId() ?? "",
                      "receiverId"  : receiverID
        ] as [String : Any]
        
        SocketIOManager.shared.sendMessage(params: params)
    }
    
}
