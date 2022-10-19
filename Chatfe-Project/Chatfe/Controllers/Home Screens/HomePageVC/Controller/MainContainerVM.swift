//
//  MainContainerVM.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 19/08/22.
//

import Foundation

class MainContainerVM: BaseViewModel {
    
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    
    //MARK: - INSTANCES
    var channelIDResp: ChannelIdModel? {
        didSet {
            self.reloadListViewClosure?()
        }
    }
    
    var getMembersResp: ParticipantsModel? {
        didSet {
            self.redirectControllerClosure?()
        }
    }
    
    var getGroupChats: [GetEventChatsModel]? {
        didSet {
            self.reloadMenuClosure?()
        }
    }


    // MARK: - API METHODs
    func getChannelID() {
//        self.isLoading = true
        userService.getRoomChannelID { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? ChannelIdModel {
                        if model.status == APIKeys.success {
                            self.channelIDResp = model
                        }/* else {
                            self.errorMessage = model.message
                        }*/
                    }
                case .error(let message):
                    self.errorMessage = message
                case .customError(let errorModel):
                    self.errorMessage = errorModel.message
                }
            }
        }
    }

    func getEventMembers(channelID: String) {
//        self.isLoading = true
        userService.getRoomMembers(channelID: channelID) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? ParticipantsModel {
                        if model.status == APIKeys.success {
                            self.getMembersResp = model
                        }/* else {
                            self.errorMessage = model.message
                        }*/
                    }
                case .error(let message):
                    self.errorMessage = message
                case .customError(let errorModel):
                    self.errorMessage = errorModel.message
                }
            }
        }
    }
    
    
    // MARK: - GROUP CHAT SOCKET EVENTs METHODs
    func getGroupChatsList(channelID: String) {
        SocketIOManager.shared.getGroupChats(channelID: channelID) { data in
            guard let respData = data?.first else { return }
            do {
                let json = try JSONSerialization.data(withJSONObject: respData, options: .prettyPrinted)
                let model = try JSONDecoder().decode([GetEventChatsModel].self, from: json)
                self.getGroupChats = model
                printMessage("\n--> GET GROUP CHATS :> \(json.beautifyJSON())")
            } catch let error {
                self.errorMessage = error.localizedDescription
                debugPrint(error.localizedDescription)
            }
        }
    }

    
    // GET NOTIFICATIONs COUNT
    func getAllNotifications() {
//        self.isLoading = true
        userService.getAllNotificationsAPI { (result) in
            DispatchQueue.global(qos: .background).async {
//            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? AllNotificationsModel {
                        if model.status == "SUCCESS" {
//                            self.allNotificationData = model.data
                            var count = 0
                            let friendCount = model.data?.friendResult ?? []
                            let inviteCount = model.data?.privateRoomResult ?? []
//                            if friendCount.count > 0 || inviteCount.count > 0 {
//                                count = friendCount.count + inviteCount.count
//                                NotificationCenter.default.post(name: Notification.Name.PUSH_NOTIFICATION_COUNT, object: count)
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
    
}
