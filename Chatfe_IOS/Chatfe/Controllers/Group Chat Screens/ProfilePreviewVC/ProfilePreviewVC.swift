//
//  ProfilePreviewVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 28/07/22.
//

import UIKit

protocol ProfilePreviewDelegate: AnyObject {
    func didCloseProfilePreview(result: Bool)
}

class ProfilePreviewVC: BaseViewController {

    public weak var ppDelegate: ProfilePreviewDelegate?
    
    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var imgMatchPref: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblGender: UIButton!
    @IBOutlet weak var lblAge: UIButton!
    @IBOutlet weak var btnAddFriend: UIButton!
    @IBOutlet weak var btnVoteToRemove: UIButton!
    
    lazy var viewModel: ProfilePreviewVM = {
        let obj = ProfilePreviewVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var userID = ""
    var matchPref: MatchPrefData?
//    var profileData: FriendsProfileData?
    var profileData: GCUserProfileData?
    var participantData: ParticipantsData?
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

//        setupUI()
//        hitGetFriendsProfileAPI()
        setupClosure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        hitGetFriendsProfileAPI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - ==== CUSTOM METHODs ====
    func setupUI() {
        if profileData?.isVotedToRemove ?? false {
            self.btnVoteToRemove.setTitle("Cancel Vote to Remove", for: .normal)
        } else {
            self.btnVoteToRemove.setTitle("Vote to Remove", for: .normal)
        }
    }
    
    func hitGetFriendsProfileAPI() {
//        friendProfileViewModel.getFriendsProfile(userId: userID)
        let params = [APIKeys._id: userID, APIKeys.channelID: SelectedVote.channelData?.channelId ?? ""]
        viewModel.eventUserProfile(params: params)
    }
    
    func hitCancelVoteRemoveAPI() {
        let params = ["reportedBy"  : UserDefaultUtility.shared.getUserId() ?? "",
                      "reportedTo"  : SelectedVote.member?._id ?? "",
                      "channelId"   : SelectedVote.channelData?.channelId ?? "",
                      "RoomId"      : SelectedVote.channelData?.roomId ?? ""
        ] as [String : Any]
        self.viewModel.cancelVoteToRemoveAPI(params: params)
    }
    
    func setupClosure() {
        /*
        /// GET & POST MATCH PREFERENCE RESPONSE
        viewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.matchPref = self.viewModel.matchPreferenceResp
                // UPDATE UI
            }
        }
        */
        
        /// GET & POST MATCH PREFERENCE RESPONSE
        viewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.matchPref = self.viewModel.matchPreferenceResp
                if let matchType = self.matchPref?.matchType {
                    self.updateMatchPrefIcon(matchType: matchType)
                }
            }
        }
        
        /// HANDLING RESPONSE - GET FRIENDs PROFILE
//        friendProfileViewModel.reloadListViewClosure = { [weak self] in
        viewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
//                self.profileData = self.friendProfileViewModel.friendsProfileModel?.data?.first
                self.profileData = self.viewModel.userProfileResp?.data
                
                if let matchType = self.profileData?.matchType {
                    self.updateMatchPrefIcon(matchType: matchType)
                }
                
                /// TEMPORARY SAVE USER DATA
                let memberName = "\(self.profileData?.fname ?? "") \(self.profileData?.lname ?? "")"
                let memberData = MemberData(_id         : self.profileData?._id ?? "",
                                            fullname    : memberName,
                                            drinkImg    : self.profileData?.drink?.image ?? "",
                                            matchType   : self.profileData?.matchType ?? "")
                SelectedVote.member = memberData
                
                self.updateUI(data: self.profileData)
                
                // CHANGE VOTE STATUS IF ALREADY VOTED OUT
                if self.profileData?.isVotedToRemove ?? false {
                    self.btnVoteToRemove.setTitle("Cancel Vote to Remove", for: .normal)
                } else {
                    self.btnVoteToRemove.setTitle("Vote to Remove", for: .normal)
                }
            }
        }
        
        // CANCEL VOTE TO REMOVE RESPONSE
        viewModel.reloadMenuClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
//                let msg = self.viewModel.cancelVoteRemoveResp?.message ?? ""
//                self.showBaseAlert(msg)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func updateMatchPrefIcon(matchType: String) {
        switch matchType {
        case MatchPrefType.NoInformation:
            self.imgMatchPref.isHidden = true
            self.imgMatchPref.setImage(string: "")
        case MatchPrefType.MatchMore:
            self.imgMatchPref.isHidden = false
            self.imgMatchPref.image = Images.matchMore
        case MatchPrefType.MatchLess:
            self.imgMatchPref.isHidden = false
            self.imgMatchPref.image = Images.matchLess
        case MatchPrefType.MatchNever:
            self.imgMatchPref.isHidden = false
            self.imgMatchPref.image = Images.matchNever
        default:
            self.imgMatchPref.isHidden = true
            self.imgMatchPref.setImage(string: "")
        }
    }
    
//    func updateUI(data: FriendsProfileData?) {
    func updateUI(data: GCUserProfileData?) {
        if let imgURL = URL(string: data?.profileImg?.image ?? "") {
            self.imgProfilePic.kf.setImage(with: imgURL)
        }
        self.lblUserName.text = "\(data?.fname ?? "") \(data?.lname ?? "")"
        self.lblGender.setTitle(data?.gender?.gen, for: .normal)
        
        if let birthdate = data?.dob?.birthdate {
            let age = calculateAge(age: birthdate)
            self.lblAge.setTitle("\(age) Years Old", for: .normal)
        }
    }
    
    func calculateAge(age: String) -> Int {
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        let currentYear = calendar.component(.year, from: date)
        let prevYear = age.before(first: "-")
        let birthYear = (currentYear) - (Int(prevYear) ?? 0)
        return birthYear
        
    }
    
    func hitMatchPreferenceAPI(matchType: String) {
        let params = ["userId": userID, "matchType": matchType]
//        self.friendProfileViewModel.postUserMatchPreferences(params: params)
        self.viewModel.postUserMatchPreferences(params: params)
    }
    
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.ppDelegate?.didCloseProfilePreview(result: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnViewProfileClicked(_ sender: UIButton) {
        let friendsProfileVC = kHomeStoryboard.instantiateViewController(withIdentifier: FriendsProfileVC.className) as! FriendsProfileVC
        friendsProfileVC.userId = self.profileData?._id ?? ""
        self.navigationController?.pushViewController(friendsProfileVC, animated: true)
    }

    @IBAction func btnAddFriendClicked(_ sender: UIButton) {
        /*if self.profileData?.requestStatus == "" {
            if let senderID = UserDefaultUtility.shared.getUserId(), let receiverID = profileData?._id {
                friendProfileViewModel.sendFriendRequest(senderId: senderID, receiverId: receiverID)
            }
        } else {
            
        }*/
    }

    @IBAction func btnMatchMoreClicked(_ sender: UIButton) {
        hitMatchPreferenceAPI(matchType: MatchPrefType.MatchMore)
    }

    @IBAction func btnMatchLessClicked(_ sender: UIButton) {
        hitMatchPreferenceAPI(matchType: MatchPrefType.MatchLess)
    }
    
    @IBAction func btnMatchNeverClicked(_ sender: UIButton) {
        hitMatchPreferenceAPI(matchType: MatchPrefType.MatchNever)
    }

    @IBAction func btnVoteToRemoveClicked(_ sender: UIButton) {
        let username = "\(profileData?.fname ?? "") \(profileData?.lname ?? "")"
        let roomName = SelectedVote.channelData?.roomName ?? ""
        
        if sender.currentTitle == "Cancel Vote to Remove" {
            // SHOW CUSTOM POP-UP
            let popupVC = kChatStoryboard.instantiateViewController(withIdentifier: PopupViewVC.className) as! PopupViewVC
            popupVC.isVote = false
            popupVC.isCancelVote = true
            popupVC.userID = self.profileData?._id ?? ""
            self.navigationController?.pushViewController(popupVC, animated: false)
            
//            let msg = "Are you sure you want to cancel your vote to remove this user from the chat?"
//            self.showPopupView(show: true, vote: false, title: msg)
            
            /*
            DispatchQueue.main.async {
                UIAlertController.showAlertAction(title: kAppName, message: msg, buttonTitles: [Constants.CancelAlerTitle, "Cancel Vote"]) { selectedIndex in
                    if selectedIndex == 0 {
                        // NOTHING TO DO
                    } else if selectedIndex == 1 {
                        self.hitCancelVoteRemoveAPI()
                    }
                }
            }*/
        } else if sender.currentTitle == "Vote to Remove" {
            
            // SHOW CUSTOM POP-UP
            let popupVC = kChatStoryboard.instantiateViewController(withIdentifier: PopupViewVC.className) as! PopupViewVC
            popupVC.isVote = true
            popupVC.isCancelVote = false
            popupVC.userID = self.profileData?._id ?? ""
            popupVC.fullname = username
            popupVC.roomName = roomName
            popupVC.modalPresentationStyle = .popover
            popupVC.modalTransitionStyle = .crossDissolve

            self.navigationController?.pushViewController(popupVC, animated: false)
            
            
//            let msg = "Would you like to vote to remove \(username) from \(roomName)?"
//            self.showPopupView(show: true, vote: true, title: msg)
            /*
            DispatchQueue.main.async {
                UIAlertController.showAlertAction(title: kAppName, message: msg, buttonTitles: ["Vote to Remove", Constants.No]) { selectedIndex in
                    if selectedIndex == 0 {
                        // VOTE TO REMOVE
                        let voteVC = kChatStoryboard.instantiateViewController(withIdentifier: VoteToRemoveVC.className) as! VoteToRemoveVC
                        voteVC.viewedUserID = self.profileData?._id ?? ""
                        self.navigationController?.pushViewController(voteVC, animated: true)
                    } else if selectedIndex == 1 {
                        // NOTHING TO DO
                    }
                }
            }*/
        }
    }
    

}


