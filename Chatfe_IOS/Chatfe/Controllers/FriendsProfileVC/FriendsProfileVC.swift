//
//  FriendsProfileVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 13/06/22.
//

import UIKit

class FriendsProfileVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var sendRequestImage: UIButton!
    @IBOutlet weak var profileTableView: UITableView!
    
    lazy var viewModel: FriendsProfileVM = {
        let obj = FriendsProfileVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    // MARK: - ==== VARIABLEs ====
    var userId = ""
    var isFromMyProfile = false
    var isFromRoom = false
    var isFromSearch = false
    var isFromRecentSearch = false
    var profileData: [FriendsProfileData]? {
        didSet {
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
            }
        }
    }
    var matchPref = [MatchPrefOptions.Match_More, MatchPrefOptions.Match_Less, MatchPrefOptions.Match_Never]
    var matchPrefValue = [MatchPrefType.MatchMore, MatchPrefType.MatchLess, MatchPrefType.MatchNever]
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sendRequestImage.isHidden = true
        profileTableView.delegate = self
        profileTableView.dataSource = self
        registerCell()
        self.viewModel.getFriendsProfile(userId: self.userId)
        setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func updateMatchPrefFlagUI(matchType: String) {
        DispatchQueue.main.async {
//            let matchType = self.profileData?.first?.matchType ?? ""
            guard let cell = self.profileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileImageTableViewCell else { return }
            switch matchType {
            case MatchPrefType.MatchMore:
                cell.preferenceIcon.isHidden = false
                cell.preferenceIcon.image = Images.matchMore
            case MatchPrefType.MatchLess:
                cell.preferenceIcon.isHidden = false
                cell.preferenceIcon.image = Images.matchLess
            case MatchPrefType.MatchNever:
                cell.preferenceIcon.isHidden = false
                cell.preferenceIcon.image = Images.matchNever
            case MatchPrefType.NoInformation:
                cell.preferenceIcon.isHidden = true
            default:
                cell.preferenceIcon.isHidden = true
            }
        }
    }
    
    func registerCell() {
        profileTableView.register(UINib(nibName: ProfileImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileImageTableViewCell.identifier)
        profileTableView.register(UINib(nibName: ProfileNameTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileNameTableViewCell.identifier)
        profileTableView.register(UINib(nibName: FriendChatOptionsTVC.className, bundle: nil), forCellReuseIdentifier: FriendChatOptionsTVC.className)
        profileTableView.register(UINib(nibName: DrinkTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DrinkTableViewCell.identifier)
        profileTableView.register(UINib(nibName: FriendsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FriendsTableViewCell.identifier)
        profileTableView.register(UINib(nibName: AboutSectionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AboutSectionTableViewCell.identifier)
    }
    
    func hitMatchPreferenceAPI(matchType: String) {
        let params = ["userId": userId, "matchType": matchType]
        self.viewModel.postUserMatchPreferences(params: params)
    }
    
    func setupClosure() {
        /// HANDLING RESPONSE - GET FRIENDs PROFILE
        viewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.profileData = self.viewModel.friendsProfileModel?.data
                self.updateMatchPrefFlagUI(matchType: self.profileData?.first?.matchType ?? "")
                /// HIT ADD RECENT SEARCH API IF FROM SEARCH RESULT
                if self.isFromSearch && !self.isFromRecentSearch {
                    let params = ["categoryId"  : self.profileData?.first?._id ?? "",
                                  "fname"       : self.profileData?.first?.fname ?? "",
                                  "lname"       : self.profileData?.first?.lname ?? "",
                                  "type"        : "User",
                                  "image"       : self.profileData?.first?.profileImg?.image ?? ""
                                ]
                    self.viewModel.addRecentSearch(params: params)
                }
            }
        }
        
        /// SEND FRIEND REQUEST API RESPONSE
        viewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                // CHANGE BUTTON NAME
                if let cell = self.profileTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? FriendChatOptionsTVC {
                    cell.btnAddFriend.setTitle("Request Sent", for: .normal)
                    cell.btnAddFriend.isUserInteractionEnabled = false
                }

                if let message = self.viewModel.sendFriendRequestModel?.data {
                    self.showBaseAlert(message)
                }
            }
        }
        
        /// MATCH PREFERENCE API RESPONSE
        viewModel.reloadListViewClosure1 = { [weak self] in
            guard let self = self else { return }
            if let matchType = self.viewModel.matchPreferenceResp?.matchType {
                self.updateMatchPrefFlagUI(matchType: matchType)
            }
        }
        
    }
    
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addFriendClicked(_ sender: UIButton) {
        self.viewModel.sendFriendRequest(senderId: UserDefaultUtility.shared.getUserId() ?? "", receiverId: self.userId)
    }
        
    @IBAction func optionBtnClicked(_ sender: UIButton) {
        let data = profileData?.first
        let requestStatus = data?.requestStatus ?? ""
        if requestStatus == "" || requestStatus == FriendRequestStatus.Pending.rawValue || requestStatus == FriendRequestStatus.PendingToAccept.rawValue {
            if let friendID = data?._id, let requestStatus = data?.requestStatus, let isBlocked = data?.isBlocked {
                self.navigateToBottomOptionVC(friendID: friendID, requestStatus: requestStatus, isBlocked: isBlocked, isFromOptionButton: true)
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


// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE ====
extension FriendsProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    @objc func friendButtonTapped(_ sender: UIButton) {
        let data = profileData?[sender.tag]
        if let friendID = data?._id, let requestStatus = data?.requestStatus, let isBlocked = data?.isBlocked {
            self.navigateToBottomOptionVC(friendID: friendID, requestStatus: requestStatus, isBlocked: isBlocked, isFromOptionButton: false)
        }
    }
    
    @objc func respondButtonTapped(_ sender: UIButton) {
        let data = profileData?[sender.tag]
        if let friendID = data?._id, let requestStatus = data?.requestStatus, let isBlocked = data?.isBlocked {
            self.navigateToBottomOptionVC(friendID: friendID, requestStatus: requestStatus, isBlocked: isBlocked, isFromOptionButton: false)
        }
    }
    
    @objc func addFriendButtonTapped(_ sender: UIButton) {
        if let cell = self.profileTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? FriendChatOptionsTVC {
            if cell.btnAddFriend.currentTitle == "Add Friend" {
                self.viewModel.sendFriendRequest(senderId: UserDefaultUtility.shared.getUserId() ?? "", receiverId: self.userId)
            }
        }
    }
    
    @objc func messageBtnTapped() {
        let chatVC = kHomeStoryboard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
        chatVC.chatID = profileData?.first?.chatHeadId ?? ""
        chatVC.receiverID = profileData?.first?._id ?? ""
        chatVC.receiverName = "\(profileData?.first?.fname ?? "") \(profileData?.first?.lname ?? "")"
        chatVC.receiverImg = profileData?.first?.profileImg?.image ?? ""
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @objc func showPopupForAlreadySentRequest() {
        DispatchQueue.main.async {
            self.showBaseAlert("Friend Request has already been sent.")
        }
    }
    
    @objc func didSelectMatchPref(_ sender: UIButton) {
        let vc = kHomeStoryboard.instantiateViewController(withIdentifier: PickerViewBottomVC.className) as! PickerViewBottomVC
        vc.pickerDelegate = self
        vc.modalPresentationStyle = .popover
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileData = profileData?[indexPath.row]
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageTableViewCell.className, for: indexPath) as! ProfileImageTableViewCell
            cell.editProfileBtn.isHidden = true
            if let imageUrl = URL(string: profileData?.profileImg?.image ?? "") {
                cell.profileImageView.kf.setImage(with: imageUrl)
            }
            
            cell.profilePicBtn.tag = indexPath.row
            cell.profilePicBtn.addTarget(self, action: #selector(didSelectMatchPref(_:)), for: .touchUpInside)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNameTableViewCell.className, for: indexPath) as! ProfileNameTableViewCell
            cell.nameLbl.text = "\(profileData?.fname ?? "") \(profileData?.lname ?? "")"
            cell.descriptionLbl.text = profileData?.aboutYourself
            return cell
        case 2:
            if self.userId != UserDefaultUtility.shared.getUserId() {
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendChatOptionsTVC.className, for: indexPath) as! FriendChatOptionsTVC
            let requestStatus = profileData?.requestStatus
            if requestStatus == FriendRequestStatus.Pending.rawValue {
                cell.btnAddFriend.setTitle("Request Sent", for: .normal)
                cell.btnAddFriend.addRightIcon(image: UIImage(named: ""), status: false)
                cell.btnAddFriend.isUserInteractionEnabled = true
                cell.btnAddFriend.addTarget(self, action: #selector(showPopupForAlreadySentRequest), for: .touchUpInside)
            } else if requestStatus == FriendRequestStatus.Confirmed.rawValue {
                cell.btnAddFriend.setTitle("Friends", for: .normal)
                cell.btnAddFriend.addRightIcon(image: Images.downArrow, status: true)
                cell.btnAddFriend.isUserInteractionEnabled = true
                cell.btnAddFriend.addTarget(self, action: #selector(friendButtonTapped(_:)), for: .touchUpInside)
            } else if requestStatus == FriendRequestStatus.PendingToAccept.rawValue {
                cell.btnAddFriend.setTitle("Respond", for: .normal)
                cell.btnAddFriend.addRightIcon(image: Images.downArrow, status: true)
                cell.btnAddFriend.isUserInteractionEnabled = true
                cell.btnAddFriend.addTarget(self, action: #selector(respondButtonTapped(_:)), for: .touchUpInside)
            } else if requestStatus == "" {
                cell.btnAddFriend.setTitle("Add Friend", for: .normal)
                cell.btnAddFriend.addRightIcon(image: UIImage(named: ""), status: false)
                cell.btnAddFriend.isUserInteractionEnabled = true
                cell.btnAddFriend.addTarget(self, action: #selector(addFriendButtonTapped(_:)), for: .touchUpInside)
            }

            cell.btnMessage.addTarget(self, action: #selector(messageBtnTapped), for: .touchUpInside)
                return cell
            } else {
                return UITableViewCell()
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: DrinkTableViewCell.identifier) as! DrinkTableViewCell
            cell.btnEdit.isHidden = true
            cell.showDrinkImage(image: profileData?.drink?.image)
            cell.drinkLbl.text = profileData?.drink?.drinkName
             return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier) as! FriendsTableViewCell
            cell.isUsersFriends = true
            cell.usersFriends = profileData?.friends
            cell.parentVC = self
            cell.btnViewAll.tag = indexPath.row
            cell.btnViewAll.addTarget(self, action: #selector(viewAllButtonTapped(_:)), for: .touchUpInside)
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: AboutSectionTableViewCell.identifier) as! AboutSectionTableViewCell
            cell.btnEdit.isHidden = true
            if updatePrivacyUI(privacy: profileData?.dating?.privacy ?? "") {
                cell.datingLbl.text = profileData?.dating?.datings != "" ? profileData?.dating?.datings : "NA"
            } else {
                cell.datingLbl.text = "***"
            }
            if updatePrivacyUI(privacy: profileData?.gender?.privacy ?? "") {
                cell.identityLbl.text = profileData?.gender?.gen != "" ? profileData?.gender?.gen : "NA"
            } else {
                cell.identityLbl.text = "****"
            }
            if updatePrivacyUI(privacy: profileData?.hometown?.privacy ?? "") {
                cell.hometownLbl.text = profileData?.hometown?.homeTown != "" ? profileData?.hometown?.homeTown : "NA"
            } else {
                cell.hometownLbl.text = "*****"
            }
            if updatePrivacyUI(privacy: profileData?.dob?.privacy ?? "") {
                if let birthDate = profileData?.dob?.birthdate {
                    cell.calculateAge(age: birthDate)
                } else {
                    cell.ageLbl.text = "NA"
                }
            } else {
                cell.ageLbl.text = "***"
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func updatePrivacyUI(privacy: String) -> Bool {
        // UPDATE UI FOR ACCOUNT VISIBILITY
        let requestStatus = self.profileData?.first?.requestStatus ?? ""
        if privacy == "Friends" {
            if requestStatus == FriendRequestStatus.Confirmed.rawValue {
                return true
            } else {
                return false
            }
        } else if privacy == "All" {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 125
        case 1:
            return 125
        case 2:
            return self.userId == UserDefaultUtility.shared.getUserId() ? 0 : 80
        case 3:
            return 125
        case 4:
            return profileData?[indexPath.row].friends?.count == 0 ? 120 : 215
        case 5:
            return 500
        default:
            return UITableView.automaticDimension
        }
    }
    
    @objc func viewAllButtonTapped(_ sender: UIButton) {
        let allFriendsVC = kHomeStoryboard.instantiateViewController(withIdentifier: AllFriendsVC.className) as! AllFriendsVC
        allFriendsVC.profileData = self.profileData?[sender.tag].friends ?? []
        allFriendsVC.isFriendsUserList = true
        self.navigationController?.pushViewController(allFriendsVC, animated: true)
    }
}


extension FriendsProfileVC: FriendRequestsDelegate {
    
    func didUnFriend(status: Bool) {
        if status {
            self.viewModel.getFriendsProfile(userId: self.userId)
        }
    }
    
    func didAcceptRequest(status: Bool) {
        if status {
            self.viewModel.getFriendsProfile(userId: self.userId)
        }
    }
    
    func didRejectRequest(status: Bool) {
        if status {
            self.viewModel.getFriendsProfile(userId: self.userId)
        }
    }
    
    func didBlockUser(status: Bool) {
        self.viewModel.getFriendsProfile(userId: self.userId)
    }
}


extension FriendsProfileVC: CustomPickerViewDelegate {
    
    func didSelectPickerValue(row: Int) {
        self.hitMatchPreferenceAPI(matchType: matchPrefValue[row])
    }
}
