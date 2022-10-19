//
//  EditPrivateRoomVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 15/06/22.
//

import UIKit
import TagListView

protocol EditPrivateRoomDelegate: AnyObject {
    func updatedRoom(updatedData: EditRoomData?)
}

class EditPrivateRoomVC: BaseViewController {
    
    public weak var editRoomDelegate: EditPrivateRoomDelegate?
    
    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var privateRoomTableView: UITableView!
    
    
    lazy var viewModel: CreatePublicRoomViewModel = {
        let obj = CreatePublicRoomViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    //MARK: - ==== VARIABLEs ====
    var roomData: RoomData?
    var categoriesArr = [CategoriesData]()
    var suggestionsList: [SearchGetMovieData]?
    var invitedFriendsDict = [Int: SaveFriendsModel]()
    var names: [String]?
    var ids: [String]?
    var emails = String()
    var isRemoveTags = false
    var updatedRoomData: EditRoomData?
    var isPrivateRoom = false
    
    
    //MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        privateRoomTableView.delegate = self
        privateRoomTableView.dataSource = self
//        self.hideKeyboardWhenTappedAround()
        registerCell()
        defaultInviteeNamesIds()
        setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    //MARK: - ==== CUSTOM METHODs ===
    func defaultInviteeNamesIds() {
        if let names = names, let ids = ids {
            UserDefaultUtility.shared.saveInviteFriendNames(names: names)
            UserDefaultUtility.shared.saveInviteFriendsIDs(ids)
        }
        
        if let emails = self.roomData?.emails {
            UserDefaultUtility.shared.saveInvitedFriendEmail(emails)
        }
    }
    
    func setupClosure() {
        self.viewModel.redirectControllerClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                /// REMOVE SAVED INVITE FRIENDs AND MAILs
                UserDefaultUtility.shared.removeInvitedFriendNames()
                UserDefaultUtility.shared.removeInvitedFriendsIDs()
                UserDefaultUtility.shared.removeInvitedFriendsEmail()
                
                // HANDLING OF UPDATE ROOM RESPONSE
                self.editRoomDelegate?.updatedRoom(updatedData: self.updatedRoomData)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func registerCell() {
        privateRoomTableView.register(UINib(nibName: RoomClassTableViewCell.className, bundle: nil), forCellReuseIdentifier: RoomClassTableViewCell.className)
        privateRoomTableView.register(UINib(nibName: CategoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.identifier)
        privateRoomTableView.register(UINib(nibName: RoomNameTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RoomNameTableViewCell.identifier)
        privateRoomTableView.register(UINib(nibName: InviteFriendsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InviteFriendsTableViewCell.identifier)
//        privateRoomTableView.register(UINib(nibName: DateTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DateTableViewCell.identifier)
        privateRoomTableView.register(UINib(nibName: SelectDateTVC.className, bundle: nil), forCellReuseIdentifier: SelectDateTVC.className)
        privateRoomTableView.register(UINib(nibName: StartTimeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: StartTimeTableViewCell.identifier)
        privateRoomTableView.register(UINib(nibName: DurationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DurationTableViewCell.identifier)
        privateRoomTableView.register(UINib(nibName: ThumbnailTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ThumbnailTableViewCell.identifier)
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        /// REMOVE SAVED INVITE FRIENDs AND MAILs
        UserDefaultUtility.shared.removeInvitedFriendNames()
        UserDefaultUtility.shared.removeInvitedFriendsIDs()
        UserDefaultUtility.shared.removeInvitedFriendsEmail()
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension EditPrivateRoomVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: RoomClassTableViewCell.className, for: indexPath) as! RoomClassTableViewCell
            cell.isEditRoom = true
            cell.selectedRoomClass = roomData?.roomClass ?? ""
            
            /*if roomData?.roomClass == Constants.chat {
                cell.isSelected = true
//                NotificationCenter.default.post(name: Notification.Name.EditRoomClassDefault, object: Constants.chat)
            }*/
//            else {
//                cell.isSelected = false
////                NotificationCenter.default.post(name: Notification.Name.EditRoomClassDefault, object: Constants.watchParty)
//            }
            /*if roomData?.roomClass == "Chat" {
                cell.radioButtonChat.setImage(Images.radioButtonFilled, for: .selected)
                cell.radioButtonWatchParty.setImage(Images.radioButtonEmpty, for: .normal)
            } else {
                cell.radioButtonChat.setImage(Images.radioButtonEmpty, for: .normal)
                cell.radioButtonWatchParty.setImage(Images.radioButtonFilled, for: .normal)
            }*/
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as? CategoryTableViewCell else {
                return UITableViewCell()
            }
            cell.isEditRoom = true
            cell.delegate = self
            
            /// FIND INDEX OF ALL CATEGORY & REMOVE IT
            if let allIndex = categoriesArr.firstIndex(where: {$0.title == "All"}) {
                self.categoriesArr.remove(at: allIndex)
            }
            cell.categories = categoriesArr
            let selectedCategory = self.roomData?.categoryId
            let selectedIndex = categoriesArr.firstIndex(where: {$0._id == selectedCategory})
            cell.selectedRow = selectedIndex
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: RoomNameTableViewCell.identifier) as! RoomNameTableViewCell
            cell.roomNameTextField.text = self.roomData?.roomName
            UserDefaultUtility.shared.saveRoomName(name: self.roomData?.roomName ?? "")
            
            /// FOR IMDB API
            cell.isPrivateRoom = true
            cell.viewModel = self.viewModel
            cell.setupClosure()
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: InviteFriendsTableViewCell.identifier) as! InviteFriendsTableViewCell

            cell.btnInvite.tag = indexPath.row
            cell.btnInvite.addTarget(self, action: #selector(inviteBtnTapped(_:)), for: .touchUpInside)

            cell.friendsTagView.delegate = self
            if !isRemoveTags {
                var strNames = self.names ?? []
                cell.setupTagUI(titles: strNames)
                strNames.removeAll()
            }
            cell.txtEmail.text = self.roomData?.emails
            return cell
        case 4:
            /*let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.identifier) as! DateTableViewCell
            let strEventDate = self.roomData?.startDate ?? ""
            let strDate = self.covertStartDate(strDate: strEventDate)
            cell.addDateBtn.setTitle(strDate, for: .normal)
            UserDefaultUtility.shared.saveDate(date: cell.addDateBtn.title(for: .normal) ?? "")
            cell.parentVC = self*/
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectDateTVC.className) as! SelectDateTVC
            if let strEventDate = self.roomData?.startDate {
//                let strDate = self.covertStartDate(strDate: strEventDate)
                let strDate = strEventDate.serverToLocalTime().extractDate()
                cell.txtDate.text = strDate
                UserDefaultUtility.shared.saveDate(date: strDate)
            }
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StartTimeTableViewCell.identifier) as? StartTimeTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.isEditRoom = true
            /*let selectedTime = self.roomData?.startTime ?? ""
            if cell.timeArr[indexPath.row] == self.roomData?.startTime {
                cell.isSelected = true
            }*/
            
            let strStartDate = self.roomData?.startDate ?? ""
            let localStartDate = strStartDate.serverToLocalTime()
            let selectedTime = localStartDate.getFormattedStartTime()
            if cell.timeArr[indexPath.row] == selectedTime {
                cell.isSelected = true
            }

            let selectedTimeIndex = cell.timeArr.enumerated().first(where: {$0.element == selectedTime})?.offset
            cell.selectedRow = selectedTimeIndex
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: DurationTableViewCell.identifier) as! DurationTableViewCell
            /// DURATION
            NotificationCenter.default.post(name: Notification.Name.EditRoomDurationDefault, object: self.roomData?.duration)
            /// ABOUT
            cell.descriptionTextField.text = self.roomData?.about
            UserDefaultUtility.shared.saveAbout(about: roomData?.about ?? "")
            return cell
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ThumbnailTableViewCell.identifier) as? ThumbnailTableViewCell else {
                return UITableViewCell()
            }
//            cell.isEditRoom = true
            cell.btnUpdateEvent.setTitle(Constants.UpdateEvent, for: .normal)
            if let imageURL = URL(string: self.roomData?.image ?? "") {
                cell.roomImageView.kf.setImage(with: imageURL)
            }
            cell.btnUpdateEvent.addTarget(self, action: #selector(updateBtnTapped), for: .touchUpInside)
            cell.parentVC = self
//            cell.viewModel = createPrivateRoomViewModel
//            cell.createPrivateRoomDelegate = self
//            cell.roomType = "Private"
//            cell.setupClosure()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: RoomClassTableViewCell.className, for: indexPath) as! RoomClassTableViewCell
            if cell.radioButtonChat.isSelected {
                cell.selectedChatRoom()
//                cell.radioButtonWatchParty.isSelected = true
            } else if cell.radioButtonWatchParty.isSelected {
//                cell.radioButtonChat.isSelected = true
                cell.selectedWatchParty()
            }
        case 5:
            break
        default:
            break
        }
    }
    
    @objc func inviteBtnTapped(_ sender: UIButton) {
        let friendsListVC = kHomeStoryboard.instantiateViewController(withIdentifier: InviteFriendsListVC.className) as! InviteFriendsListVC
        friendsListVC.isFromMessages = false
        friendsListVC.inviteDelegate = self
        self.navigationController?.pushViewController(friendsListVC, animated: true)
    }
    
    @objc func updateBtnTapped() {
        if UserDefaultUtility.shared.getCategoryId() == "" {
            self.showBaseAlert(AlertMessage.chooseCategory)
        } else if UserDefaultUtility.shared.getRoomName() == "" {
            self.showBaseAlert(AlertMessage.enterRoomName)
        } else if UserDefaultUtility.shared.getDate() == "" {
            self.showBaseAlert(AlertMessage.chooseDate)
        } else if UserDefaultUtility.shared.getStartTime() == "" {
            self.showBaseAlert(AlertMessage.chooseStartTime)
        } else if UserDefaultUtility.shared.getDuration() == 0.0 {
            self.showBaseAlert(AlertMessage.selectDuration)
        } else if self.roomData?.image == "" {
            self.showBaseAlert(AlertMessage.uploadImage)
        }  else if (UserDefaultUtility.shared.getInviteFriendsIDs() == nil || UserDefaultUtility.shared.getInviteFriendsIDs()?.count == 0) && (UserDefaultUtility.shared.getInvitedFriendsEmail() == nil) && isPrivateRoom {
            self.showBaseAlert(AlertMessage.inviteFriends)
        } else {
            let eventDateTime = "\(UserDefaultUtility.shared.getDate()) \(UserDefaultUtility.shared.getStartTime())"
            let eventDate = eventDateTime.localToServerTime()
            let params = [APIKeys._id         : self.roomData?._id ?? "",
                          APIKeys.categoryId  : UserDefaultUtility.shared.getCategoryId(),
                          APIKeys.roomName    : UserDefaultUtility.shared.getRoomName(),
//                          APIKeys.date        : UserDefaultUtility.shared.getDate(),
//                          APIKeys.startTime   : UserDefaultUtility.shared.getStartTime(),
                          APIKeys.startDate   : eventDate,
                          APIKeys.duration    : UserDefaultUtility.shared.getDuration(),
                          APIKeys.about       : UserDefaultUtility.shared.getAbout() ?? "",
                          APIKeys.roomType    : EventType.Private.rawValue,
                          APIKeys.image       : self.roomData?.image ?? "",
                          APIKeys.roomClass   : UserDefaultUtility.shared.getRoomClass() ?? "",
                          APIKeys.friendsArr  : UserDefaultUtility.shared.getInviteFriendsIDs() ?? [],
                          APIKeys.mails       : UserDefaultUtility.shared.getInvitedFriendsEmail() ?? ""
                        ] as [String: Any]
            
            self.viewModel.updateRoom(params: params)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            return 150
        case 2:
            return 120
        case 3:
            /// Title with Invite Button + dynamic friends tags + email textfield
            let invitedFriendsArr = UserDefaultUtility.shared.getInviteFriendNames() ?? []
            return 135 + CGFloat(invitedFriendsArr.count * 50) + 70
        case 4:
            return UITableView.automaticDimension
        case 5:
//            return 200
            return 150
        case 6:
            return 300
        case 7:
            return 400
        default:
            return UITableView.automaticDimension
        }
    }
    
}

extension EditPrivateRoomVC: InviteFriendsDelegate {
    
    func invitedFriendsDict(dict: [Int : SaveFriendsModel]) {
        self.invitedFriendsDict = dict
        var fullnameArr = [String]()
        var idArr = [String]()
        
        /// DISPLAY TAG IN CELL
        let indexPath = IndexPath(row: 0, section: 3)
        if dict.count > 0 {
            if let cell = self.privateRoomTableView.cellForRow(at: indexPath) as? InviteFriendsTableViewCell {
                fullnameArr = dict.values.compactMap({$0.fullname})
                idArr = dict.values.compactMap({$0.id})
                cell.setupTagUI(titles: fullnameArr)
            }
            
            /// SAVE IDs & Names
            UserDefaultUtility.shared.saveInviteFriendsIDs(idArr)
            UserDefaultUtility.shared.saveInviteFriendNames(names: fullnameArr)
            
            /// RELOAD TABLEVIEW
            self.privateRoomTableView.reloadData()
        }
    }
}

extension EditPrivateRoomVC: TagListViewDelegate {
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        self.isRemoveTags = true
        DispatchQueue.main.async {
            if let names = UserDefaultUtility.shared.getInviteFriendNames(), names.count > 0 {
                for name in names {
                    if title == name {
                        let indexPath = IndexPath(row: 0, section: 3)
                        if let cell = self.privateRoomTableView.cellForRow(at: indexPath) as? InviteFriendsTableViewCell {
                            cell.friendsTagView.removeTag(title)
                            let searchedDict = self.invitedFriendsDict.filter({$0.1.fullname == title})
                            if let matchedKey = searchedDict.first?.key {
                                self.invitedFriendsDict.removeValue(forKey: matchedKey)

                                /// REMOVED OLD SAVE IDs & Names
                                self.names?.removeAll()
                                UserDefaultUtility.shared.removeInvitedFriendsIDs()
                                UserDefaultUtility.shared.removeInvitedFriendNames()
                                
                                let idsArr = self.invitedFriendsDict.values.compactMap({$0.id})
                                let namesArr = self.invitedFriendsDict.values.compactMap({$0.fullname})
                                /// SAVE NEW IDs & Names
                                self.names = namesArr
                                UserDefaultUtility.shared.saveInviteFriendsIDs(idsArr)
                                UserDefaultUtility.shared.saveInviteFriendNames(names: namesArr)
//                                print("SAVED INVITE FRIENDS IDs :> \(idsArr)")
                                
                                self.privateRoomTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}


extension EditPrivateRoomVC: CategorySelectDelegate {
    
    func didSelect(selectedCat: CategoriesData) {
        if let id = selectedCat._id, let title = selectedCat.title {
//            UserDefaultUtility.shared.saveCategoryId(id: id)
            UserDefaultUtility.shared.saveCategoryIdName(id: id, name: title)
        }
    }
}

extension EditPrivateRoomVC: TimeSelectDelegate {
    
    func didSelectTime(time: String) {
        UserDefaultUtility.shared.saveStartTime(time: time)
    }
}


extension EditPrivateRoomVC {
    
    func covertStartDate(strDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.yyMMddTHHmmss // "yyyy-MM-dd'T'HH:mm:ss"
        let eventDate = dateFormatter.date(from: strDate) ?? Date()
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = DateFormats.MMddyyyy // "MM-dd-yyyy"
        let strConvertedDate = dateFormatter1.string(from: eventDate)
        return strConvertedDate
    }
    
}


extension EditPrivateRoomVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaultUtility.shared.saveRoomName(name: textField.text ?? "")
    }
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count ?? 0 >= 3 {
            self.viewModel.getMovieSuggestions(searchText: string)
            return true
        }
        
        return false
    }*/
}
