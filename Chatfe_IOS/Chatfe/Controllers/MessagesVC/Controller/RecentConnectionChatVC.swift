//
//  RecentConnectionChatVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 30/06/22.
//

import UIKit
import IQKeyboardManager

class RecentConnectionChatVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var lblFriendsNameTitle: UILabel!
    @IBOutlet weak var recentChatTableView: UITableView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var chatViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtEnterMessage: CustomTextField!
    @IBOutlet weak var btnSend: UIButton!
    /*
    lazy var viewModel: MessagesViewModel = {
        let obj = MessagesViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    */
    lazy var friendViewModel: FriendsProfileVM = {
        let obj = FriendsProfileVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
//    var profileDetails: RecentSuggestions?
    private var recentConnDetails: RecentConnectionDetailModel?
    private var profileData: [FriendsProfileData]?
    var friendsName = ""
    var friendId = ""
    var name: String?
//    var getMessagesData: [GetMessageModel]?
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        initTableView()
        registerNIBs()
        setupClosure()
        handleKeyboardObservers()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().isEnabled = true
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        hitRecentConnectionsAPI()
        self.friendViewModel.getFriendsProfile(userId: self.friendId)
    }
    
    
    // MARK: - ==== CUSTOM METHODs ====
    func initTableView() {
        self.recentChatTableView.isScrollEnabled = false
        self.recentChatTableView.dataSource = self
        self.recentChatTableView.delegate = self
    }
    
    func hitRecentConnectionsAPI() {
        if let userID = UserDefaultUtility.shared.getUserId() {
            self.friendViewModel.recentConnectionDetails(userID: userID, recentUserID: friendId)
        }
    }
    
    func setupUI() {
        DispatchQueue.main.async {
            self.lblFriendsNameTitle.text = self.friendsName
            
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
    
    func handleKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().isEnabled = false
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
                self.recentChatTableView.contentOffset = CGPoint(x: 0, y: self.recentChatTableView.contentOffset.y - delta)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardHide(notification: Notification) {
        let beginFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let delta = ((kbSize?.origin.y)! - (beginFrame?.origin.y)!) as CGFloat
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: TimeInterval(truncating: duration), delay: 0.0, options: UIView.AnimationOptions(rawValue: UInt(truncating: curve)), animations: {
                self.chatViewTopConstraint.constant  = 80.0
                self.chatViewBottomConstraint.constant = 0.0
                self.recentChatTableView.contentOffset = CGPoint(x: 0, y: self.recentChatTableView.contentOffset.y - delta)
                self.view.layoutIfNeeded()
            })
        }
    }
    // -----------------------------------
    
    func registerNIBs() {
        recentChatTableView.register(UINib(nibName: ProfileImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileImageTableViewCell.identifier)
        recentChatTableView.register(UINib(nibName: ProfileNameTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileNameTableViewCell.identifier)
        recentChatTableView.register(UINib(nibName: AddFriendButtonTVC.className, bundle: nil), forCellReuseIdentifier: AddFriendButtonTVC.className)
    }
    
    
    func setupClosure() {
        
        /*viewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.getMessagesData = self.viewModel.getMessageResp
//                print("---> Successfully Sent Message")
            }
        }*/
        
        /// RECENT CONNECTION DETAILS API RESPONSE
//        viewModel.reloadMenuClosure = { [weak self] in
        friendViewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.recentConnDetails = self.friendViewModel.recentConnDetails
                self.recentChatTableView.reloadData()
            }
        }
        
        /// HANDLING RESPONSE - GET FRIENDs PROFILE
        friendViewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.profileData = self.friendViewModel.friendsProfileModel?.data
                let requestStatus = self.profileData?.first?.requestStatus ?? ""
//                self.recentChatTableView.reloadData()
                guard let cell = self.recentChatTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? AddFriendButtonTVC else { return }
                self.updateFriendRequestStatus(requestStatus: requestStatus, btn: cell.btnAddFriend, lbl: cell.lblAddFriend)
            }
        }
        
        /// SEND FRIEND REQUEST API RESPONSE
        friendViewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.friendViewModel.getFriendsProfile(userId: self.friendId)
//                guard let cell = self.recentChatTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? AddFriendButtonTVC else { return }
//                cell.lblAddFriend.text = "Request Sent"
                
//                if let message = self.friendViewModel.sendFriendRequestModel?.data {
//                    self.showBaseAlert(message)
//                }
            }
        }
    }

    // MARK: - ==== IBACTIONs ====
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func optionsButtonTapped(_ sender: UIButton) {
        //
    }
    
    @IBAction func addFileButtonTapped(_ sender: UIButton) {
        //
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        //
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        if self.txtEnterMessage.text?.count != 0 {
//            let receiverID = profileDetails?._id ?? ""
            let data = profileData?.first
            let receiverName = "\(data?.fname ?? "") \(data?.lname ?? "")"
            let receiverImg = data?.profileImg?.image ?? ""
//            let isOnline = data?.isOnline ?? false
            let chatID = data?.chatHeadId ?? ""
            if chatID.count == 0 {
                self.friendViewModel.createNewChatAPI(receiverID: friendId, message: self.txtEnterMessage.text ?? "")
            } else {
                self.friendViewModel.sendTextMessageAPI(chatID: chatID, receiverID: friendId, message: self.txtEnterMessage.text ?? "", type: "message")
                self.txtEnterMessage.text = ""
                self.txtEnterMessage.resignFirstResponder()
                self.navigateToChatVC(chatId: chatID, rID: friendId, rName: receiverName, rImage: receiverImg, isFromRecentConn: true, isOnline: false)
            }
        }
    }
    
    func navigateToChatVC(chatId: String, rID: String, rName: String, rImage: String, isFromRecentConn: Bool, isOnline: Bool?) {
        let chatVC = kHomeStoryboard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
        chatVC.isFromRecentConnections = isFromRecentConn
        chatVC.isOnline = isOnline ?? false
        chatVC.chatID = chatId
        chatVC.receiverID = rID
        chatVC.receiverName = rName
        chatVC.receiverImg = rImage
        self.navigationController?.pushViewController(chatVC, animated: false)
    }
}


// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension RecentConnectionChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageTableViewCell.identifier) as! ProfileImageTableViewCell
            cell.editProfileBtn.isHidden = true
            if let imageURL = URL(string: recentConnDetails?.data?.profileImg ?? "") {
                cell.profileImageView.kf.setImage(with: imageURL)
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNameTableViewCell.identifier) as! ProfileNameTableViewCell
            cell.selectionStyle = .none
            cell.nameLbl.text = "\(recentConnDetails?.data?.fname ?? "") \(recentConnDetails?.data?.lname ?? "")"
            /*
            let elapsedTime = recentConnDetails?.data?.joinedDate ?? ""
            let dateFormatter = DateFormatter()
            let customDate = dateFormatter.date(from: elapsedTime)
            let strElapsedTime = customDate?.getElapsedInterval()
            */
            cell.descriptionLbl.text = "Connected at \(recentConnDetails?.data?.connectedAt ?? "")"
//            cell.setupView()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddFriendButtonTVC.className) as! AddFriendButtonTVC
            cell.selectionStyle = .none
            cell.btnAddFriend.tag = indexPath.row
//            cell.btnAddFriend.addTarget(self, action: #selector(addFriendBtnTapped(_:)), for: .touchUpInside)
            let status = self.recentConnDetails?.data?.requestStatus ?? ""
//            let status = self.profileData?[indexPath.row].requestStatus ?? ""
            updateFriendRequestStatus(requestStatus: status, btn: cell.btnAddFriend, lbl: cell.lblAddFriend)
            return cell
        default:
            return UITableViewCell() 
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 125
        case 1:
            return 125
        case 2:
            return 110
        default:
            return UITableView.automaticDimension
        }
    }
    
//    @objc func addFriendBtnTapped(_ sender: UIButton) {
//        if sender.currentTitle == "Add Friend" {
//            friendViewModel.sendFriendRequest(senderId: UserDefaultUtility.shared.getUserId() ?? "", receiverId: profileDetails?._id ?? "")
//        } else if sender.currentTitle == "Request Sent" {
//            self.showBaseAlert("Friend Request has already been sent.")
//        }
//    }
    
}


extension RecentConnectionChatVC {
    
    func updateFriendRequestStatus(requestStatus: String, btn: UIButton, lbl: UILabel) {
        if requestStatus == FriendRequestStatus.Pending.rawValue {
//            btn.setTitle("Request Sent", for: .normal)
            lbl.text = "Request Sent"
//            btn.addRightIcon(image: UIImage(named: ""), status: false)
            btn.isUserInteractionEnabled = true
            btn.addTarget(self, action: #selector(showPopupForAlreadySentRequest), for: .touchUpInside)
        } else if requestStatus == FriendRequestStatus.Confirmed.rawValue {
//            btn.setTitle("Friends", for: .normal)
//            btn.addRightIcon(image: Images.downArrow, status: true)
            lbl.text = "Friends"
            btn.isUserInteractionEnabled = true
            btn.addTarget(self, action: #selector(friendButtonTapped(_:)), for: .touchUpInside)
        } else if requestStatus == FriendRequestStatus.PendingToAccept.rawValue {
//            btn.setTitle("Respond", for: .normal)
            lbl.text = "Respond"
//            btn.addRightIcon(image: Images.downArrow, status: true)
            btn.isUserInteractionEnabled = true
            btn.addTarget(self, action: #selector(respondButtonTapped(_:)), for: .touchUpInside)
        } else if requestStatus == "" {
            lbl.text = "Add Friend"
//            btn.setTitle("Add Friend", for: .normal)
//            btn.addRightIcon(image: UIImage(named: ""), status: false)
            btn.isUserInteractionEnabled = true
            btn.addTarget(self, action: #selector(addFriendButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc func showPopupForAlreadySentRequest() {
        DispatchQueue.main.async {
            self.showBaseAlert("Friend Request has already been sent.")
        }
    }
    
    @objc func friendButtonTapped(_ sender: UIButton) {
        let data = profileData?[sender.tag]
        if let requestStatus = data?.requestStatus, let isBlocked = data?.isBlocked {
            self.navigateToBottomOptionVC(friendID: friendId, requestStatus: requestStatus, isBlocked: isBlocked, isFromOptionButton: false)
        }
    }

    @objc func respondButtonTapped(_ sender: UIButton) {
        let data = profileData?[sender.tag]
        if let requestStatus = data?.requestStatus, let isBlocked = data?.isBlocked {
            self.navigateToBottomOptionVC(friendID: friendId, requestStatus: requestStatus, isBlocked: isBlocked, isFromOptionButton: false)
        }
    }

    @objc func addFriendButtonTapped(_ sender: UIButton) {
        if let cell = self.recentChatTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? AddFriendButtonTVC {
//            if cell.btnAddFriend.currentTitle == "Add Friend" {
            if cell.lblAddFriend.text == "Add Friend" {
                self.friendViewModel.sendFriendRequest(senderId: UserDefaultUtility.shared.getUserId() ?? "", receiverId: friendId)
            }
        }
    }
    
    func navigateToBottomOptionVC(friendID: String, requestStatus: String, isBlocked: Bool, isFromOptionButton: Bool) {
        let bottomVC = kHomeStoryboard.instantiateViewController(withIdentifier: FriendsOptionBottomVC.className) as! FriendsOptionBottomVC
        bottomVC.friendID = friendID
        bottomVC.friendRequestDelegate = self
        
        bottomVC.isFrom3dotButton = isFromOptionButton
        bottomVC.isFriend = requestStatus == FriendRequestStatus.Confirmed.rawValue ? true : false
        bottomVC.isUserBlocked = isBlocked
        bottomVC.requestStatus = requestStatus
        
        bottomVC.modalPresentationStyle = .popover
        bottomVC.modalTransitionStyle = .crossDissolve
        present(bottomVC, animated: true, completion: nil)
    }
}

extension RecentConnectionChatVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEnterMessage {
            txtEnterMessage.resignFirstResponder()
            return true
        } else {
            return false
        }
    }
}

extension RecentConnectionChatVC: FriendRequestsDelegate {
    
    func didUnFriend(status: Bool) {
        if status {
            self.friendViewModel.getFriendsProfile(userId: friendId)
        }
    }
    
    func didBlockUser(status: Bool) {
        if status {
            self.friendViewModel.getFriendsProfile(userId: friendId)
        }
    }
    
    func didAcceptRequest(status: Bool) {
        if status {
            self.friendViewModel.getFriendsProfile(userId: friendId)
        }
    }
    
    func didRejectRequest(status: Bool) {
        if status {
            self.friendViewModel.getFriendsProfile(userId: friendId)
        }
    }
    
    
}
