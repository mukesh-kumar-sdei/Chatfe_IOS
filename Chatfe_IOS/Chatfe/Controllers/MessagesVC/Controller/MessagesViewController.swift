//
//  MessagesViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 12/05/22.
//

import UIKit

class MessagesViewController: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var lblRecentConnections: UILabel!
    @IBOutlet weak var recentCollectionView: UICollectionView!
    @IBOutlet weak var chatFriendsTableView: UITableView!
    @IBOutlet weak var lblNotFound: UILabel!
    @IBOutlet weak var lblBadge: UILabel!
    
    lazy var viewModel: MessagesViewModel = {
        let obj = MessagesViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    // MARK: - ==== VARIABLEs ====
    var recentData: [RecentSuggestions]?
    var conversationData: [ConversationResult]? {
        didSet {
            DispatchQueue.main.async {
                self.chatFriendsTableView.reloadData()
            }
        }
    }
//    var allTextMessages = [String]()
    var chatHeadID = String()
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblBadge.layer.masksToBounds = true
        self.lblBadge.cornerRadius = 8.5
        self.lblBadge.isHidden = true
        recentCollectionView.dataSource = self
        recentCollectionView.delegate = self
        chatFriendsTableView.dataSource = self
        chatFriendsTableView.delegate = self
        registerNIBs() 
//        self.viewModel.recentConnectionAPI()
        self.setupClosure()
        listenReceiveMessageEvent()
//        startTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(listenUnreadCountSocketEvent), name: Notification.Name.GC_UNREAD_MESSAGE_COUNT, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(listenOnlineOfflineUsers(_:)), name: Notification.Name.LISTEN_ONLINE_USERS, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationCount(_:)), name: Notification.Name.PUSH_NOTIFICATION_COUNT, object: nil)
    }
    
    @objc func updateNotificationCount(_ notification: Notification) {
        if let count = notification.object as? Int {
            DispatchQueue.main.async {
                if count == 0 {
                    self.lblBadge.backgroundColor = .clear
                    self.lblBadge.text = ""
                }else{
                    self.lblBadge.backgroundColor = .red
                    self.lblBadge.text = "\(count)"
                }
            }
        }
    }
    
    @objc func listenOnlineOfflineUsers(_ notification: Notification) {
        if let model = notification.object as? UserOnlineModel {
//            if model.isOnline ?? false {
//                if let userID = model.userId {
//                    AppInstance.shared.onlineUsersArr?.append(userID)
//                }
//            } else if !(model.isOnline ?? false) {
//                if let index = AppInstance.shared.onlineUsersArr?.firstIndex(where: {$0 == model.userId}) {
//                    AppInstance.shared.onlineUsersArr?.remove(at: index)
//                }
//            }
//
            self.conversationData?.enumerated().forEach({ (index, item) in
                if item.receiverData?.receiverId == model.userId {
                    self.conversationData?[index].receiverData?.isOnline = model.isOnline
                }
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.recentConnectionAPI()
        
        SocketIOManager.shared.emitUnreadCountEvent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        stopTimer()
    }

    
    // MARK: - ==== CUSTOM METHODs ====
    func listenReceiveMessageEvent() {
        SocketIOManager.shared.receiveMessage { _ in
            self.viewModel.recentConnectionAPI()
        }
    }
    
    func registerNIBs() {
        recentCollectionView.register(UINib(nibName: RecentConnectionsCell.className, bundle: nil), forCellWithReuseIdentifier: RecentConnectionsCell.className)
        chatFriendsTableView.register(UINib(nibName: MessagesChatTVC.className, bundle: nil), forCellReuseIdentifier: MessagesChatTVC.className)
    }

    func setupClosure() {
        /// GETALLCHATHEAD EVENT RESPONSE
        /// For RECENT CONNECTIONS & CONVERSATIONRESULT DATA
        viewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.recentData = self.viewModel.recentConnectionResp?.recentSuggestions
                self.conversationData = self.viewModel.recentConnectionResp?.conversationResult
                
                if self.conversationData?.count ?? 0 == 0 {
                    self.lblNotFound.isHidden = false
                    self.lblNotFound.text = AlertMessage.NoConversationyet
                } else {
                    self.lblNotFound.isHidden = true
                    self.lblNotFound.text = ""
                }
                self.chatFriendsTableView.reloadData()
                self.recentCollectionView.reloadData()
            }
        }
    }

    
    // MARK: - ==== IBACTIONs ====
    @IBAction func addChatBtnClicked(_ sender: UIButton) {
        let friendsListVC = kHomeStoryboard.instantiateViewController(withIdentifier: InviteFriendsListVC.className) as! InviteFriendsListVC
        friendsListVC.isFromMessages = true
        self.navigationController?.pushViewController(friendsListVC, animated: true)
    }
    
    @IBAction func notificationsClicked(_ sender: UIButton) {
        let notificationActivityVC = kHomeStoryboard.instantiateViewController(withIdentifier: NotificationsActivityVC.className) as! NotificationsActivityVC
        self.navigationController?.pushViewController(notificationActivityVC, animated: true)
    }
    
//    @IBAction func btnGrpChatClicked(_ sender: UIButton) {
////        let notificationActivityVC = kHomeStoryboard.instantiateViewController(withIdentifier: GroupChatVC.className) as! GroupChatVC
////        self.navigationController?.pushViewController(notificationActivityVC, animated: true)
//        let openGrpEventVC = kChatStoryboard.instantiateViewController(withIdentifier: EventGroupChatVC.className) as! EventGroupChatVC
//        self.navigationController?.pushViewController(openGrpEventVC, animated: true)
//    }
    
}


// MARK: - ==== COLLECTIONVIEW DATASOURCE & DELEGATE METHODs ====
extension MessagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recentData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentConnectionsCell.className, for: indexPath) as! RecentConnectionsCell
        let data = recentData?[indexPath.row]
        cell.lblFriendName.text = "\(data?.fname ?? "") \(data?.lname ?? "")"
        if let imageURL = URL(string: data?.profileImg ?? "") {
            cell.friendImage.kf.setImage(with: imageURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recentChatVC = kHomeStoryboard.instantiateViewController(withIdentifier: RecentConnectionChatVC.className) as! RecentConnectionChatVC
        recentChatVC.profileDetails = self.recentData?[indexPath.row]
        self.navigationController?.pushViewController(recentChatVC, animated: true)
    }

}



// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessagesChatTVC.className) as! MessagesChatTVC
        cell.selectionStyle = .none

        let data = conversationData?[indexPath.row].receiverData
//        printMessage("--> ISONLINE STATUS :> \(data?.receiverFirstName) \(data?.receiverLastName) - \(data?.isOnline)")
        /// ONLINE / OFFLINE USERS
        if data?.isOnline ?? false {
            cell.onlineDotImage.isHidden = false
            cell.lblFriendNameLeading.constant = 20
            self.view.layoutIfNeeded()
        } else {
            cell.onlineDotImage.isHidden = true
            cell.lblFriendNameLeading.constant = 0
            self.view.layoutIfNeeded()
        }
        
        /// READ / UNREAD USERs
        if let readers = conversationData?[indexPath.row].readers, let userID = UserDefaultUtility.shared.getUserId() {
            let matchedReader = readers.filter({$0 == userID})
            if matchedReader.count > 0 {
                /// MESSAGE READ
                cell.lblChatMessage.textColor = AppColor.appGrayColor
                cell.lblChatTime.textColor = AppColor.appGrayColor
                cell.unreadDotImage.isHidden = true
            } else {
                /// MESSAGE UNREAD
                cell.lblChatMessage.textColor = .white
                cell.lblChatTime.textColor = .white
                cell.unreadDotImage.isHidden = false
            }
        }
        
        cell.lblFriendName.text = "\(data?.receiverFirstName ?? "") \(data?.receiverLastName ?? "")"
        if let profileImgURL = URL(string: data?.profileImg ?? "") {
            cell.friendImage.kf.setImage(with: profileImgURL)
        }
        
        /// IF THERE IS IMAGE - SHOWING IMAGE TEXT INSTEAD IT'S URL
        if conversationData?[indexPath.row].messageType == "image" {
            cell.lblChatMessage.text = "Shared an image"
        } else {
            cell.lblChatMessage.text = conversationData?[indexPath.row].msg
        }
        
        /// FETCH TIME & CONVERSION
        let strDateTime = conversationData?[indexPath.row].msgDate ?? ""
        let localDate = strDateTime.serverToLocalTime()
//        let chatTime = localDate.extractStartTime()
        let chatTime = localDate.extractStartTime(DateFormats.hhmm_a)
        cell.lblChatTime.text = chatTime

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.conversationData?[indexPath.row]
        self.chatHeadID = data?._id ?? ""
        let receiverID = data?.receiverData?.receiverId ?? ""
        let receiverName = "\(data?.receiverData?.receiverFirstName ?? "") \(data?.receiverData?.receiverLastName ?? "")"
        let receiverImg = data?.receiverData?.profileImg ?? ""
        let isOnline = data?.receiverData?.isOnline ?? false
        navigateToChatVC(chatId: self.chatHeadID, rID: receiverID, rName: receiverName, rImage: receiverImg, isFromRecentConn: false, isOnline: isOnline)
    }
    
    func navigateToChatVC(chatId: String, rID: String, rName: String, rImage: String, isFromRecentConn: Bool, isOnline: Bool? = nil) {
        let chatVC = kHomeStoryboard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
        chatVC.isFromRecentConnections = isFromRecentConn
        chatVC.isOnline = isOnline ?? false
        chatVC.chatID = chatId
        chatVC.receiverID = rID
        chatVC.receiverName = rName
        chatVC.receiverImg = rImage
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
}
