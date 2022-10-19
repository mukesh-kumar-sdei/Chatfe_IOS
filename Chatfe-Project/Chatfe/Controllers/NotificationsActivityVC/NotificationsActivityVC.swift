//
//  NotificationsActivityVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 14/06/22.
//

import UIKit

class NotificationsActivityVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    lazy var viewModel: NotificationsActivityVM = {
        let obj = NotificationsActivityVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var allRequestsData: NotificationsData? {
        didSet {
            DispatchQueue.main.async {
                self.activityTableView.reloadData()
            }
        }
    }
    var selectedRow = 0
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        activityTableView.delegate = self
        activityTableView.dataSource = self
        activityTableView.allowsSelection = true
        registerCell()
//        hitGetAllNotificationsAPI()
//        setupClosure()
    }
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.badgeCount = 0
        NotificationCenter.default.post(name: Notification.Name.PUSH_NOTIFICATION_COUNT, object: delegate.badgeCount)
        hitGetAllNotificationsAPI()
        setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    // MARK: - ==== CUSTOM METHODs ====
    func registerCell() {
        activityTableView.register(UINib(nibName: HeaderCell.className, bundle: nil), forCellReuseIdentifier: HeaderCell.className)
        activityTableView.register(UINib(nibName: FriendRequestTableViewCell.className, bundle: nil), forCellReuseIdentifier: FriendRequestTableViewCell.className)
        activityTableView.register(UINib(nibName: BirthdayTableViewCell.className, bundle: nil), forCellReuseIdentifier: BirthdayTableViewCell.className)
        activityTableView.register(UINib(nibName: InvitesTableViewCell.className, bundle: nil), forCellReuseIdentifier: InvitesTableViewCell.className)
    }
    
    func hitGetAllNotificationsAPI() {
        self.viewModel.getAllNotifications()
    }
    
    func setupClosure() {
        /// ALL NOTIFICATIONs RESPONSE
        viewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                
                self.allRequestsData = self.viewModel.allNotificationData
                if self.allRequestsData?.friendResult?.count == 0 && self.allRequestsData?.privateRoomResult?.count == 0
                    && self.allRequestsData?.userCreatedResult?.count == 0 && self.allRequestsData?.joinedRoomResult?.count == 0 && self.allRequestsData?.birthdayResults?.count == 0 {
                    self.lblNoDataFound.text = AlertMessage.noNotificationsReceived
                    self.lblNoDataFound.isHidden = false
                } else {
                    self.lblNoDataFound.text = ""
                    self.lblNoDataFound.isHidden = true
                }
                self.activityTableView.reloadData()
            }
        }
        
        /// REJECT, ACCEPT & JOIN ROOM RESPONSE
        viewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hitGetAllNotificationsAPI()
            }
        }
    }
    

    // MARK: - ==== IBACTIONs ====
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        UIApplication.shared.applicationIconBadgeNumber = 0
//        NotificationCenter.default.post(name: Notification.Name("HOME_NOTIFICATION_TAPPED"), object: 0)
        self.navigationController?.popViewController(animated: true)
    }

}


// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE ====
extension NotificationsActivityVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return 8
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            // HEADER
            return self.allRequestsData?.friendResult?.count ?? 0 > 0 ? 1 : 0
        case 1:
            return self.allRequestsData?.friendResult?.count ?? 0
        case 2:
            // HEADER
            return self.allRequestsData?.privateRoomResult?.count ?? 0 > 0 ? 1 : 0
        case 3:
            return self.allRequestsData?.privateRoomResult?.count ?? 0
        case 4:
            // HEADER
            return (self.allRequestsData?.userCreatedResult?.count ?? 0) > 0 ? 1 : 0
        case 5:
            return (self.allRequestsData?.userCreatedResult?.count ?? 0)
        case 6:
            // HEADER
            return (self.allRequestsData?.birthdayResults?.count ?? 0) > 0 ? 1 : 0
        case 7:
            return (self.allRequestsData?.birthdayResults?.count ?? 0)
        case 8:
            // HEADER
            return (self.allRequestsData?.joinedRoomResult?.count ?? 0) > 0 ? 1 : 0
        case 9:
            return (self.allRequestsData?.joinedRoomResult?.count ?? 0)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // FRIEND REQUEST HEADER
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.className, for: indexPath) as! HeaderCell
            cell.lblHeaderName.text = Constants.friendRequestsTitle
            return cell
        case 1: // FRIEND REQUEST DATA
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendRequestTableViewCell.className, for: indexPath) as! FriendRequestTableViewCell
            cell.selectionStyle = .none
            let data = self.allRequestsData?.friendResult?[indexPath.row]
            let fullname = "\(data?.senderData?.fname ?? "") \(data?.senderData?.lname ?? "")"
            
            /// TIME CONVERSION
            let createdAt = data?.createdAt ?? ""
            let localDate = createdAt.serverToLocalTime()
            let requestedTime = localDate.extractStartTime(DateFormats.hhmm_a)
            
            // ATTRIBUTED STRING
            cell.lblFriendName.attributedText = setCustomAttributedText(fullname: fullname, otherText: " has sent you a friend request. ", requestedTime: requestedTime)

            if let imageURL = URL(string: data?.senderData?.image ?? "") {
                cell.imgFriendProfile.kf.setImage(with: imageURL)
            }
            
            cell.btnAccept.tag = indexPath.row
            cell.btnAccept.addTarget(self, action: #selector(acceptBtnTapped(_:)), for: .touchUpInside)
            
            cell.btnReject.tag = indexPath.row
            cell.btnReject.addTarget(self, action: #selector(rejectBtnTapped(_:)), for: .touchUpInside)
            
            return cell
        case 2: // INVITES HEADER
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.className, for: indexPath) as! HeaderCell
            cell.lblHeaderName.text = Constants.invitesTitle
            return cell
        case 3: // INVITES DATA
            let cell = tableView.dequeueReusableCell(withIdentifier: InvitesTableViewCell.className, for: indexPath) as! InvitesTableViewCell
            cell.selectionStyle = .none
            let data = self.allRequestsData?.privateRoomResult?[indexPath.row]
            let fullname = "\(data?.senderData?.fname ?? "") \(data?.senderData?.lname ?? "")"
            
            /// TIME CONVERSION
            let createdAt = data?.createdAt ?? ""
            let localDate = createdAt.serverToLocalTime()
            let requestedTime = localDate.extractStartTime(DateFormats.hhmm_a)
            
            // ATTRIBUTED STRING
            cell.lblFriendName.attributedText = setCustomAttributedText(fullname: fullname, otherText: Constants.invitedPrivateRoom, requestedTime: requestedTime)
            
            if let imageURL = URL(string: data?.senderData?.image ?? "") {
                cell.imgFriendProfile.kf.setImage(with: imageURL)
            }
            
            cell.btnJoin.tag = indexPath.row
            cell.btnJoin.addTarget(self, action: #selector(joinBtnTapped(_:)), for: .touchUpInside)
            
            return cell
        case 4:
            // HEADER
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.className, for: indexPath) as! HeaderCell
            cell.lblHeaderName.text = "Created Rooms"
            return cell
        case 5:
            // CREATED ROOMs DATA
            let cell = tableView.dequeueReusableCell(withIdentifier: BirthdayTableViewCell.className) as! BirthdayTableViewCell
            cell.selectionStyle = .none
            let data = self.allRequestsData?.userCreatedResult?[indexPath.row]
            
            /// TIME CONVERSION
            let createdAt = data?.roomCreationTime ?? ""
            let localDate = createdAt.serverToLocalTime()
            let creationTime = localDate.extractStartTime(DateFormats.hhmm_a)
            
            let creatorName = "\(data?.creatorfname ?? "") \(data?.creatorlname ?? "")"
            let createdRoomText = " has created '\(data?.roomName ?? "")' room.\n"
            cell.lblText.attributedText = setCustomAttributedText(fullname: creatorName, otherText: createdRoomText, requestedTime: creationTime)
            if let imageURL = URL(string: data?.creatorProfileImg ?? "") {
                cell.imgIcon.kf.setImage(with: imageURL)
            }
            
            return cell
        case 6:
            // HEADER
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.className, for: indexPath) as! HeaderCell
//            cell.lblHeaderName.text = "Joined Rooms"
            cell.lblHeaderName.text = "Birthday"
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: BirthdayTableViewCell.className) as! BirthdayTableViewCell
            cell.selectionStyle = .none
            let data = self.allRequestsData?.birthdayResults?[indexPath.row]
            cell.lblText.textColor = .white
            
            /// TIME CONVERSION
            let createdAt = data?.createdAt ?? ""
            let localDate = createdAt.serverToLocalTime()
            let creationTime = localDate.extractStartTime(DateFormats.hhmm_a)
            
            cell.lblText.attributedText = setCustomAttributedText(fullname: "Happy Birthday", otherText: data?.message?.replace(target: "Happy Birthday", withString: "") ?? "", requestedTime: creationTime)
            cell.imgIcon.image = UIImage(named: "birthday_icon")
            return cell
        case 8:
            // HEADER
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.className, for: indexPath) as! HeaderCell
            cell.lblHeaderName.text = "Joined Rooms"
            return cell
        case 9:
            // CREATED ROOMs DATA
            let cell = tableView.dequeueReusableCell(withIdentifier: BirthdayTableViewCell.className) as! BirthdayTableViewCell
            cell.selectionStyle = .none
            let data = self.allRequestsData?.joinedRoomResult?[indexPath.row]
            
            /// TIME CONVERSION
            let createdAt = data?.roomJoiningTime ?? ""
            let localDate = createdAt.serverToLocalTime()
            let creationTime = localDate.extractStartTime(DateFormats.hhmm_a)
            
            let creatorName = "\(data?.senderData?.fname ?? "") \(data?.senderData?.lname ?? "")"
            let createdRoomText = " has joined '\(data?.roomName ?? "")' room.\n"
            cell.lblText.attributedText = setCustomAttributedText(fullname: creatorName, otherText: createdRoomText, requestedTime: creationTime)
            if let imageURL = URL(string: data?.senderData?.image ?? "") {
                cell.imgIcon.kf.setImage(with: imageURL)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 50.0
        case 1:
            return UITableView.automaticDimension
        case 2:
            return 50.0
        case 3:
            return 80.0
        case 5:
            return 80.0
        case 7:
            return 80.0
        case 9:
            return 80.0
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section % 2 != 0) && indexPath.section != 1 {
            var roomID = ""
            let nextVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: EventDetailViewController.className) as! EventDetailViewController
            switch indexPath.section {
            case 3:
                roomID = self.allRequestsData?.privateRoomResult?[indexPath.row].roomId ?? ""
            case 5:
                roomID = self.allRequestsData?.userCreatedResult?[indexPath.row].roomId ?? ""
            case 9:
                roomID = self.allRequestsData?.joinedRoomResult?[indexPath.row].roomId ?? ""
            default:
                roomID = ""
            }
            nextVC.id = roomID
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func acceptBtnTapped(_ sender: UIButton) {
        self.selectedRow = sender.tag
        if let id = self.allRequestsData?.friendResult?[sender.tag]._id {
            self.viewModel.acceptFriendRequest(userId: id, senderId: "", receiverId: "")
        }
    }
    
    @objc func rejectBtnTapped(_ sender: UIButton) {
        self.selectedRow = sender.tag
        if let id = self.allRequestsData?.friendResult?[sender.tag]._id {
            self.viewModel.rejectFriendRequest(userId: id, senderId: "", receiverId: "")
        }
    }
    
    @objc func joinBtnTapped(_ sender: UIButton) {
        self.selectedRow = sender.tag
        if let roomId = self.allRequestsData?.privateRoomResult?[sender.tag].roomId {
            let params = [APIKeys.roomId:   roomId,
                          APIKeys.userId:   UserDefaultUtility.shared.getUserId() ?? ""
                         ] as [String:Any]
            self.viewModel.joinRoom(params: params)
        }
    }
}


extension NotificationsActivityVC {
    
    func setCustomAttributedText(fullname: String, otherText: String, requestedTime: String) -> NSMutableAttributedString {
        // ATTRIBUTED STRING
        let customFont = UIFont(name: AppFont.ProximaNovaRegular, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        let attributedFont = [NSAttributedString.Key.font: customFont]
        let attributedBoldFont = [NSAttributedString.Key.font: UIFont(name: AppFont.ProximaNovaBold, size: 16.0) ?? UIFont.boldSystemFont(ofSize: 16.0)]
        let attributedTimeFontColor = [NSAttributedString.Key.font: customFont, NSAttributedString.Key.foregroundColor: UIColor.gray]
        
        let attributedString1 = NSMutableAttributedString(string: fullname, attributes: attributedBoldFont)
        let attributedString2 = NSMutableAttributedString(string: otherText, attributes: attributedFont)
        let attributedString3 = NSMutableAttributedString(string: requestedTime, attributes: attributedTimeFontColor)
        
        attributedString2.append(attributedString3)
        attributedString1.append(attributedString2)
        
        return attributedString1
    }
}
