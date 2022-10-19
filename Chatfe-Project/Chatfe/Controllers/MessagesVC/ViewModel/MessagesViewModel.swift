//
//  MessagesViewModel.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 29/06/22.
//

import UIKit

class MessagesViewModel: BaseViewModel {

    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    // MARK: - INSTANCES
    var recentConnectionResp: RecentConnectionModel? {
        didSet {
            self.reloadListViewClosure?()
        }
    }

    var getMessageResp: [GetMessageModel]? {
        didSet {
            self.redirectControllerClosure?()
        }
    }

    var recentConnDetails: RecentConnectionDetailModel? {
        didSet {
            self.reloadMenuClosure?()
        }
    }
    
    var imageUploadResponse: ImageUploadResponse? {
        didSet {
            self.redirectControllerClosure1?()
        }
    }
    
    var isOnlineStatus: Bool? {
        didSet {
            self.reloadMenuClosure1?()
        }
    }
    
    // MARK: - API METHODs
    func recentConnectionAPI() {
        self.isLoading = true
        DispatchQueue.main.async {
            self.isLoading = false
            if SocketIOManager.shared.isSocketConnected() {
                if let userID = UserDefaultUtility.shared.getUserId() {
                    SocketIOManager.shared.getRecentChats(userID: userID) { data in
                        // HANDLE RESPONSE OF RECENT CONNECTIONS API
                        guard let data = data?.first else { return }
                        do {
                            let respData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                            let model = try JSONDecoder().decode(RecentConnectionModel.self, from: respData)
                            self.recentConnectionResp = model
                            printMessage("GETALLCHATHEADS EVENT :> \n\(respData.beautifyJSON())")
                        } catch let error {
                            self.errorMessage = error.localizedDescription
                            debugPrint(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func recentConnectionDetails(userID: String, recentUserID: String) {
        self.isLoading = true
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

    
    func getPreviousMessagesList(chatID: String) {
        SocketIOManager.shared.getMessages(chatHeadID: chatID) { data in
            // HANDLE RESPONSE OF RECENT CONNECTIONS API
            guard let respData = data?.first else { return }
            do {
                let json = try JSONSerialization.data(withJSONObject: respData, options: .prettyPrinted)
                let model = try JSONDecoder().decode([GetMessageModel].self, from: json)
                self.getMessageResp = model
                printMessage("\n--> GET MESSAGES :> \(json.beautifyJSON())")
            } catch let error {
                self.errorMessage = error.localizedDescription
                debugPrint(error.localizedDescription)
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
    
    func sendMessageReaction(chatID: String, receiverID: String, messageID: String, reaction: String) {
        let params = ["chatHeadId"  : chatID,
//                      "messageType" : "reaction",
                      "senderId"    : UserDefaultUtility.shared.getUserId() ?? "",
                      "receiverId"  : receiverID,
                      "_id"         : messageID,
                      "reaction"    : reaction
        ] as [String : Any]
        
        SocketIOManager.shared.sendMessage(params: params)
    }
    
    func uploadProfilePic(files: [File]) {
//        self.isLoading = true
        userService.uploadImage([:], files: files) { (result) in
            DispatchQueue.global(qos: .background).async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? ImageUploadResponse {
                        if model.status == APIKeys.success {
                            self.imageUploadResponse = model
                        } else {
                            self.errorMessage = model.message
                        }
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
    
    func onlineStatusEvent(receiverId: String) {
        SocketIOManager.shared.onlineStatus(receiverID: receiverId) { data in
            guard let respData = data?.first else { return }
            do {
                let json = try JSONSerialization.data(withJSONObject: respData, options: .prettyPrinted)
                let model = try JSONDecoder().decode(OnlineStatusModel.self, from: json)
                if let isOnline = model.onlineStatus {
                    self.isOnlineStatus = isOnline
                }
//                printMessage("\n--> ONLINE STATUS :> \(json.beautifyJSON())")
            } catch let error {
//                self.errorMessage = error.localizedDescription
                debugPrint(error.localizedDescription)
            }
        }
    }
    

}
