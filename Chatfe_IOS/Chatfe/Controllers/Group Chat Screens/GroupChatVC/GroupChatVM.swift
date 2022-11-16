//
//  GroupChatVM.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 04/08/22.
//

import Foundation

class GroupChatVM: BaseViewModel {
    
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

    var voteMessageResp: VoteMessageModel? {
        didSet {
            self.reloadMenuClosure1?()
        }
    }
    
    var imageUploadResponse: ImageUploadResponse? {
        didSet {
            self.redirectControllerClosure1?()
        }
    }
    
    
    // MARK: - API METHODs
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
    
    
    func getChannelID() {
        self.isLoading = true
        userService.getRoomChannelID { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? ChannelIdModel {
                        if model.status == APIKeys.success {
                            self.channelIDResp = model
                        } else {
                            self.errorMessage = "Channel Id not found!"
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

    func getEventMembers(channelID: String) {
        self.isLoading = true
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
    
    func sendTextMessageAPI(channelID: String, message: String, messageId: String, type: String, reaction: String) {
        let params = [APIKeys.channelID     : channelID,
                      APIKeys.message       : message,
                      APIKeys.messageType   : type,
                      APIKeys.senderId      : UserDefaultUtility.shared.getUserId() ?? "",
                      APIKeys._id           : messageId,
                      APIKeys.reaction      : reaction
        ] as [String : Any]
        SocketIOManager.shared.sendGroupChatMessage(params: params)
    }

    func listenVoteMessageEvent() {
        SocketIOManager.shared.listenVoteMessage { data in
            guard let resp = data?.first else { return }
            do {
                let respData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                let model = try JSONDecoder().decode(VoteMessageModel.self, from: respData)
                self.voteMessageResp = model
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
}


