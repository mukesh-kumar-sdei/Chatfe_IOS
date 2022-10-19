//
//  AppInstance.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 09/06/22.
//

import Foundation

final class AppInstance {
    
    static let shared = AppInstance()
    
    private init() {}
    
    var deviceToken: String?
    var timer: Timer?
    var allEvents: RoomsResponse?
    var allJoinedEvents: RoomJoinedModel?
    var getGrpChatModel: [GetEventChatsModel]?
    var onlineUsersArr: [String]?
}
