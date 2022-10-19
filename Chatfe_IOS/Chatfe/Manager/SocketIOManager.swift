//
//  SocketIOManager.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 06/07/22.
//

import Foundation
import SocketIO

//let manager = SocketManager(socketURL: URL(string: Config.socketURL)!, config: [.log(true), .compress])
//let manager = SocketManager(socketURL: URL(string: Config.socketURL)!, config: [.log(false), .compress])
let userIdObj = ["userId": UserDefaultUtility.shared.getUserId() ?? ""]
let manager = SocketManager(socketURL: URL(string: Config.socketURL)!, config: [.connectParams(userIdObj), .log(true), .compress])

let socket = manager.defaultSocket
typealias completionHandler = (_ data: [Any]?) -> Void

private struct SocketKeys {
    
    // RESERVED KEYs

    /// connect. Fired upon a successful connection.
    static let connect              =   "connect"
    
    /// disconnect. Fired upon a successful disconnection.
    static let disconnect           =   "disconnect"
    
    /// Fired upon a connection error.
    static let connect_error        =   "connect_error"

    /// connect_timeout. Fired upon a connection timeout.
    static let connect_timeout      =   "connect_timeout"

    /// reconnect. Fired upon a successful reconnection.
    static let reconnect            =   "reconnect"

    ///    reconnect_attempt. Fired upon an attempt to reconnect.
    static let reconnect_attempt    =   "reconnect_attempt"


    /// reconnecting. Fired upon an attempt to reconnect.
    static let reconnecting         =   "reconnecting"

    /// reconnect_error. Fired upon a reconnection attempt error.
    static let reconnect_error      =   "reconnect_error"
    
    /// reconnect_failed. Fired when couldn’t reconnect within reconnectionAttempts
    static let reconnect_failed     =   "reconnect_failed"
    
    
    // CUSTOM KEYs
    static let join                 =   "join"
    static let leave                =   "leave"
    
//    static let sendUser             =   "sendUser"
//    static let getRecent            =   "getRecent"
    
    static let getMessage           =   "getMessage"
    static let receiveMessage       =   "receiveMessage"
    static let sendMessage          =   "sendMessage"
    static let readMessage          =   "readMessage"
    
    static let createChatHead       =   "createChatHead"
    static let getChatHeadId        =   "getChatHeadId"
    static let getAllChatHeads      =   "getAllChatHeads"
    static let typingStatus         =   "typingStatus"
    static let onlineStatus         =   "onlineStatus"
    
    static let joinEventChat        =   "joinEventChat"
    static let sendEventMessage     =   "sendEventMessage"
    static let getEventMessage      =   "getEventMessage"
    static let getEventChats        =   "getEventChats"
    static let voteMessage          =   "voteMessage"
    static let unreadMsgCount       =   "unreadMsgCount"
    static let grpUnreadMsg         =   "grpUnreadMsg"
    static let userConnected        =   "userConnected"
    static let userDisconnect       =   "userDisconnect"
    static let typingEventStatus    =   "typingEventStatus"
}

enum MessageType: String {
    case message = "message"
    case image = "image"
    case video = "video"
    case file = "file"
}


class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    override init() {
        super.init()
        
    }
    
    
    // MARK: - SOCKET METHODs
    func isSocketConnected() -> Bool {
        if socket.status == .connected {
            return true
        }
        return false
    }
    
    func establishConnection() {
        socket.connect()
        socket.on(clientEvent: .connect) { data, ack in
            printMessage("\n--> SOCKET CONNECTED SUCCESSFULLY")
            self.joinSocket()
            // EMIT UNREAD COUNT SOCKET EVENT
            self.emitUnreadCountEvent()
            
            self.listenUserOnline { _ in
                // NOTHING TO DO
            }
            self.listenUserOffline { _ in
                // NOTHING TO DO
            }
        }
    }
    
    func reConnect() {
        if !isSocketConnected() {
            socket.connect()
            socket.on(clientEvent: .reconnect) { data, ack in
                printMessage("\n--> SOCKET RE-CONNECTED SUCCESSFULLY")
            }
        }
    }
    
    func joinSocket() {
        if let userID = UserDefaultUtility.shared.getUserId() {
            let params = [APIKeys.userId: userID]
            socket.emit(SocketKeys.join, with: [params]) {
                printMessage("\n--> SOCKET JOINED SUCCESSFULLY with User ID :> \(params)")
            }
        }
    }
    
    func leaveSocket() {
        if let userID = UserDefaultUtility.shared.getUserId() {
            let params = [APIKeys.userId: userID]
            socket.emit(SocketKeys.leave, with: [params]) {
                printMessage("\n--> SOCKET LEFT SUCCESSFULLY with User ID :> \(params)")
            }
        }
    }
    
    func closeConnection() {
        leaveSocket()
        socket.disconnect()
    }
    
    
    func sendMessage(params: [String: Any]) {
        socket.emit(SocketKeys.sendMessage, with: [params]) {
//            print("\n--> SENT MESSAGE SUCCESSFULLY!")
            printMessage("\n--> SENT MESSAGE SUCCESSFULLY!")
        }
    }
    
    func receiveMessage(completion: @escaping completionHandler) {
        socket.on(SocketKeys.receiveMessage) { data, ack in
            NotificationCenter.default.post(name: Notification.Name("RECEIVED_CHAT_MESSAGE"), object: data)
            completion(data)
        }
    }
    
    func getRecentChats(userID: String, completion: @escaping completionHandler) {
        let params = [APIKeys.userId: userID]
        socket.emit(SocketKeys.getAllChatHeads, with: [params]) {
            socket.on(SocketKeys.getAllChatHeads) { data, ack in
                completion(data)
            }
        }
    }
    
    
    func createNewChat(senderId: String, receiverId: String, completion: @escaping completionHandler) {
        let params = [APIKeys.senderId    : senderId,
                      APIKeys.receiverId  : receiverId]
        socket.emit(SocketKeys.createChatHead, with: [params]) {
            socket.on(SocketKeys.getChatHeadId) { data, ack in
                completion(data)
            }
        }
    }
    
    func getMessages(chatHeadID: String, completion: @escaping completionHandler) {
        let params = [APIKeys.chatHeadID: chatHeadID]
        socket.emit(SocketKeys.getMessage, with: [params]) {
            socket.on(SocketKeys.getMessage) { data, ack in
                completion(data)
            }
        }
    }
    
    func userTypingStatus(senderId: String, receiverId: String, chatHeadID: String, isTyping: Bool, completion: @escaping completionHandler) {
        let params = [APIKeys.senderId      : senderId,
                      APIKeys.receiverId    : receiverId,
                      APIKeys.chatHeadID    : chatHeadID,
                      APIKeys.isTyping      : isTyping
                    ] as [String : Any]
        socket.emit(SocketKeys.typingStatus, with: [params]) {
            socket.on(SocketKeys.typingStatus) { data, ack in
                completion(data)
            }
        }
    }
    
    func listenTypingStatus(completion: @escaping completionHandler) {
        socket.on(SocketKeys.typingStatus) { data, ack in
            completion(data)
        }
    }
    
    func readMessage(senderId: String, msgId: String, chatHeadID: String, readers: [String]) {
        let params = [APIKeys.senderId      : senderId,
                      APIKeys.messageId     : msgId,
                      APIKeys.chatHeadID    : chatHeadID,
                      APIKeys.readers       : readers
                    ] as [String : Any]
        socket.emit(SocketKeys.readMessage, with: [params])
//        print("\n--> READ MESSAGE EMITTED :> \(params)")
    }
    
    func readGCMessage(senderId: String, msgId: String, channelID: String, readers: [String]) {
        let params = [APIKeys.senderId      : senderId,
                      APIKeys.messageId     : msgId,
                      APIKeys.channelID    : channelID,
                      APIKeys.readers       : readers
                    ] as [String : Any]
        socket.emit(SocketKeys.readMessage, with: [params])
//        print("\n--> READ MESSAGE EMITTED :> \(params)")
    }
    
    func onlineStatus(receiverID: String, completion: @escaping completionHandler) {
        let params = [APIKeys.userId: receiverID]
        socket.emit(SocketKeys.onlineStatus, with: [params]) {
            printMessage("\n--> ONLINE STATUS OF \(params)")
            socket.on(SocketKeys.onlineStatus) { data, ack in
                printMessage("--> ONLINE STATUS IS :> \(data)")
                completion(data)
            }
        }
        
    }
    
    func emitUnreadCountEvent() {
        if isSocketConnected() {
            if let userID = UserDefaultUtility.shared.getUserId() {
                self.emitUnreadCount(userId: userID)
                NotificationCenter.default.post(name: Notification.Name.GC_UNREAD_MESSAGE_COUNT, object: nil)
            }
        }
    }
    
    func emitUnreadCount(userId: String) {
        let params = [APIKeys.userId: userId]
        socket.emit(SocketKeys.unreadMsgCount, with: [params])
    }
    
    func unreadCount(completion: @escaping completionHandler) {
        socket.on(SocketKeys.unreadMsgCount) { data, ack in
            printMessage("\n--> Message COUNT :> \(data)")
            completion(data)
        }
    }
    
    func listenUserOnline(completion: @escaping completionHandler) {
        socket.on(SocketKeys.userConnected) { data, ack in
//            printMessage("\n--> Message COUNT :> \(data)")
            guard let resp = data.first else { return }
            do {
                let respData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                let model = try JSONDecoder().decode(UserOnlineModel.self, from: respData)
                NotificationCenter.default.post(name: Notification.Name.LISTEN_ONLINE_USERS, object: model)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
            completion(data)
        }
    }
    
    func listenUserOffline(completion: @escaping completionHandler) {
        socket.on(SocketKeys.userDisconnect) { data, ack in
//            printMessage("\n--> Message COUNT :> \(data)")
            guard let resp = data.first else { return }
            do {
                let respData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                let model = try JSONDecoder().decode(UserOnlineModel.self, from: respData)
                NotificationCenter.default.post(name: Notification.Name.LISTEN_ONLINE_USERS, object: model)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
            completion(data)
        }
    }
    
    
    
    // MARK: -
    // ====================================================
    //                  GROUP CHAT EVENTS
    // ====================================================
    func joinGroupChat(channelID: String) {
        let params = [APIKeys.channelID: channelID]
        socket.emit(SocketKeys.joinEventChat, with: [params])
        printMessage("\n--> JOIN Group Chat with ChannelID :> \(params)")
    }
    
    func sendGroupChatMessage(params: [String: Any]) {
        socket.emit(SocketKeys.sendEventMessage, with: [params])
    }
    
    func receiveGroupChatMessage(completion: @escaping completionHandler) {
        socket.on(SocketKeys.getEventMessage) { data, ack in
            printMessage("\n--> Receive Group Chat Message :> \(data)")
            completion(data)
        }
    }
    
    func getGroupChats(channelID: String, completion: @escaping completionHandler) {
        let params = [APIKeys.channelID: channelID]
        socket.emit(SocketKeys.getEventChats, with: [params]) {
            socket.on(SocketKeys.getEventChats) { data, ack in
                completion(data)
            }
        }
    }
    
    func emitVoteMessage(params: [String: Any]) {
        socket.emit(SocketKeys.voteMessage, with: [params])
    }
    
    func listenVoteMessage(completion: @escaping completionHandler) {
        socket.on(SocketKeys.voteMessage) { data, ack in
            completion(data)
        }
    }
    
    func emitUnreadGCCountEvent(channelId: String) {
        if isSocketConnected() {
            if let userID = UserDefaultUtility.shared.getUserId() {
                self.emitUnreadGCCount(channelId: channelId, userId: userID)
                NotificationCenter.default.post(name: Notification.Name.UNREAD_GROUP_MESSAGE_COUNT, object: nil)
            }
        }
    }
    
    func emitUnreadGCCount(channelId: String, userId: String) {
        let params = [APIKeys.channelID: channelId, APIKeys.userId: userId]
        socket.emit(SocketKeys.grpUnreadMsg, with: [params])
    }
    
    func unreadGCCount(completion: @escaping completionHandler) {
        socket.on(SocketKeys.grpUnreadMsg) { data, ack in
            printMessage("\n--> Message COUNT :> \(data)")
            completion(data)
        }
    }
    
    func userTypingGCStatus(senderId: String, channelId: String, isTyping: Bool) {
        let params = [APIKeys.senderId      : senderId,
                      APIKeys.channelID     : channelId,
                      APIKeys.isTyping      : isTyping
                    ] as [String : Any]
        socket.emit(SocketKeys.typingEventStatus, with: [params])
    }
    
    func listenGCTypingStatus(completion: @escaping completionHandler) {
        socket.on(SocketKeys.typingEventStatus) { data, ack in
            completion(data)
        }
    }
    
}
