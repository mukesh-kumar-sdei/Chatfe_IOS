//
//  ChatViewController.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 29/06/22.
//

import UIKit
import IQKeyboardManager
import ReactionButton


class ChatViewController: BaseViewController {
    
    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var onlineDotImage: UIImageView!
    @IBOutlet weak var lblFriendsName: UILabel!
    @IBOutlet weak var lblFriendNameLeading: NSLayoutConstraint!
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var chatViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtEnterMessage: CustomTextField!
    @IBOutlet weak var lblTyping: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    lazy var viewModel: MessagesViewModel = {
        let obj = MessagesViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var isFromRecentConnections = false
    var recentConnDetails: RecentConnectionDetailModel?
    
    var getMessagesData = [GetMessageModel]()
    var readersArr = [String]()
    
    var chatID = ""
    
    private var senderID = ""
    var userImage = ""
    
    var receiverID = ""
    var receiverName = ""
    var receiverImg = ""
    
    var isOnline = false
    
    var selectedImage: UIImage?
    var strUploadedImage: String?
    var selectedRowReaction: Int = 0

//    let emoji = ["😀", "😜", "🤔", "👋", "👏", "👍"]
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.isNavigationBarHidden = false
        setupUI()
        onlineStatus()
        initTableView()
        registerNIBs()
        getChatHistory()
        setupClosure()
        
        listenTypingEvent()
        listenReceiveMessageEvent()
        notificationObservers()
        
//        hitOnlineStatusEvent()    /// NOT IN USE NOW
//        startTimer()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().isEnabled = false
        
//        updateOnlineOffline()
        NotificationCenter.default.addObserver(self, selector: #selector(listenOnlineOfflineUsers(_:)), name: Notification.Name.LISTEN_ONLINE_USERS, object: nil)
    }
    
    @objc func listenOnlineOfflineUsers(_ notification: Notification) {
        if let model = notification.object as? UserOnlineModel {
            DispatchQueue.main.async {
                if model.userId == self.receiverID && model.isOnline ?? false {
                    self.onlineDotImage.isHidden = false
                    self.lblFriendNameLeading.constant = 20
                    self.view.layoutIfNeeded()
                } else {
                    self.onlineDotImage.isHidden = true
                    self.lblFriendNameLeading.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func onlineStatus() {
        DispatchQueue.main.async {
            if self.isOnline {
                self.onlineDotImage.isHidden = false
                self.lblFriendNameLeading.constant = 20
                self.view.layoutIfNeeded()
            } else {
                self.onlineDotImage.isHidden = true
                self.lblFriendNameLeading.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    /*
    func updateOnlineOffline() {
        AppInstance.shared.onlineUsersArr?.forEach({ onlineUser in
            if onlineUser == senderID {
                self.onlineDotImage.isHidden = false
                self.lblFriendNameLeading.constant = 20
                self.view.layoutIfNeeded()
            } else {
                self.onlineDotImage.isHidden = true
                self.lblFriendNameLeading.constant = 0
                self.view.layoutIfNeeded()
            }
        })
    }
    */
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*if chatTableView.contentOffset.y >= (chatTableView.contentSize.height - chatTableView.frame.size.height) {
            /// you reached the end of the table
        } else {
            self.scrollToBottom(true)
        }*/
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        stopTimer()
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
                self.chatTableView.contentOffset = CGPoint(x: 0, y: self.chatTableView.contentOffset.y - delta)
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
                self.chatViewTopConstraint.constant  = 80.0
                self.chatViewBottomConstraint.constant = 0.0
                self.chatTableView.contentOffset = CGPoint(x: 0, y: self.chatTableView.contentOffset.y - delta)
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
    /*
    func startTimer() {
        AppInstance.shared.timer?.invalidate()
        AppInstance.shared.timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(hitOnlineStatusEvent), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        DispatchQueue.main.async {
            AppInstance.shared.timer?.invalidate()
            AppInstance.shared.timer = nil
        }
    }
    */
    /*
    @objc func hitOnlineStatusEvent() {
        self.viewModel.onlineStatusEvent(receiverId: self.receiverID)
    }
    */
    func setupUI() {
        DispatchQueue.main.async {
            // GET OWN's USER ID & PROFILE IMAGE
            self.senderID = UserDefaultUtility.shared.getUserId() ?? ""
            self.userImage = UserDefaultUtility.shared.getProfileImageURL() ?? ""
            
            self.lblTyping.isHidden = true
            self.lblFriendsName.text = self.receiverName
            
            self.txtEnterMessage.delegate = self
            self.txtEnterMessage.maxLength = 200
            self.txtEnterMessage.inputAccessoryView = UIView()  // This will remove toolbar which have done button.
            self.txtEnterMessage.keyboardDistanceFromTextField = 8
//            self.txtEnterMessage.keyboardDistanceFromTextField = 0.0
//            self.txtEnterMessage.keyboardToolbar.isHidden = true
            self.txtEnterMessage.keyboardToolbar.shouldHideToolbarPlaceholder = true
            self.txtEnterMessage.backgroundColor = .black
            self.txtEnterMessage.attributedPlaceholder = NSAttributedString(string: self.txtEnterMessage.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor("#383D44")])
            self.txtEnterMessage.tintColor = .white
            self.txtEnterMessage.textColor = .white
        }
    }
    
    func initTableView() {
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.separatorColor = .clear
    }
    
    func registerNIBs() {
        chatTableView.register(UINib(nibName: SenderChatCell.className, bundle: nil), forCellReuseIdentifier: SenderChatCell.className)
        chatTableView.register(UINib(nibName: ReceiverChatCell.className, bundle: nil), forCellReuseIdentifier: ReceiverChatCell.className)
        chatTableView.register(UINib(nibName: ChatImageCell.className, bundle: nil), forCellReuseIdentifier: ChatImageCell.className)
        chatTableView.register(UINib(nibName: ReceiverImageCell.className, bundle: nil), forCellReuseIdentifier: ReceiverImageCell.className)
    }
    
    func notificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showTypingView(_:)), name: Notification.Name.SOCKET_USER_TYPING, object: nil)
    }
    
    func getChatHistory() {
        // HIT GET MESSAGE SOCKET EVENT
        if chatID.count > 0 {
            self.viewModel.getPreviousMessagesList(chatID: chatID)
        }
    }
   
    func setupClosure() {
        /// PREVIOUS MESSAGES (CHAT HISTORY) RESPONSE
        viewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.getMessagesData = self.viewModel.getMessageResp ?? []
                self.readersArr = self.getMessagesData.last?.readers ?? []
                /// UPDATE READ MESSAGE
                /// APPENDING READER FOR MESSAGES
                if let reader = UserDefaultUtility.shared.getUserId() {
                    if !self.readersArr.contains(reader) {
                        self.readersArr.append(reader)
                    }
                }
                
                /// READ MESSAGE EVENT RESPONSE
                if let unreadMsg = self.getMessagesData.last {
                    SocketIOManager.shared.readMessage(senderId: unreadMsg.senderId ?? "", msgId: unreadMsg._id ?? "", chatHeadID: unreadMsg.chatHeadId ?? "", readers: self.readersArr)
                }
                
                self.txtEnterMessage.text = ""
//                self.txtEnterMessage.resignFirstResponder()
                self.scrollToBottom(false)
//                self.scrollToBottom(true)
                
                /// EMIT CHAT UNREAD COUNT EVENT
                SocketIOManager.shared.emitUnreadCountEvent()
            }
        }
        
        /// IMAGE UPLOAD RESPONSE
        viewModel.redirectControllerClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let selectedImage = self.viewModel.imageUploadResponse?.files?.first {
                    self.strUploadedImage = selectedImage
                    self.viewModel.sendTextMessageAPI(chatID: self.chatID, receiverID: self.receiverID, message: selectedImage, type: "image")
                }
            }
        }
        /*
        /// ONLINE STATUS RESPONSE
        viewModel.reloadMenuClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isOnline = self.viewModel.isOnlineStatus ?? false
                
                if self.isOnline {
                    self.onlineDotImage.isHidden = false
                    self.lblFriendNameLeading.constant = 20
                    self.view.layoutIfNeeded()
                } else {
                    self.onlineDotImage.isHidden = true
                    self.lblFriendNameLeading.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
        */
    }
    
    
    // MARK: - ==== SOCKET LISTEN EVENTS ====
    func listenTypingEvent() {
        SocketIOManager.shared.listenTypingStatus { data in
            guard let resp = data?.first else { return }
            do {
                let respData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                let model = try JSONDecoder().decode(UserTypingModel.self, from: respData)
                    if let status = model.isTyping {
                        if status {
                            self.lblTyping.isHidden = false
                            self.lblTyping.text = Constants.Typing
                        } else {
                            self.lblTyping.isHidden = true
                            self.lblTyping.text = ""
                        }
                    }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func listenReceiveMessageEvent() {
        SocketIOManager.shared.receiveMessage { data in
            guard let resp = data?.first else { return }
            do {
                let respData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                let model = try JSONDecoder().decode(GetMessageModel.self, from: respData)
//                if model.messageType == "reaction" {
                if model.reactions?.count ?? 0 > 0 || model.reaction?.count ?? 0 > 0 {
                    /// REPLACE OLD DATA BASED ON MESSAGE ID FOR REACTION UPDATE
                    if let matchedMsgIdRow = self.getMessagesData.firstIndex(where: {$0._id == model._id}) {
                        self.getMessagesData[matchedMsgIdRow] = model
                    }
                } else {
                    self.getMessagesData.append(model)
                }
                
                printMessage("--> RECEIVE MESSAGE :> \(respData.beautifyJSON())")
                self.txtEnterMessage.text = ""
                self.scrollToBottom(true)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
            
//            self.scrollToBottom(true)
        }
    }
    

    // MARK: - ==== IBACTIONs ====
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func titleButtonTapped(_ sender: UIButton) {
        let friendsProfileVC = kHomeStoryboard.instantiateViewController(withIdentifier: FriendsProfileVC.className) as! FriendsProfileVC
        friendsProfileVC.userId = self.receiverID
//        friendsProfileVC.isFromMyProfile = false
        self.navigationController?.pushViewController(friendsProfileVC, animated: true)
    }
    
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
        //
    }
    
    @IBAction func addFileButtonTapped(_ sender: UIButton) {
        self.openGallery()
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.openCamera()
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        if self.txtEnterMessage.text?.count != 0 {
            if chatID.count == 0 {
                self.viewModel.createNewChatAPI(receiverID: receiverID, message: self.txtEnterMessage.text ?? "")
                self.txtEnterMessage.text = ""
            } else {
                self.viewModel.sendTextMessageAPI(chatID: self.chatID, receiverID: receiverID, message: self.txtEnterMessage.text ?? "", type: "message")
                self.txtEnterMessage.text = ""
            }
        }
    }
}



// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  getMessagesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messages = getMessagesData[indexPath.row]

        if messages.senderId == UserDefaultUtility.shared.getUserId() {
            if messages.messageType == "image" {
                // IMAGE CELL
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatImageCell.className, for: indexPath) as! ChatImageCell
                cell.selectionStyle = .none
                
                cell.setupFriendImage(strImage: self.receiverImg)
                cell.sentImage(strImage: messages.message ?? "")
                cell.setupTime(strTime: messages.createdAt ?? "")
                
                cell.btnImage.tag = indexPath.row
                cell.btnImage.addTarget(self, action: #selector(imageButtonTapped(_:)), for: .touchUpInside)

                return cell
            } else {
                // TEXT CELL
                let cell = tableView.dequeueReusableCell(withIdentifier: SenderChatCell.className) as! SenderChatCell
                cell.selectionStyle = .none
                cell.lblMessage.text = messages.message
                if let profileImgURL = URL(string: self.userImage) {
                    cell.friendImage.kf.setImage(with: profileImgURL)
                }
                
                /// FETCH & CONVERSION OF TIMEZONE
                let strDateTime = messages.createdAt ?? ""
                let localDate = strDateTime.serverToLocalTime()
//                let chatTime = localDate.extractStartTime()
                let chatTime = localDate.extractStartTime(DateFormats.hhmm_a)
                cell.lblChatTime.text = chatTime
                
                /// SHOW EMOJI REACTION
                if messages.reactions?.count ?? 0 > 0 || messages.reaction?.count ?? 0 > 0 {
                    if messages.reactions?.first?.reaction != "" || messages.reaction?.first?.reaction != "" {
                        cell.viewEmoji.isHidden = false
                        cell.lblEmoji.isHidden = false
                        cell.lblEmoji.text = messages.reactions?.first?.reaction ?? messages.reaction?.first?.reaction
                    } else {
                        cell.viewEmoji.isHidden = true
                        cell.lblEmoji.isHidden = true
                    }
                } else {
                    cell.viewEmoji.isHidden = true
                    cell.lblEmoji.isHidden = true
                }
                
                cell.cellButton.tag = indexPath.row
                
                /// DELEGATE FOR REACTION
                cell.cellButton.delegate = self
                
                return cell
            }
        } else {
            if messages.messageType == "image" {
                // IMAGE CELL
                let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverImageCell.className, for: indexPath) as! ReceiverImageCell
                cell.selectionStyle = .none
                
                cell.setupFriendImage(strImage: self.receiverImg)
                cell.sentImage(strImage: messages.message ?? "")
                cell.setupTime(strTime: messages.createdAt ?? "")
                
                cell.btnImage.tag = indexPath.row
                cell.btnImage.addTarget(self, action: #selector(imageButtonTapped(_:)), for: .touchUpInside)

                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverChatCell.className, for: indexPath) as! ReceiverChatCell
                // TEXT CELL
                cell.selectionStyle = .none
                cell.lblMessage.text = messages.message ?? ""
                if let profileImgURL = URL(string: self.receiverImg) {
                    cell.friendImage.kf.setImage(with: profileImgURL)
                }
                
                /// FETCH & CONVERSION OF TIMEZONE
                let strDateTime = messages.createdAt ?? ""
                let localDate = strDateTime.serverToLocalTime()
//                let chatTime = localDate.extractStartTime()
                let chatTime = localDate.extractStartTime(DateFormats.hhmm_a)
                cell.lblChatTime.text = chatTime
                
                /// SHOW EMOJI REACTION
                if messages.reactions?.count ?? 0 > 0 || messages.reaction?.count ?? 0 > 0 {
                    if messages.reactions?.first?.reaction != "" || messages.reaction?.first?.reaction != "" {
                        cell.viewEmoji.isHidden = false
                        cell.lblEmoji.isHidden = false
                        cell.lblEmoji.text = messages.reactions?.first?.reaction ?? messages.reaction?.first?.reaction
                    } else {
                        cell.viewEmoji.isHidden = true
                        cell.lblEmoji.isHidden = true
                    }
                } else {
                    cell.viewEmoji.isHidden = true
                    cell.lblEmoji.isHidden = true
                }
                
                cell.cellButton.tag = indexPath.row
                
                /// DELEGATE FOR REACTION
                cell.cellButton.delegate = self
                
                return cell
            }
        }
    }
    
    @objc func imageButtonTapped(_ sender: UIButton) {
        let imageViewVC = kHomeStoryboard.instantiateViewController(withIdentifier: ChatImageViewController.className) as! ChatImageViewController
        imageViewVC.strImage = getMessagesData[sender.tag].message ?? ""
        imageViewVC.modalPresentationStyle = .fullScreen
        self.present(imageViewVC, animated: true, completion: nil)
    }

    func scrollToBottom(_ animated: Bool) {
        self.chatTableView.reloadData()
        if self.getMessagesData.count > 0 {
            let rowCount = self.getMessagesData.count - 1
            self.chatTableView.scrollToRow(at: IndexPath(row: rowCount, section: 0), at: .bottom, animated: animated)
        }
    }
}



extension ChatViewController: UITextFieldDelegate {
    
    @objc func showTypingView(_ notification: Notification) {
        DispatchQueue.main.async {
            if let status = notification.object as? Bool {
                if status {
                    self.lblTyping.isHidden = false
                    self.lblTyping.text = Constants.Typing
                } else {
                    self.lblTyping.isHidden = true
                    self.lblTyping.text = ""
                }
            }
        }
    }
    
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
    
    func executeTypingSocketEvent(isTyping: Bool) {
        SocketIOManager.shared.userTypingStatus(senderId: senderID, receiverId: receiverID, chatHeadID: chatID, isTyping: isTyping) { data in
            /*guard let data = data?.first else { return }
            do {
                let respData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let model = try JSONDecoder().decode(UserTypingModel.self, from: respData)
                NotificationCenter.default.post(name: Notification.Name.SOCKET_USER_TYPING, object: model.isTyping)
            } catch let error {
                debugPrint(error.localizedDescription)
            }*/
        }
    }
    
    
    
}


// MARK: - CAMERA & PHOTO LIBRARY
extension ChatViewController {
    
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
//            imagePicker.allowsEditing = true
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: AlertMessage.warning, message: AlertMessage.youHaveNotGalleryAccess, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func uploadImageAPI(image: UIImage, name: String, fileName: String) {
        let imageData = image.jpegData(compressionQuality: 0.8)! as NSData
        let file = File(name: name, fileName: fileName, data: imageData as Data)
        viewModel.uploadProfilePic(files: [file])
    }
    
}


// MARK: - CAMERA & PHOTO LIBRARY DELEGATE METHODs
extension ChatViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let name = UUID().uuidString
            let fileName = "\(name).jpg"
            self.uploadImageAPI(image: tempImage, name: name, fileName: fileName)
            self.dismiss(animated: true, completion: nil)
        } else {
            self.showBaseAlert("Something went wrong, please try again.")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension ChatViewController: ReactionButtonDelegate {
    
    func ReactionSelector(_ sender: ReactionButton, didSelectedIndex index: Int) {
//        debugPrint("--> BUTTON REACTION SELECTED :> \(index)")
        self.selectedRowReaction = sender.tag
        let data = self.getMessagesData[sender.tag]
        let receiverId = data.receiverId ?? ""
        let messageId = data._id ?? ""
        self.viewModel.sendMessageReaction(chatID: self.chatID, receiverID: receiverId, messageID: messageId, reaction: ChatReaction.emoji[index])
    }
}

