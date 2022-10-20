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

    
}
