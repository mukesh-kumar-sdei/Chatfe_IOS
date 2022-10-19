//
//  PopupViewVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 22/08/22.
//

import UIKit

class PopupViewVC: BaseViewController {
    
    // MARK: ==== IBOUTLETs ====
    @IBOutlet weak var customPopup: UIView!
    @IBOutlet weak var buttonStackBottom: NSLayoutConstraint!
    @IBOutlet weak var lblPopupMsg: UILabel!
    @IBOutlet weak var btnPopupDetails: UIButton!
    @IBOutlet weak var btnPopupVote2Remove: UIButton!
    @IBOutlet weak var btnPopupNo: UIButton!
    
    lazy var viewModel: ProfilePreviewVM = {
        let obj = ProfilePreviewVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var isVote = false
    var isCancelVote = false
    var userID = ""
    var fullname = ""
    var roomName = ""
    private var selectedColor = ""
    
    // MARK: ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        setupClosures()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: ==== CUSTOM METHODs ====
    func updateUI() {
        
        /// MAPPING COLOR
        if let index = SelectedVote.memberList.firstIndex(where: {$0.id == userID}) {
            if let colorCode = SelectedVote.memberList[index].color {
                self.selectedColor = colorCode
            }
        }
        
        /// ATTRIBUTED TEXT
        let boldFont = UIFont(name: AppFont.ProximaNovaBold, size: 20.0) ?? UIFont.boldSystemFont(ofSize: 20.0)
        let senderColor = UIColor(selectedColor)
        let attributedNameColor = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: senderColor]
        let attributedTextColor = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributedString1 = NSMutableAttributedString(string: "Would you like to vote to remove", attributes: attributedTextColor)
        let attributedString2 = NSMutableAttributedString(string: " \(fullname) ", attributes: attributedNameColor)
        let attributedString3 = NSMutableAttributedString(string: "from \(roomName)?", attributes: attributedTextColor)
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        
        if isVote && !isCancelVote {
            self.lblPopupMsg.attributedText = attributedString1
//            self.lblPopupMsg.text = "Would you like to vote to remove \(fullname) from \(roomName)?"
            self.btnPopupDetails.setTitle("Details", for: .normal)
            self.btnPopupVote2Remove.setTitle("Vote to Remove", for: .normal)
            self.btnPopupNo.isHidden = false
//            self.buttonStackBottom.constant = 60.0
            self.buttonStackBottom.constant = 80.0
            self.view.layoutIfNeeded()
        } else if isCancelVote && !isVote {
            self.lblPopupMsg.text = "Are you sure you want to cancel your vote to remove this user from the chat?"
            self.btnPopupDetails.setTitle("Cancel", for: .normal)
            self.btnPopupVote2Remove.setTitle("Cancel Vote", for: .normal)
            self.btnPopupNo.isHidden = true
            self.buttonStackBottom.constant = 20.0
            self.view.layoutIfNeeded()
        }
    }
    
    func setupClosures() {
        // CANCEL VOTE TO REMOVE RESPONSE
        viewModel.reloadMenuClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    func hitCancelVoteRemoveAPI() {
        let params = ["reportedBy"  : UserDefaultUtility.shared.getUserId() ?? "",
                      "reportedTo"  : SelectedVote.member?._id ?? "",
                      "channelId"   : SelectedVote.channelData?.channelId ?? "",
                      "RoomId"      : SelectedVote.channelData?.roomId ?? ""
        ] as [String : Any]
        self.viewModel.cancelVoteToRemoveAPI(params: params)
    }
    
    // MARK: ==== IBACTIONs ====
    @IBAction func btnDetailsClicked(_ sender: UIButton) {
        if sender.currentTitle == "Details" {
            let friendsProfileVC = kHomeStoryboard.instantiateViewController(withIdentifier: FriendsProfileVC.className) as! FriendsProfileVC
            friendsProfileVC.userId = self.userID
            friendsProfileVC.modalTransitionStyle = .crossDissolve
            self.navigationController?.pushViewController(friendsProfileVC, animated: true)
        } else if sender.currentTitle == "Cancel" {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func btnVote2RemoveClicked(_ sender: UIButton) {
        if sender.currentTitle == "Vote to Remove" {
            let voteVC = kChatStoryboard.instantiateViewController(withIdentifier: VoteToRemoveVC.className) as! VoteToRemoveVC
            voteVC.viewedUserID = self.userID
            self.navigationController?.pushViewController(voteVC, animated: true)
        } else if sender.currentTitle == "Cancel Vote" {
            self.hitCancelVoteRemoveAPI()
        }
    }
    
    @IBAction func btnNoClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
}



