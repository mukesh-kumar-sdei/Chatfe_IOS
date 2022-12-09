//
//  EventGroupChatVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 09/08/22.
//

import Foundation
import UIKit
import IQKeyboardManager
import ReactionButton


class EventGroupChatVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var lblRoomNameTitle: UILabel!
    @IBOutlet weak var imgRoomClassIcon: UIImageView!
    @IBOutlet weak var membersCollectionView: UICollectionView!
    
    @IBOutlet weak var grpChatTableView: UITableView!
    @IBOutlet weak var matchMakingPopupView: UIView!
    @IBOutlet weak var txtEnterMessage: CustomTextField!
    @IBOutlet weak var chatViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTyping: UILabel!
    
    lazy var viewModel: GroupChatVM = {
        let obj = GroupChatVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var channelID = ""
    var getGrpMessagesData = [GetEventChatsModel]()/* {
        didSet {
            DispatchQueue.main.async {
                self.grpChatTableView.reloadData()
            }
        }
    }*/
    var selectedRowReaction = 0
    var strUploadedImage: String?

//    let cellColors = ["49C6D8", "7F49D8", "D88549", "499CD8", "D549D8", "D84949", "6ED849", "D8C949"] // Opacity 20% each
    let cellColors = ["7F49D8", "D88549", "499CD8", "D549D8", "D84949", "6ED849", "D8C949"] // Opacity 20% each
    var getChannelIdData: ChannelIdData?
    var roomMembersList: [ParticipantsData]?
    var members_matchType_color = [MembersColorNMatch]()
    var memberColor = [String:String]()
    var readersArr = [String]()
    var isShowMatchMackingPopup = true
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.matchMakingPopupView.isHidden = (UserDefaultUtility.shared.getMatchMakingShown() ?? false) ? false : true
        
        self.members_matchType_color.removeAll()
        membersCollectionView.dataSource = self
        membersCollectionView.delegate = self
        grpChatTableView.dataSource = self
        grpChatTableView.delegate = self
        grpChatTableView.separatorColor = .clear
        setupUI()
        registerNIBs()
        viewModel.getChannelID()
        setupClosures()
        viewModel.listenVoteMessageEvent()
        listenReceiveMessageEvent()
        listenTypingGCEvent()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(getGrpChatChannelID(_:)), name: Notification.Name("GROUP_CHAT_CHANNEL_ID"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getGrpChatMembers(_:)), name: Notification.Name("GROUP_CHAT_MEMBERS"), object: nil)
        handleKeyboardObservers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(rejoinGroupChat), name: Notification.Name.SOCKET_RECONNECTED, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @objc func rejoinGroupChat() {
        self.viewModel.getChannelID()
    }
    
    // -----------------------------------
    @objc func keyboardShown(notification: Notification) {
        let beginFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        // keyboardFrame = kbSize!
        //isShowKeyboard = true
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
        
        let delta = ((kbSize?.origin.y)! - (beginFrame?.origin.y)!) as CGFloat
//        let topSafeArea: CGFloat
        let bottomSafeArea: CGFloat
        
        if #available(iOS 11.0, *) {
//            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
//            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }

        DispatchQueue.main.async {
            UIView.animate(withDuration: TimeInterval(truncating: duration), delay: 0.0, options: UIView.AnimationOptions(rawValue: UInt(truncating: curve)), animations: {
                self.chatViewBottomConstraint.constant -= (CGFloat((kbSize?.height)!) - bottomSafeArea)
                //self.chatViewTopConstraint.constant = (CGFloat((kbSize?.height)!) - bottomSafeArea)
                //self.textViewBottomConstraint.constant = (CGFloat((kbSize?.height)!) - bottomSafeArea)//+ 20 - 30
                self.grpChatTableView.contentOffset = CGPoint(x: 0, y: self.grpChatTableView.contentOffset.y - delta)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardHide(notification: Notification){
        let beginFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let delta = ((kbSize?.origin.y)! - (beginFrame?.origin.y)!) as CGFloat
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: TimeInterval(truncating: duration), delay: 0.0, options: UIView.AnimationOptions(rawValue: UInt(truncating: curve)), animations: {
                self.chatViewTopConstraint.constant  = 160.0
                self.chatViewBottomConstraint.constant = 0.0
                self.grpChatTableView.contentOffset = CGPoint(x: 0, y: self.grpChatTableView.contentOffset.y - delta)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().isEnabled = true
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // -----------------------------------
    // MARK: - ==== CUSTOM METHODs ====
    func registerNIBs() {
        membersCollectionView.register(UINib(nibName: GCMemberCVC.className, bundle: nil), forCellWithReuseIdentifier: GCMemberCVC.className)
        grpChatTableView.register(UINib(nibName: SenderGroupChatCell.className, bundle: nil), forCellReuseIdentifier: SenderGroupChatCell.className)
        grpChatTableView.register(UINib(nibName: ReceiverGroupChatCell.className, bundle: nil), forCellReuseIdentifier: ReceiverGroupChatCell.className)
        grpChatTableView.register(UINib(nibName: SenderGCImageCell.className, bundle: nil), forCellReuseIdentifier: SenderGCImageCell.className)
        grpChatTableView.register(UINib(nibName: GroupChatImageCell.className, bundle: nil), forCellReuseIdentifier: GroupChatImageCell.className)
    }
    
    func setupClosures() {
        /// GET CHANNEL ID API RESPONSE
        viewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let channelID = self.viewModel.channelIDResp?.data?.channelId {
                    SocketIOManager.shared.joinGroupChat(channelID: channelID)
                }
                self.getChannelIdData = self.viewModel.channelIDResp?.data
                SelectedVote.channelData = self.getChannelIdData
                self.channelID = self.getChannelIdData?.channelId ?? ""
                self.updateUI(data: self.getChannelIdData)
                
                if let channelID = self.getChannelIdData?.channelId {
                    /// HIT GET ROOM PARTICIPANTs API
                    self.viewModel.getEventMembers(channelID: channelID)
                }
            }
        }
        
        /// ROOM PARTICIPANTs LIST API RESPONSE
        viewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                
                if let channelID = SelectedVote.channelData?.channelId {
                    self.getEventChatHistory(channelID: channelID)
                }
                self.roomMembersList = self.viewModel.getMembersResp?.data
                
                /// MAPPING USER WITH MATCHTYPE & COLOR
                self.roomMembersList?.forEach({ members in
                    if let id = members._id, let matchType = members.matchType, let color = members.color {
                        let member = MembersColorNMatch(id: id, matchType: matchType, color: color)
                        self.members_matchType_color.append(member)
                    }
                })
                SelectedVote.memberList = self.members_matchType_color

                self.membersCollectionView.reloadData()
            }
        }
        
        /// PREVIOUS MESSAGES (CHAT HISTORY) RESPONSE
        viewModel.reloadMenuClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.getGrpMessagesData = self.viewModel.getGroupChats ?? []
                self.grpChatTableView.reloadData()
                ///[START] MAPPING MATCHTYPE & COLOR
                self.roomMembersList?.forEach({ memberData in
                    if let id = memberData._id, let matchType = memberData.matchType, let color = memberData.color {
                        let member = MembersColorNMatch(id: id, matchType: matchType, color: color)
                        self.members_matchType_color.append(member)
                    }
                    self.getGrpMessagesData.enumerated().forEach { (index, item) in
                        if item.senderId?._id == memberData._id {
                            self.getGrpMessagesData[index].senderId?.color = memberData.color
                            self.getGrpMessagesData[index].senderId?.matchType = memberData.matchType
                        }
                    }
                })
                ///[END]
                
                ///[START] UPDATE READ MESSAGE
                self.readersArr = self.getGrpMessagesData.last?.readers ?? []
                /// APPENDING READER FOR MESSAGES
                if let reader = UserDefaultUtility.shared.getUserId() {
                    if !self.readersArr.contains(reader) {
                        self.readersArr.append(reader)
                    }
                }
                if let unreadMsg = self.getGrpMessagesData.last {
                    SocketIOManager.shared.readGCMessage(senderId: unreadMsg.senderId?._id ?? "", msgId: unreadMsg._id ?? "", channelID: unreadMsg.channelId ?? "", readers: self.readersArr)
                }
                ///[END]
                
                self.txtEnterMessage.text = ""
                self.scrollToBottom(false)
                
                /// EMIT GROUP UNREAD COUNT EVENT
                if let channelID = SelectedVote.channelData?.channelId {
                    SocketIOManager.shared.emitUnreadGCCountEvent(channelId: channelID)
                }
            }
        }
        
        /// IMAGE UPLOAD RESPONSE
        viewModel.redirectControllerClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let selectedImage = self.viewModel.imageUploadResponse?.files?.first {
                    self.strUploadedImage = selectedImage
                    self.viewModel.sendTextMessageAPI(channelID: self.channelID, message: selectedImage, messageId: "", type: "image", reaction: "")
                }
            }
        }
        
        /// VOTE MESSAGE RESPONSE
        viewModel.reloadMenuClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let msg = self.viewModel.voteMessageResp?.message ?? ""
                if let msgType = self.viewModel.voteMessageResp?.messageType, msgType == "kickedOut" {
                    // SHOW CUSTOM POPUP
                    let popupVC = kChatStoryboard.instantiateViewController(withIdentifier: KickedPopupVC.className) as! KickedPopupVC
                    popupVC.delegate = self
                    popupVC.titleMessage = msg
                    popupVC.modalTransitionStyle = .crossDissolve
                    popupVC.modalPresentationStyle = .popover
                    self.present(popupVC, animated: false, completion: nil)
                } else {
                    self.showBaseAlert(msg)
                    /// HIT GET ROOM PARTICIPANTs API
                    if let channelID = SelectedVote.channelData?.channelId {
                        self.viewModel.getEventMembers(channelID: channelID)
                    }
                }
            }
        }
    }
    

    @objc func getGrpChatMembers(_ notification: Notification) {
        if let memberData = notification.object as? [MembersColorNMatch] {
            self.members_matchType_color = memberData
        }
    }
    
    
    func getEventChatHistory(channelID: String) {
        self.viewModel.getGroupChatsList(channelID: channelID)
    }
    
    func setupUI() {
        viewRoundCornersFromBottom()
        self.txtEnterMessage.delegate = self
        self.txtEnterMessage.maxLength = 200
        self.txtEnterMessage.inputAccessoryView = UIView()
        self.txtEnterMessage.keyboardDistanceFromTextField = 8
//        self.txtEnterMessage.keyboardDistanceFromTextField = 0.0
//        self.txtEnterMessage.keyboardToolbar.isHidden = true
        self.txtEnterMessage.keyboardToolbar.shouldHideToolbarPlaceholder = true
        self.txtEnterMessage.backgroundColor = .black
        self.txtEnterMessage.attributedPlaceholder = NSAttributedString(string: self.txtEnterMessage.placeholder ?? "",
                                                                        attributes: [NSAttributedString.Key.foregroundColor : UIColor("#383D44")])
        self.txtEnterMessage.tintColor = .white
        self.txtEnterMessage.textColor = .white
    }
    
    func updateUI(data: ChannelIdData?) {
        self.lblRoomNameTitle.text = data?.roomName
        if data?.roomClass == Constants.chat {
            self.imgRoomClassIcon.image = Images.chatRoomIcon
        } else if (data?.roomClass ?? "").localizedCaseInsensitiveContains(Constants.watch) {
            self.imgRoomClassIcon.image = Images.watchPartyIcon
        }
    }
    
    func viewRoundCornersFromBottom() {
        matchMakingPopupView.clipsToBounds = true
        matchMakingPopupView.layer.cornerRadius = 10.0
        matchMakingPopupView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    // MARK: - ==== SOCKET LISTEN EVENTS ====
    func listenReceiveMessageEvent() {
        SocketIOManager.shared.receiveGroupChatMessage { data in
            guard let resp = data?.first else { return }
            do {
                let respData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                var model = try JSONDecoder().decode(GetEventChatsModel.self, from: respData)
                
                /// EMIT UNREAD COUNT
                if let channelID = model.channelId {
                    SocketIOManager.shared.emitUnreadGCCountEvent(channelId: channelID)
                }
                
                // MAPPING COLOR & MATCHTYPE
                self.members_matchType_color.forEach { member in
                    if member.id == model.senderId?._id {
                        model.senderId?.matchType = member.matchType
                        model.senderId?.color = member.color
                    }
                }
                
                if model.reaction?.count ?? 0 > 0 {
                    /// REPLACE OLD DATA BASED ON MESSAGE ID FOR REACTION UPDATE
                    if let matchedMsgIdRow = self.getGrpMessagesData.firstIndex(where: {$0._id == model._id}) {
                        self.getGrpMessagesData[matchedMsgIdRow] = model
                        self.grpChatTableView.reloadData()
                    }
                } else {
                    self.getGrpMessagesData.append(model)
                }
                
                printMessage("--> RECEIVE GROUP MESSAGE :> \(respData.beautifyJSON())")
                self.txtEnterMessage.text = ""
                self.scrollToBottom(true)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func listenTypingGCEvent() {
        SocketIOManager.shared.listenGCTypingStatus { data in
            guard let resp = data?.first else { return }
            do {
                let respData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                let model = try JSONDecoder().decode(UserTypingGCModel.self, from: respData)
                
                let matchedSenderID = self.roomMembersList?.filter({$0._id == model.senderId})
                if matchedSenderID?.count ?? 0 > 0 {
                    let senderName = "\(matchedSenderID?.first?.fname ?? "") \(matchedSenderID?.first?.lname ?? "")"
                    if let status = model.isTyping {
                        if status {
                            self.lblTyping.isHidden = false
                            self.lblTyping.text = "\(senderName) \(Constants.Typing)"
                        } else {
                            self.lblTyping.isHidden = true
                            self.lblTyping.text = ""
                        }
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func executeTypingSocketEvent(isTyping: Bool) {
        let senderID = UserDefaultUtility.shared.getUserId() ?? ""
        SocketIOManager.shared.userTypingGCStatus(senderId: senderID, channelId: self.channelID, isTyping: isTyping)
    }
    
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnDismissClicked(_ sender: UIButton) {
        self.matchMakingPopupView.isHidden = true
        UserDefaultUtility.shared.saveMatchMakingShown(show: false)
        self.isShowMatchMackingPopup = false
    }
    
    @IBAction func galleryButtonTapped(_ sender: UIButton) {
        self.openGallery()
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        self.openCamera()
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        if self.txtEnterMessage.text?.count ?? 0 > 0 {
            self.viewModel.sendTextMessageAPI(channelID: channelID, message: self.txtEnterMessage.text ?? "", messageId: "", type: "message", reaction: "")
        } else {
            print("SOMETHING WENT WRONG")
        }
    }
    
}


// MARK: - ==== COLLECTIONVIEW DATASOURCE & DELEGATE METHODs ====
extension EventGroupChatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomMembersList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GCMemberCVC.className, for: indexPath) as! GCMemberCVC
        
        let data = self.roomMembersList?[indexPath.row]
        cell.customView.backgroundColor = UIColor(cellColors[indexPath.row], alpha: 0.2)
        cell.lblMemberName.textColor = UIColor(cellColors[indexPath.row])
        cell.lblMemberName.text = "\(data?.fname ?? "") \(data?.lname ?? "")"
        cell.updateImages(data: data)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profilePreviewVC = kChatStoryboard.instantiateViewController(withIdentifier: ProfilePreviewVC.className) as! ProfilePreviewVC
        profilePreviewVC.ppDelegate = self
        profilePreviewVC.userID = self.roomMembersList?[indexPath.row]._id ?? ""
//        let nav = UINavigationController(rootViewController: profilePreviewVC)
        self.navigationController?.pushViewController(profilePreviewVC, animated: true)
//        self.present(nav, animated: true, completion: nil)
    }
    
}

// MARK: - ==== TEXTFIELD DELEGATE METHODs ====
extension EventGroupChatVC: UITextFieldDelegate {
    
    // TYPING BEHAVIOUR
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtEnterMessage {
            self.executeTypingSocketEvent(isTyping: true)
        }
        return true
    }
     
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtEnterMessage {
            self.executeTypingSocketEvent(isTyping: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEnterMessage {
            txtEnterMessage.resignFirstResponder()
            return true
        } else {
            return false
        }
    }
}

// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension EventGroupChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getGrpMessagesData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.getGrpMessagesData[indexPath.row]
//        let memberData = self.members_matchType_color?[indexPath.row]
        
        if data.senderId?._id == UserDefaultUtility.shared.getUserId() {
            if data.messageType == "image" {
                let cell = tableView.dequeueReusableCell(withIdentifier: SenderGCImageCell.className) as! SenderGCImageCell
                cell.selectionStyle = .none

//                let senderColor = UIColor(cellColors.randomElement() ?? "FFFFFF")
//                let senderName = "\(data.senderId?.fname ?? "") \(data.senderId?.lname ?? "")"
//                setAttributedText(cell: cell, senderName: senderName, senderText: "", senderColor: senderColor)
                
                cell.showEmojiReaction(messages: data)
                cell.showImage(strImage: data.message ?? "")
                
                cell.sentImageButton.tag = indexPath.row
                cell.sentImageButton.addTarget(self, action: #selector(imageButtonTapped(_:)), for: .touchUpInside)
                
                return cell
            } else {
//            if data.messageType == "message" {
                let cell = tableView.dequeueReusableCell(withIdentifier: SenderGroupChatCell.className) as! SenderGroupChatCell
                cell.selectionStyle = .none
//                cell.updateImages(data: data)
                let textMessage = data.message ?? ""
                let senderName = "\(data.senderId?.fname ?? "") \(data.senderId?.lname ?? "")"
                let senderColor = UIColor("49C6D8")
                setAttributedText(cell: cell, senderName: senderName, senderText: textMessage, senderColor: senderColor)
                
                /// IF ANY REACTION PRESENT
                if data.reaction?.count ?? 0 > 0 {
                    
                    cell.viewEmoji.isHidden = false
                    cell.lblEmoji.isHidden = false
                    
                    var strEmoji = ""
                    for emo in ChatReaction.emoji {
                        let filteredData = data.reaction?.filter({$0.reaction == emo})
                        if let matchedIndex = data.reaction?.firstIndex(where: {$0.reaction == emo}) {
                            if filteredData?.count ?? 0 > 1 {
                                let strEmo = " \(data.reaction?[matchedIndex].reaction ?? "") \(filteredData?.count ?? 0)"
                                strEmoji.append(strEmo)
                                cell.lblEmoji.text = strEmoji
                            } else if filteredData?.count ?? 0 == 1 {
                                let strEmo = " \(data.reaction?[matchedIndex].reaction ?? "")"
                                strEmoji.append(strEmo)
                                cell.lblEmoji.text = strEmoji
                            }
                        }
                    }
                    cell.lblChatMessageBottom.constant = 30.0
                } else {
                    cell.viewEmoji.isHidden = true
                    cell.lblEmoji.isHidden = true
                    cell.lblChatMessageBottom.constant = 0.0
                }
                
                /// FOR EMOJI REACTIONs
                cell.messageView.tag = indexPath.row
                cell.messageView.delegate = self
                
                return cell
            }

        } else {
            if data.messageType == "image" {
                let cell = tableView.dequeueReusableCell(withIdentifier: GroupChatImageCell.className) as! GroupChatImageCell
                cell.selectionStyle = .none
                
                cell.updateMatchPrefIcon(matchType: data.senderId?.matchType ?? "")

                let senderColor = UIColor(data.senderId?.color ?? "808080")
                let senderName = "\(data.senderId?.fname ?? "") \(data.senderId?.lname ?? "")"
                setAttributedText(cell: cell, senderName: senderName, senderText: "", senderColor: senderColor)
                
                cell.showEmojiReaction(messages: data)
                cell.showImage(strImage: data.message ?? "")
                
                cell.sentImageButton.tag = indexPath.row
                cell.sentImageButton.addTarget(self, action: #selector(imageButtonTapped(_:)), for: .touchUpInside)
                
                /// FOR EMOJI REACTIONs
                cell.pictureView.tag = indexPath.row
                cell.pictureView.delegate = self
                
                return cell
            } else {
//            if data.messageType == "message" {
    //            let cell = tableView.dequeueReusableCell(withIdentifier: SenderGroupChatCell.className) as! SenderGroupChatCell
                let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverGroupChatCell.className) as! ReceiverGroupChatCell
                cell.selectionStyle = .none
    
                cell.updateImages(matchType: data.senderId?.matchType ?? "")
 
//                let senderColor = UIColor(memberData.color ?? "")
                let textMessage = data.message ?? ""
                let senderName = "\(data.senderId?.fname ?? "") \(data.senderId?.lname ?? "")"
                let senderColor = UIColor(data.senderId?.color ?? "808080")
                setAttributedText(cell: cell, senderName: senderName, senderText: textMessage, senderColor: senderColor)
                
//            cell.showEmojiReaction(messages: data)
                
                /// IF ANY REACTION PRESENT
                if data.reaction?.count ?? 0 > 0 {
                    
                    cell.viewEmoji.isHidden = false
                    cell.lblEmoji.isHidden = false
                    
                    var strEmoji = ""
                    for emo in ChatReaction.emoji {
                        let filteredData = data.reaction?.filter({$0.reaction == emo})
                        if let matchedIndex = data.reaction?.firstIndex(where: {$0.reaction == emo}) {
                            if filteredData?.count ?? 0 > 1 {
                                let strEmo = " \(data.reaction?[matchedIndex].reaction ?? "") \(filteredData?.count ?? 0)"
                                strEmoji.append(strEmo)
                                cell.lblEmoji.text = strEmoji
                            } else if filteredData?.count ?? 0 == 1 {
                                let strEmo = " \(data.reaction?[matchedIndex].reaction ?? "")"
                                strEmoji.append(strEmo)
                                cell.lblEmoji.text = strEmoji
                            }
                        }
                    }
                    cell.lblChatMessageBottom.constant = 30.0
                } else {
                    cell.viewEmoji.isHidden = true
                    cell.lblEmoji.isHidden = true
                    cell.lblChatMessageBottom.constant = 0.0
                }
                
                /// FOR EMOJI REACTIONs
                cell.messageView.tag = indexPath.row
                cell.messageView.delegate = self
                
                return cell
            }
        }
    }
    
    @objc func imageButtonTapped(_ sender: UIButton) {
        let imageViewVC = kHomeStoryboard.instantiateViewController(withIdentifier: ChatImageViewController.className) as! ChatImageViewController
        imageViewVC.strImage = getGrpMessagesData[sender.tag].message ?? ""
        imageViewVC.modalPresentationStyle = .fullScreen
        self.present(imageViewVC, animated: true, completion: nil)
    }
    
    func scrollToBottom(_ animated: Bool) {
        self.grpChatTableView.reloadData()
        if self.getGrpMessagesData.count > 0 {
            let rowCount = self.getGrpMessagesData.count - 1
            self.grpChatTableView.scrollToRow(at: IndexPath(row: rowCount, section: 0), at: .bottom, animated: animated)
        }
    }
  
}


// MARK: - CAMERA & PHOTO LIBRARY
extension EventGroupChatVC {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: AlertMessage.warning, message: AlertMessage.youDontHaveCamera, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: AlertMessage.warning, message: AlertMessage.youHaveNotGalleryAccess, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
//    func uploadImageAPI(image: UIImage, name: String, fileName: String) {
//        DispatchQueue.main.async {
//            let imageData = image.jpegData(compressionQuality: 0.3)! as NSData
//            let file = File(name: name, fileName: fileName, data: imageData as Data)
//            self.viewModel.uploadProfilePic(files: [file])
//        }
//    }
    
    func uploadImageAPI(image: UIImage, name: String, fileName: String, sourceType: UIImagePickerController.SourceType) {
        var imageData = NSData()
        DispatchQueue.main.async {
            if sourceType == .camera {
                if let myImage = image.resizeImageWidthInPixel(width: 1024) {
                    if let  rotatedImage = myImage.rotateImage() {
                        imageData = rotatedImage.jpegData(compressionQuality: 0.3)! as NSData
                    }
                }
            } else {
                if let myImage = image.resizeImageWidthInPixel(width: 1024) {
                    imageData = myImage.jpegData(compressionQuality: 0.3)! as NSData
                }
            }
            let file = File(name: name, fileName: fileName, data: imageData as Data)
            self.viewModel.uploadProfilePic(files: [file])
        }
    }
    
}

// MARK: - CAMERA & PHOTO LIBRARY DELEGATE METHODs
extension EventGroupChatVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker.sourceType == .camera {
            self.handleKeyboardObservers()
            if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let name = UUID().uuidString
                let fileName = "\(name).jpg"
                self.uploadImageAPI(image: tempImage, name: name, fileName: fileName, sourceType: .camera)
                self.dismiss(animated: true, completion: nil)
            } else if let tempImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                let name = UUID().uuidString
                let fileName = "\(name).jpg"
                self.uploadImageAPI(image: tempImage, name: name, fileName: fileName, sourceType: .camera)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showBaseAlert("Something went wrong, please try again.")
            }
        } else {
            if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let name = UUID().uuidString
                let fileName = "\(name).jpg"
                self.uploadImageAPI(image: tempImage, name: name, fileName: fileName, sourceType: .photoLibrary)
                self.dismiss(animated: true, completion: nil)
            } else if let tempImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                let name = UUID().uuidString
                let fileName = "\(name).jpg"
                self.uploadImageAPI(image: tempImage, name: name, fileName: fileName, sourceType: .photoLibrary)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showBaseAlert("Something went wrong, please try again.")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if picker.sourceType == .camera {
            self.handleKeyboardObservers()
        }
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - ==== ATTRIBUTED TEXT ====
extension EventGroupChatVC {
    
    func setAttributedText(cell: UITableViewCell?, senderName: String, senderText: String, senderColor: UIColor) {
        let regularFont = UIFont(name: AppFont.ProximaNovaRegular, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        let boldFont = UIFont(name: AppFont.ProximaNovaBold, size: 16.0) ?? UIFont.boldSystemFont(ofSize: 16.0)
        
        let attributedNameColor = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: senderColor]
        let attributedTextColor = [NSAttributedString.Key.font: regularFont, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let attributedString1 = NSMutableAttributedString(string: "\(senderName): ", attributes: attributedNameColor)
        let attributedString2 = NSMutableAttributedString(string: senderText, attributes: attributedTextColor)

        if let cell = cell as? SenderGroupChatCell {
            cell.lblChatMessage.attributedText = attributedString2
        } else if let cell = cell as? ReceiverGroupChatCell {
            attributedString1.append(attributedString2)
            cell.lblChatMessage.attributedText = attributedString1
        } else if let cell = cell as? GroupChatImageCell {
            attributedString1.append(attributedString2)
            cell.lblChatMessage.attributedText = attributedString1
        }
    }
}


extension EventGroupChatVC: ReactionButtonDelegate {
    
    func ReactionSelector(_ sender: ReactionButton, didSelectedIndex index: Int) {
//        debugPrint("--> BUTTON REACTION SELECTED :> \(index)")
        self.selectedRowReaction = sender.tag
        let messageId = getGrpMessagesData[sender.tag]._id ?? ""
        /// REMOVE REACTION
        let matchedReaction = getGrpMessagesData[sender.tag].reaction?.filter({$0.senderId == UserDefaultUtility.shared.getUserId()})
        if matchedReaction?.count ?? 0 > 0 {
            self.viewModel.sendTextMessageAPI(channelID: self.channelID, message: "", messageId: messageId, type: "", reaction: " ")
        } else {
            self.viewModel.sendTextMessageAPI(channelID: self.channelID, message: "", messageId: messageId, type: "", reaction: ChatReaction.emoji[index])
        }
    }
}


extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}


extension EventGroupChatVC: KickedOutDelegate {
    
    func dismissFromGroup(result: Bool) {
        if result {
            self.navigationController?.popViewController(animated: true)
        }
    }
}


extension EventGroupChatVC: ProfilePreviewDelegate {
    
    func didCloseProfilePreview(result: Bool) {
        handleKeyboardObservers()
    }
    
    func handleKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().isEnabled = false
    }
}
