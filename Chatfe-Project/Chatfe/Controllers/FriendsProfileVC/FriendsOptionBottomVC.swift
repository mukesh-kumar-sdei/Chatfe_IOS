//
//  FriendsOptionBottomVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 08/07/22.
//

import UIKit

protocol FriendRequestsDelegate: AnyObject {
    func didUnFriend(status: Bool)
    func didAcceptRequest(status: Bool)
    func didRejectRequest(status: Bool)
    func didBlockUser(status: Bool)
}

class FriendsOptionBottomVC: BaseViewController {
    
    public weak var friendRequestDelegate: FriendRequestsDelegate?
    
    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    lazy var viewModel: FriendsProfileVM = {
        let obj = FriendsProfileVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    lazy var notificationViewModel: NotificationsActivityVM = {
        let obj = NotificationsActivityVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    private var userId = ""
    var friendID = ""
//    var isAlreadyFriend = false
    var isFrom3dotButton = false
    var requestStatus = ""
    var isUserBlocked = false
    var isFriend = false
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userId = UserDefaultUtility.shared.getUserId() ?? ""
        setupUI()
        setupClosure()
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func setupUI() {
        
        /// WHEN CLICKED ON 3 DOT OPTION BUTTON
        if isFrom3dotButton && !isFriend && !isUserBlocked {
            self.button1.setTitle("Block", for: .normal)
            self.button2.setTitle("Cancel", for: .normal)
        } else if isFrom3dotButton && !isFriend && isUserBlocked {
            self.button1.setTitle("Unblock", for: .normal)
            self.button2.setTitle("Cancel", for: .normal)
        }
        
        /// WHEN CLICKED ON 'Add Friend' BUTTON
        if !isUserBlocked && !isFrom3dotButton {
            switch requestStatus {
            case FriendRequestStatus.Empty.rawValue, FriendRequestStatus.Pending.rawValue:
                break
            case FriendRequestStatus.PendingToAccept.rawValue:  // RESPOND CASE
                self.button1.setTitle("Accept", for: .normal)
                self.button2.setTitle("Reject", for: .normal)
            case FriendRequestStatus.Confirmed.rawValue:
                self.button1.setTitle("Unfriend", for: .normal)
                self.button2.setTitle("Block", for: .normal)
            default:
                break
            }
        } else if isUserBlocked && !isFrom3dotButton {
            switch requestStatus {
            case FriendRequestStatus.Empty.rawValue, FriendRequestStatus.Pending.rawValue:
                break
            case FriendRequestStatus.PendingToAccept.rawValue:
                self.button1.setTitle("Accept", for: .normal)
                self.button2.setTitle("Reject", for: .normal)
            case FriendRequestStatus.Confirmed.rawValue:
                self.button1.setTitle("Unfriend", for: .normal)
                self.button2.setTitle("Unblock", for: .normal)
            default:
                break
            }
        }
        
        /*
        /// USER IS FRIEND & NOT BLOCKED
//        if isAlreadyFriend && !isUserBlocked {
        if isFriend && !isUserBlocked {
            self.button1.setTitle("Unfriend", for: .normal)
            self.button2.setTitle("Block", for: .normal)
        }
        /// USER IS FRIEND & BLOCKED
//        else if isAlreadyFriend && isUserBlocked {
        if isFriend && isUserBlocked {
            self.button1.setTitle("Unfriend", for: .normal)
            self.button2.setTitle("Unblock", for: .normal)
        }
        /// USER IS NOT FRIEND & NOT BLOCKED
        else if !isFriend && !isUserBlocked {
            self.button1.setTitle("Block", for: .normal)
            self.button2.setTitle("Cancel", for: .normal)
        }
        /// USER IS NOT FRIEND & BLOCKED
        else if !isFriend && isUserBlocked {
            self.button1.setTitle("Unblock", for: .normal)
            self.button2.setTitle("Cancel", for: .normal)
        } else {
            self.button1.setTitle("Accept", for: .normal)
            self.button2.setTitle("Reject", for: .normal)
        }
        */
    }
    
    func setupClosure() {
        /// UNFRIEND RESPONSE
        viewModel.reloadMenuClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.friendRequestDelegate?.didUnFriend(status: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        // ACCEPT & REJECT FRIEND REQUEST RESPONSE
        notificationViewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.notificationViewModel.acceptModel?.status == APIKeys.success {
                    self.friendRequestDelegate?.didAcceptRequest(status: true)
                } else if self.notificationViewModel.rejectModel?.status == APIKeys.success {
                    self.friendRequestDelegate?.didRejectRequest(status: true)
                }
                self.dismiss(animated: true)
            }
        }
        
        // BLOCK & UNBLOCK USER RESPONSE
        viewModel.reloadMenuClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.viewModel.blockUserResp?.status == APIKeys.success {
                    self.friendRequestDelegate?.didBlockUser(status: true)
                    self.dismiss(animated: true, completion: nil)
                } else if self.viewModel.unblockUserResp?.status == APIKeys.success {
                    self.friendRequestDelegate?.didBlockUser(status: false)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    // MARK: - ==== IBACTIONs ====
    @IBAction func dismissBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnUnfriendClicked(_ sender: UIButton) {
        if sender.currentTitle == "Unfriend" {
            self.viewModel.unFriendRequest(userId: userId, friendID: friendID)
        } else if sender.currentTitle == "Accept" {
            self.notificationViewModel.acceptFriendRequest(userId: "", senderId: userId, receiverId: friendID)
        } else if sender.currentTitle == "Block" {
            self.viewModel.blockUser(id: friendID)
        } else if sender.currentTitle == "Unblock" {
            self.viewModel.unblockUser(id: friendID)
        }
    }
    
    @IBAction func btnBlockClicked(_ sender: UIButton) {
        if sender.currentTitle == "Block" {
            self.viewModel.blockUser(id: friendID)
        } else if sender.currentTitle == "Unblock" {
            self.viewModel.unblockUser(id: friendID)
        } else if sender.currentTitle == "Reject" {
            self.notificationViewModel.rejectFriendRequest(userId: "", senderId: userId, receiverId: friendID)
        } else if sender.currentTitle == "Cancel" {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
