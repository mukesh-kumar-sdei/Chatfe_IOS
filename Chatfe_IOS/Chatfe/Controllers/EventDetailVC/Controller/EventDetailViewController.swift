//
//  EventDetailViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 05/05/22.
//

import UIKit
import Kingfisher

protocol EventDetailsDelegate: AnyObject {
    func didJoinRoom(row: Int, status: Bool)
    func didUnjoinRoom(row: Int, status: Bool)
    func didDeleteRoom(status: Bool)
}

class EventDetailViewController: BaseViewController {
    
    public weak var eventDelegate: EventDetailsDelegate?
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var optionBtn: UIButton!
    
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var viewRoomClass: UIView!
    @IBOutlet weak var roomClassIcon: UIImageView!
    @IBOutlet weak var lblRoomClass: UILabel!
    @IBOutlet weak var btnRoomClass: UIButton!
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    
    lazy var eventDetailViewModel: EventDetailViewModel = {
       let obj = EventDetailViewModel(userService: UserService())
        return obj
    }()
    
    lazy var homePageViewModel: HomePageViewModel = {
        let obj = HomePageViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var id = ""
    var eventDetail: RoomData!
    var categoriesArr = [CategoriesData]()
//    var hasJoinedRoom = false
    var selectedRow = 0
    var isFromSettings = false
    var friendsArr = [UserListData]()
    var joinedUsersArr = [SenderIdData]()
    var eventType = ""
    var invitedFriendsDict = [Int: SaveFriendsModel]()
    var isFromSearch = false
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

//        if eventType == "Public" {
        if eventType == EventType.Public.rawValue {
//            self.optionBtn.isUserInteractionEnabled = false
            self.optionBtn.isHidden = true
        } else {
//            self.optionBtn.isUserInteractionEnabled = true
            self.optionBtn.isHidden = false
        }
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        self.addBtn.isHidden = isFromSettings
        registerNIBs()
        hitGetRoomAPI(id: id)
        setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func registerNIBs() {
        self.friendsTableView.register(UINib(nibName: HeaderCell.className, bundle: nil), forCellReuseIdentifier: HeaderCell.className)
        self.friendsTableView.register(UINib(nibName: EventUserListTVC.className, bundle: nil), forCellReuseIdentifier: EventUserListTVC.className)
    }
    
    func hitGetRoomAPI(id: String) {
        if isFromSettings {
            self.eventDetailViewModel.getUsersListWithRoomDetails(roomId: self.id)
        } else {
            let params = [APIKeys._id: id]
            eventDetailViewModel.getRoom(params: params)
        }
    }
    
    func setupUI(eventData: RoomData) {
        DispatchQueue.main.async {
            /// SHOWING EVENT NAME & DESCRIPTION
            self.eventName.text = self.eventDetail.roomName
            self.descriptionLbl.text = self.eventDetail.about
            
            /// SHOWING EVENT IMAGE
            if let urlString = eventData.image {
                let imageUrl = URL(string: urlString)
                self.eventImage.kf.setImage(with: imageUrl)
            }
            
            /// TIMEZONE CONVERSIONs - SHOW DATE & TIME
            if let strStartDate = self.eventDetail.startDate, let strEndDate = self.eventDetail.endDate {
                let localStartDate = strStartDate.serverToLocalTime()
                let eventDate = localStartDate.extractDate()
                let startTime = localStartDate.extractStartTime()
                
                let localEndDate = strEndDate.serverToLocalTime()
                let endTime = localEndDate.extractStartTime()
                
                /// CHECK FOR TODAY's DATE
                let currentDate = currentDateTime()
                let eventUTCDate = returnUTCDate(date: localStartDate)
                let result = Calendar.current.compare(eventUTCDate, to: currentDate, toGranularity: .day)
                if result == .orderedSame {
                    self.eventTime.text = "Today from \(startTime) - \(endTime)"
                } else {
                    self.eventTime.text = "\(startTime) - \(endTime) | \(eventDate)"
                }
            }
            
            /// CHECK ROOM JOINED OR NOT
            if ((self.eventDetail.hasRoomJoined ?? false) ) {
                self.addBtn.setImage(Images.circleTick, for: .normal)
            } else {
                self.addBtn.setImage(Images.circleAdd, for: .normal)
            }
            
            /// CHECK ROOM CLASS TO SHOW TEXT AND ITS IMAGE
            if eventData.roomClass == Constants.chat {
                self.lblRoomClass.text = (eventData.roomClass ?? "") + Constants.Room
                self.roomClassIcon.image = Images.chatRoomIcon
            } else if (eventData.roomClass ?? "").localizedCaseInsensitiveContains(Constants.watch) {
                self.lblRoomClass.text = Constants.watchParty
                self.roomClassIcon.image = Images.watchPartyIcon
            }
        }
    }
    
    @objc func redirectToGroupChat() {
        let openGrpEventVC = kChatStoryboard.instantiateViewController(withIdentifier: EventGroupChatVC.className) as! EventGroupChatVC
        self.navigationController?.pushViewController(openGrpEventVC, animated: true)
    }
    
    func setupClosure() {
        /// EVENT DATA RESPONSE & EVENT DETAILs USERLIST RESPONSE
        eventDetailViewModel.reloadListViewClosure  = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let eventData = self.eventDetailViewModel.eventDataResponse?.data {
                    self.eventDetail = eventData
                    self.homePageViewModel.getCategories()
                    /// [START] - ENABLING ROOM CLASS BUTTON FOR GROUP CHAT
                    let isOngoingEvent = self.checkOnGoingEvent(strStartDate: eventData.startDate, strEndDate: eventData.endDate)
                    if isOngoingEvent {
                        self.viewRoomClass.backgroundColor = AppColor.appBlueColor
                        self.btnRoomClass.isUserInteractionEnabled = true
                        //TODO: - ADD TARGET TO BUTTON to redirect to Group Chat
                        self.btnRoomClass.addTarget(self, action: #selector(self.redirectToGroupChat), for: .touchUpInside)
                    } else {
                        self.viewRoomClass.backgroundColor = AppColor.appGrayColor
                        self.btnRoomClass.isUserInteractionEnabled = false
                    }
                    /// [END]
                    self.joinedUsersArr = self.eventDetailViewModel.eventDataResponse?.data?.userData ?? []
                    self.friendsTableView.reloadData()
                    self.setupUI(eventData: eventData)
                    
                    if self.isFromSearch {
                        /// HIT ADD RECENT SEARCH API
                        let params = ["categoryId"  : eventData._id ?? "", "type": eventData.roomClass ?? "",
                                      "roomName"    : eventData.roomName ?? "", "startDate": eventData.startDate ?? "",
                                      "image"       : eventData.image ?? ""
                                    ]
                        self.eventDetailViewModel.addRecentSearch(params: params)
                    }
                }
                
                if let eventData = self.eventDetailViewModel.eventDetailsUserList?.data?.roomData {
                    self.eventDetail = eventData
                    self.friendsArr = self.eventDetailViewModel.eventDetailsUserList?.data?.userData ?? []
                    self.friendsTableView.reloadData()
                    self.setupUI(eventData: eventData)
                }
            }
        }
        
        /// GET CATEGORIES RESPOSNE
        homePageViewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let categoryData = self.homePageViewModel.categoriesResponse?.data {
                    self.categoriesArr = categoryData
                }
            }
        }
        
        /// DELETE ROOM RESPONSE
        eventDetailViewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.eventDetailViewModel.deleteRoomResponse?.status == APIKeys.success {
                    
                    let startDate = self.eventDetail.startDate?.serverToLocalFormattedTime().getFormattedDate() ?? Date()
                    let endDate = self.eventDetail.endDate?.serverToLocalFormattedTime().getFormattedDate() ?? Date()
                    
                    /// DELETE EVENTS FROM APPLE CALENDAR
                    self.fetchAllEvents(model: self.eventDetail, startDate: startDate, endDate: endDate) { events in
                        for e in events {
                            if e.title == self.eventDetail.roomName /*&& e.startDate == startDate*/ {
                                self.removeEventFromAppleCalendar(event: e)
                            }
                        }
                    }

                    self.homePageViewModel.getJoinedRooms()
                    self.eventDelegate?.didDeleteRoom(status: true)
                    self.navigationController?.popViewController(animated: true)
                } else if self.eventDetailViewModel.deleteRoomResponse?.status == APIKeys.error {
                    self.showBaseAlert(self.eventDetailViewModel.deleteRoomResponse?.message ?? "")
                }
            }
        }
        
        /// JOIN ROOM RESPONSE
//        homePageViewModel.redirectControllerClosure = { [weak self] in
        homePageViewModel.reloadMenuClosure = { [weak self] in
            DispatchQueue.main.async {
                let errorResponse = self?.homePageViewModel.roomErrorResponse
                if errorResponse?.status == APIKeys.error && (errorResponse?.message?.localizedCaseInsensitiveContains(Constants.unauthorized) ?? false) {
                    UIAlertController.showAlert((AlertMessage.sessionExpired, "\(errorResponse?.message ?? ""). Please Login again"), sender: self, actions: AlertAction.Okk) { action in
                        self?.navigateToSignInScreen()
                    }
                } else if errorResponse?.status == APIKeys.error {
                    UIAlertController.showAlert((APIKeys.error, "\(errorResponse?.message ?? "")"), sender: self, actions: AlertAction.Okk) { action in
                        // NOTHING TO DO
                    }
//                } else if self?.homePageViewModel.roomResponse?.status == APIKeys.success {
                } else if self?.homePageViewModel.joinRoomResponse?.status == APIKeys.success {
                    self?.addBtn.setImage(Images.circleTick, for: .normal)
                    self?.hitGetRoomAPI(id: self?.id ?? "")
                    self?.eventDelegate?.didJoinRoom(row: self?.selectedRow ?? 0, status: true)
                    self?.view.setNeedsDisplay()
                }
            }
        }
        
        /// Unjoin Room Response
        homePageViewModel.redirectControllerClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.addBtn.setImage(Images.circleAdd, for: .normal)
                self.hitGetRoomAPI(id: self.id)
                self.homePageViewModel.getJoinedRooms()
                self.eventDelegate?.didUnjoinRoom(row: self.selectedRow, status: true)
                self.view.setNeedsDisplay()
            }
        }
    }
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
//        if hasJoinedRoom == false {
        if self.eventDetail.hasRoomJoined == false {
            let params = [APIKeys.roomId: id, APIKeys.userId: UserDefaultUtility.shared.getUserId() ?? ""] as [String:Any]
            homePageViewModel.joinRoom(params: params)
//        } else if hasJoinedRoom == true {
        } else if self.eventDetail.hasRoomJoined == true {
            let roomId = self.id
            homePageViewModel.unjoinRoom(roomID: roomId)
        }
    }

    @IBAction func optionBtnTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            
            var namesArr = [String]()
            var idsArr = [String]()
            self.extractNamesIds { names, ids in
                if let names = names, let ids = ids {
                    namesArr = names
                    idsArr = ids
                }
            }
            
            let alertCtrl = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            /// EDIT ROOM
            let actionEditRoom = UIAlertAction(title: Constants.EditRoomTitle, style: .default) { _ in
                let editRoomVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: EditPrivateRoomVC.className) as! EditPrivateRoomVC
                editRoomVC.roomData = self.eventDetail
                editRoomVC.categoriesArr = self.categoriesArr
                /// PASSING INVITEEs DATA
                editRoomVC.invitedFriendsDict = self.invitedFriendsDict
                editRoomVC.names = namesArr
                editRoomVC.ids = idsArr
                editRoomVC.isPrivateRoom = self.eventType == EventType.Private.rawValue ? true : false
                editRoomVC.editRoomDelegate = self
                self.navigationController?.pushViewController(editRoomVC, animated: true)
            }
            /// DELETE ROOM
            let actionDeleteRoom = UIAlertAction(title: Constants.DeleteRoomTitle, style: .destructive) { _ in
                self.eventDetailViewModel.deleteRoom(roomId: self.id)
            }
            let actionCancel = UIAlertAction(title: Constants.CancelAlerTitle, style: .cancel, handler: nil)
            alertCtrl.addAction(actionEditRoom)
            alertCtrl.addAction(actionDeleteRoom)
            alertCtrl.addAction(actionCancel)
            self.present(alertCtrl, animated: true, completion: nil)
        }
    }
    
    /// Extract Invitees data to show it
    func extractNamesIds(completion: @escaping (_ names: [String]?, _ ids: [String]?) -> Void) {
        var counter = 0
        if let friendsArr = self.eventDetail?.friendsArr, friendsArr.count > 0 {
            for friend in friendsArr {
                let fullname = "\(friend.fname ?? "") \(friend.lname ?? "")"
                let friendsData = SaveFriendsModel(id: friend._id, fullname: fullname, profileImg: friend.image)
                self.invitedFriendsDict[counter] = friendsData
                counter += 1
            }
            let names = self.invitedFriendsDict.compactMap({$0.1.fullname})
            let ids = self.invitedFriendsDict.compactMap({$0.1.id})
            
            completion(names, ids)
//            UserDefaultUtility.shared.saveInviteFriendNames(names: names)
//            UserDefaultUtility.shared.saveInviteFriendsIDs(ids)
        }
        completion(nil, nil)
    }
}



extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        let rows = isFromSettings ? 2 : 1
//        return rows
        return 2
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: /// HEADER CELL
//            let rows = (isFromSettings && friendsArr.count > 0) ? 1 : 0
//            return rows
            if isFromSettings {
                return friendsArr.count > 0 ? 1 : 0
            } else {
                return joinedUsersArr.count > 0 ? 1 : 0
            }
        case 1:
            if isFromSettings {
                return self.friendsArr.count
            } else {
                return self.joinedUsersArr.count
            }
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.className, for: indexPath) as! HeaderCell
            cell.lblHeaderName.text = Constants.joinedUsersTitle
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: EventUserListTVC.className, for: indexPath) as! EventUserListTVC
            cell.selectionStyle = .none
            
            if isFromSettings {
                let friend = friendsArr[indexPath.row]
                cell.lblFriendName.text = "\(friend.fname ?? "") \(friend.lname ?? "")"
//                cell.lblPhoneNumber.text = friend.phone
                cell.lblPhoneNumber.text = friend.loginType == "Chatfe" ? friend.username : "User"
                if let imageUrl = URL(string: friend.profileImg?.image ?? "") {
                    cell.friendImage.kf.setImage(with: imageUrl)
                }
            } else {
                let friend = joinedUsersArr[indexPath.row]
                cell.lblFriendName.text = "\(friend.fname ?? "") \(friend.lname ?? "")"
//                cell.lblPhoneNumber.text = friend.phone
                cell.lblPhoneNumber.text = friend.loginType == "Chatfe" ? friend.username : "User"
                
                if let imageUrl = URL(string: friend.profileImg?.image ?? "") {
                    cell.friendImage.kf.setImage(with: imageUrl)
                }
            }
            /*let friend = isFromSettings ? friendsArr[indexPath.row] : joinedUsersArr[indexPath.row]
            cell.lblFriendName.text = "\(friend.fname ?? "") \(friend.lname ?? "")"
            cell.lblPhoneNumber.text = friend.phone
            if let imageUrl = URL(string: friend.profileImg?.image ?? "") {
                cell.friendImage.kf.setImage(with: imageUrl)
            }*/
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let friendsProfileVC = kHomeStoryboard.instantiateViewController(withIdentifier: FriendsProfileVC.className) as! FriendsProfileVC
//            friendsProfileVC.profileData = self.friendsArr[indexPath.row]
            friendsProfileVC.isFromRoom = true
            if isFromSettings {
                friendsProfileVC.userId = self.friendsArr[indexPath.row]._id ?? ""
            } else {
                friendsProfileVC.userId = self.joinedUsersArr[indexPath.row]._id ?? ""
            }
            self.navigationController?.pushViewController(friendsProfileVC, animated: true)
        default:
            return
        }
    }
    
    
}



extension EventDetailViewController: EditPrivateRoomDelegate {
    
    func updatedRoom(updatedData: EditRoomData?) {
        let params = [APIKeys._id: id]
        eventDetailViewModel.getRoom(params: params)
        self.eventDelegate?.didDeleteRoom(status: true)
    }

}


// MARK: - ==== CHECK ONGOING EVENT TO ENABLE CHAT ROOM BUTTON
extension EventDetailViewController {
    
    func checkOnGoingEvent(strStartDate: String?, strEndDate: String?) -> Bool {
//        guard let startDate = startDate?.convertStringToDate() else { return }
//        guard let endDate = endDate?.convertStringToDate() else { return }
        let currentDateTime = currentDateTime()
        if let startDate = strStartDate?.convertStringToDate(), let endDate = strEndDate?.convertStringToDate() {
            let startDateResult = Calendar.current.compare(startDate, to: currentDateTime, toGranularity: .minute)
            let endDateResult = Calendar.current.compare(endDate, to: currentDateTime, toGranularity: .minute)
            
            if (startDateResult == .orderedSame || startDateResult == .orderedAscending) && endDateResult == .orderedDescending {
                return true
            }
        }
        return false
    }
    
}
