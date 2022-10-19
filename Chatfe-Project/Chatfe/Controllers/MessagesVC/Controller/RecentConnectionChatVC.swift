//
//  RecentConnectionChatVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 30/06/22.
//

import UIKit

class RecentConnectionChatVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var lblFriendsNameTitle: UILabel!
    @IBOutlet weak var recentChatTableView: UITableView!
    @IBOutlet weak var txtEnterMessage: CustomTextField!
    @IBOutlet weak var btnSend: UIButton!
    
    lazy var viewModel: MessagesViewModel = {
        let obj = MessagesViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    lazy var friendViewModel: FriendsProfileVM = {
        let obj = FriendsProfileVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var profileDetails: RecentSuggestions?
    var recentConnDetails: RecentConnectionDetailModel?
    var name: String?
    var getMessagesData: [GetMessageModel]?
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtEnterMessage.backgroundColor = .black
        self.txtEnterMessage.tintColor = .white
        self.txtEnterMessage.textColor = .white
        self.txtEnterMessage.maxLength = 200
        
        self.lblFriendsNameTitle.text = "\(profileDetails?.fname ?? "") \(profileDetails?.lname ?? "")"
        
        self.recentChatTableView.isScrollEnabled = false
        self.recentChatTableView.dataSource = self
        self.recentChatTableView.delegate = self
        registerNIBs()
        
        // HIT API
        if let userID = UserDefaultUtility.shared.getUserId(), let friendID = self.profileDetails?._id {
            self.viewModel.recentConnectionDetails(userID: userID, recentUserID: friendID)
        }
        
        setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func registerNIBs() {
        recentChatTableView.register(UINib(nibName: ProfileImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileImageTableViewCell.identifier)
        recentChatTableView.register(UINib(nibName: ProfileNameTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileNameTableViewCell.identifier)
        recentChatTableView.register(UINib(nibName: AddFriendButtonTVC.className, bundle: nil), forCellReuseIdentifier: AddFriendButtonTVC.className)
    }
    
    func setupClosure() {
        viewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.getMessagesData = self.viewModel.getMessageResp
//                print("---> Successfully Sent Message")
            }
        }
        
        /// RECENT CONNECTION DETAILS API RESPONSE
        viewModel.reloadMenuClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.recentConnDetails = self.viewModel.recentConnDetails
                let friendRequestStatus = self.recentConnDetails?.data?.requestStatus ?? ""
                guard let cell = self.recentChatTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? AddFriendButtonTVC else {return}
                if friendRequestStatus == FriendRequestStatus.Confirmed.rawValue {
                    cell.btnAddFriend.setTitle("Friends", for: .normal)
                } else if friendRequestStatus == FriendRequestStatus.Pending.rawValue {
                    cell.btnAddFriend.setTitle("Request Sent", for: .normal)
                }/* else if friendRequestStatus == FriendRequestStatus.PendingToAccept.rawValue {
                    cell.btnAddFriend.setTitle("Respond", for: .normal)
                } else if friendRequestStatus == "" {
                    cell.btnAddFriend.setTitle("Add Friend", for: .normal)
                }*/
                self.recentChatTableView.reloadData()
            }
        }
        
        /// SEND FRIEND REQUEST API RESPONSE
        friendViewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let cell = self.recentChatTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? AddFriendButtonTVC else {return}
                cell.btnAddFriend.setTitle("Request Sent", for: .normal)
//                cell.btnAddFriend.isUserInteractionEnabled = false
                
                if let message = self.friendViewModel.sendFriendRequestModel?.data {
                    self.showBaseAlert(message)
                }
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
            let receiverID = profileDetails?._id ?? ""
            let receiverName = "\(profileDetails?.fname ?? "") \(profileDetails?.lname ?? "")"
            let receiverImg = profileDetails?.profileImg ?? ""
            let isOnline = profileDetails?.isOnline ?? false
            let chatID = profileDetails?.chatHeadId ?? ""
            if chatID.count == 0 {
                self.viewModel.createNewChatAPI(receiverID: receiverID, message: self.txtEnterMessage.text ?? "")
            } else {
                self.viewModel.sendTextMessageAPI(chatID: chatID, receiverID: receiverID, message: self.txtEnterMessage.text ?? "", type: "message")
                self.txtEnterMessage.text = ""
                self.txtEnterMessage.resignFirstResponder()
                self.navigateToChatVC(chatId: chatID, rID: receiverID, rName: receiverName, rImage: receiverImg, isFromRecentConn: false, isOnline: isOnline)
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
            cell.btnAddFriend.addTarget(self, action: #selector(addFriendBtnTapped(_:)), for: .touchUpInside)
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
    
    @objc func addFriendBtnTapped(_ sender: UIButton) {
        if sender.currentTitle == "Add Friend" {
            friendViewModel.sendFriendRequest(senderId: UserDefaultUtility.shared.getUserId() ?? "", receiverId: profileDetails?._id ?? "")
        } else if sender.currentTitle == "Request Sent" {
            self.showBaseAlert("Friend Request has already been sent.")
        }
    }
    
}
