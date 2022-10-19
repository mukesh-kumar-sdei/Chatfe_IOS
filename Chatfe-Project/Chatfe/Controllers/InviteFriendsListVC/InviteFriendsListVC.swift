//
//  InviteFriendsListVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 16/06/22.
//

import UIKit

protocol InviteFriendsDelegate: AnyObject {
    func invitedFriendsDict(dict: [Int: SaveFriendsModel])
}

class InviteFriendsListVC: BaseViewController {

    public weak var inviteDelegate: InviteFriendsDelegate?
    
    //MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    @IBOutlet weak var lblSelectedFriendsCount: UILabel!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var lblNotFound: UILabel!
    
    lazy var viewModel: CreatePublicRoomViewModel = {
        let obj = CreatePublicRoomViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    lazy var blockViewModel: BlockListVM = {
        let obj = BlockListVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var friendsList = [SenderIdData]()
    var filteredFriendsList = [SenderIdData]()
    var inviteFriendsDict = [Int: SaveFriendsModel]()
    var isSearchActive = false
    var selectedIndexPath = IndexPath()
    private var selectedRows = [Int]()
    var isFromMessages = false
    
    
    //MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaultUtility.shared.removeInvitedFriendsIDs()
        UserDefaultUtility.shared.removeInvitedFriendNames()
        
        self.lblNotFound.isHidden = true
        self.friendsTableView.dataSource = self
        self.friendsTableView.delegate = self
//        self.friendsTableView.allowsSelection = isFromMessages
        self.lblSelectedFriendsCount.isHidden = isFromMessages
        self.btnDone.isHidden = isFromMessages
        
        enableDoneButton(enabled: false)
        
        registerNIB()
        viewModel.getAllFriendsList()
        setupClosure()
        
        // SEARCH BAR
        friendsSearchBar.delegate = self
//        hideKeyboardWhenTappedAround()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK: - ==== CUSTOM METHODs ====
    func registerNIB() {
        self.friendsTableView.register(UINib(nibName: InviteFriendsListCell.className, bundle: nil), forCellReuseIdentifier: InviteFriendsListCell.className)
    }
    
    func enableDoneButton(enabled: Bool) {
        if enabled {
            self.btnDone.isUserInteractionEnabled = true
            self.btnDone.backgroundColor = AppColor.appBlueColor
            self.btnDone.setTitleColor(.white, for: .normal)
        } else {
            self.btnDone.isUserInteractionEnabled = false
            self.btnDone.backgroundColor = AppColor.appBlueColor.withAlphaComponent(0.7)
            self.btnDone.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        }
    }
    
    func setupClosure() {
        /// FRIENDS LIST RESPONSE
        viewModel.reloadMenuClosure  = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                                
                if self.isFromMessages{
                    let listOfFriend = self.viewModel.friendsList?.data ?? []
                        for i in listOfFriend{
                            if i.isBlocked == false{
                                self.friendsList.append(i)
                            }
                        }
                }else{
                    self.friendsList = self.viewModel.friendsList?.data ?? []
                }
                
                if self.friendsList.count > 0 {
                    self.lblNotFound.text = ""
                    self.lblNotFound.isHidden = true
                } else {
                    self.lblNotFound.text = AlertMessage.noFriendsinyourlist
                    self.lblNotFound.isHidden = false
                }
                self.friendsTableView.reloadData()
            }
        }
        

        /// UNBLOCK USER RESPONSE & ADD TO INVITED LIST
        blockViewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let friend = (self.filteredFriendsList.count > 0 && self.isSearchActive) ? self.filteredFriendsList[self.selectedIndexPath.row] : self.friendsList[self.selectedIndexPath.row]
                let fullname = "\(friend.fname ?? "") \(friend.lname ?? "")"
                let friendsData = SaveFriendsModel(id: friend._id, fullname: fullname, profileImg: friend.profileImg?.image)
                self.inviteFriendsDict[self.selectedIndexPath.row] = friendsData
                
//                self.lblSelectedFriendsCount.text = "\(self.inviteFriendsDict.count) Selected"
                self.lblSelectedFriendsCount.text = "\(self.inviteFriendsDict.count)" + Constants.Selected
                self.enableDoneButton(enabled: self.inviteFriendsDict.count > 0 ? true : false)
            }
        }
    }

    //MARK: - ==== IBACTIONs ====
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if self.inviteFriendsDict.count > 0 {
            self.inviteDelegate?.invitedFriendsDict(dict: self.inviteFriendsDict)
            self.navigationController?.popViewController(animated: true)
        }
    }
}


// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension InviteFriendsListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if filteredFriendsList.count > 0 {
            return filteredFriendsList.count
        } else {
            return friendsList.count
        }*/
        print("filteredFriendsList",filteredFriendsList.count)
        print("friendsList",friendsList.count)
        return (filteredFriendsList.count > 0 && isSearchActive) ? filteredFriendsList.count : friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InviteFriendsListCell.className, for: indexPath) as! InviteFriendsListCell
        cell.selectionStyle = .none
        
        let friend = (filteredFriendsList.count > 0 && isSearchActive) ? filteredFriendsList[indexPath.row] : friendsList[indexPath.row]
        cell.lblFriendName.text = "\(friend.fname ?? "") \(friend.lname ?? "")"
        if let imageUrl = URL(string: friend.profileImg?.image ?? "") {
            cell.friendImage.kf.setImage(with: imageUrl)
        }
        
        cell.btnSelect.isHidden = isFromMessages
        cell.btnSelect.tag = indexPath.row
        cell.btnSelect.addTarget(self, action: #selector(checkBtnTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromMessages {
            let friend = friendsList[indexPath.row]
            let chatID = friend.chatHeadId ?? ""
            let rID = friend._id ?? ""
            let rName = "\(friend.fname ?? "") \(friend.lname ?? "")"
            let rImage = friend.profileImg?.image ?? ""
            self.navigateToChatVC(chatId: chatID, rID: rID, rName: rName, rImage: rImage, isFromRecentConn: false)
        } else {
            self.selectedIndexPath = indexPath
            didUpdateUI(indexPath: indexPath, selected: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if !isFromMessages {
            didUpdateUI(indexPath: indexPath, selected: false)
        }
    }
    
    @objc func checkBtnTapped(_ sender: UIButton) {
        if !isFromMessages {
            let indexPath = IndexPath(row: sender.tag, section: 0)
            if selectedRows.contains(sender.tag) {
                self.didUpdateUI(indexPath: indexPath, selected: false)
                if let index = selectedRows.firstIndex(of: sender.tag) {
                    self.selectedRows.remove(at: index)
                }
            } else {
                selectedRows.append(sender.tag)
                selectedIndexPath = indexPath
                didUpdateUI(indexPath: indexPath, selected: true)
            }
        }
    }
    
    func didUpdateUI(indexPath: IndexPath, selected: Bool) {
//        let friend = self.friendsList[indexPath.row]
        let friend = (filteredFriendsList.count > 0 && isSearchActive) ? filteredFriendsList[indexPath.row] : friendsList[indexPath.row]
        let fullname = "\(friend.fname ?? "") \(friend.lname ?? "")"
        let friendsData = SaveFriendsModel(id: friend._id, fullname: fullname, profileImg: friend.profileImg?.image)
        
        if let cell = self.friendsTableView.cellForRow(at: indexPath) as? InviteFriendsListCell {
            if !selected {
                cell.btnSelect.setImage(Images.ellipsedEmpty, for: .normal)
                self.inviteFriendsDict.removeValue(forKey: indexPath.row)
            } else {
                cell.btnSelect.setImage(Images.ellipsedFilled, for: .normal)
                
                // CHECK FOR BLOCKED USER - TO SHOW POPUP & UNBLOCK IF USER WANTs
                let isBlockedUserInvited = checkUserBlocked(indexPath: indexPath, friend: friend, selected: selected)
                if !isBlockedUserInvited {
                    self.inviteFriendsDict[indexPath.row] = friendsData
                }
            }
//                    self.lblSelectedFriendsCount.text = "\(self.inviteFriendsDict.count) Selected"
            self.lblSelectedFriendsCount.text = "\(self.inviteFriendsDict.count)" + Constants.Selected
            self.enableDoneButton(enabled: self.inviteFriendsDict.count > 0 ? true : false)
        }
    }
    
    func checkUserBlocked(indexPath: IndexPath, friend: SenderIdData, selected: Bool) -> Bool {
        if selected && friend.isBlocked ?? false {
            DispatchQueue.main.async {
                UIAlertController.showAlertAction(title: kAppName, message: AlertMessage.triedBlockUserInvite, buttonTitles: [Constants.CancelAlerTitle, Constants.Unblock]) { selectedIndex in
                    if selectedIndex == 0 {
                        // UNSELECT ICON
                        if let cell = self.friendsTableView.cellForRow(at: indexPath) as? InviteFriendsListCell {
                            cell.btnSelect.setImage(Images.ellipsedEmpty, for: .normal)
                            self.inviteFriendsDict.removeValue(forKey: indexPath.row)
                        }
                    } else if selectedIndex == 1 {
                        // HIT UNBLOCK API
                        self.blockViewModel.unblockUser(id: friend._id ?? "")
                    }
                }
            }
            return true
        } else {
            return false
        }
    }
}


// MARK: - ==== SEARCHBAR DELEGATE METHODs ====
extension InviteFriendsListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
//            self.lblNotFound.text = "No Friends Found"
//            self.lblNotFound.isHidden = false
            clearSearchedData()
        } else {
            self.lblNotFound.text = ""
            self.lblNotFound.isHidden = true
            self.searchData(searchText: searchText)
        }
    }
    
    func searchData(searchText: String) {
        /// SEARCH DATA
        self.filteredFriendsList = self.friendsList.filter({($0.fname?.localizedCaseInsensitiveContains(searchText) ?? false) || ($0.lname?.localizedCaseInsensitiveContains(searchText) ?? false)})
        DispatchQueue.main.async {
            self.isSearchActive = self.filteredFriendsList.count > 0 ? true : false
            self.friendsTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.clearSearchedData()
        searchBar.resignFirstResponder()
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.clearSearchedData()
        if let searchText = searchBar.text, searchText.count > 1 {
            self.searchData(searchText: searchText)
        }
        searchBar.resignFirstResponder()
    }
    
    func clearSearchedData() {
        DispatchQueue.main.async {
            self.isSearchActive = false
            self.filteredFriendsList.removeAll()
            self.friendsTableView.reloadData()
        }
    }
}


extension InviteFriendsListVC {
    
    func navigateToChatVC(chatId: String, rID: String, rName: String, rImage: String, isFromRecentConn: Bool) {
        let chatVC = kHomeStoryboard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
        chatVC.isFromRecentConnections = isFromRecentConn
        chatVC.chatID = chatId
        chatVC.receiverID = rID
        chatVC.receiverName = rName
        chatVC.receiverImg = rImage
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
}
