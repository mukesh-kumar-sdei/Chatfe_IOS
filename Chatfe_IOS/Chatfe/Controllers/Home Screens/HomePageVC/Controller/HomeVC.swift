//
//  HomeVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 27/05/22.
//

import UIKit

struct FilterScreen {
    static var isFromFilterScreen = false
}

protocol HomePageDelegate {
    func passToNextVC(sender: UIButton)
    func didJoinRoom(reply: Bool)
}

protocol RefreshRoomsDelegate {
    func refreshRooms(roomData: [RoomData])
}

protocol SelectedFilterDelegate {
    func setSelectedCategory(cat: CategoriesData?)
}

class HomeVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var roomTableView: UITableView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var lblDataNotFound: UILabel!
    @IBOutlet weak var btnNotificationBell: UIButton!
    @IBOutlet weak var lblBadge: UILabel!
//    @IBOutlet weak var imgBadge: UIImageView!
    
    lazy var homePageViewModel: HomePageViewModel = {
        let obj = HomePageViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    lazy var settingsViewModel: SettingsViewModel = {
       let obj = SettingsViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    // MARK: - ==== VARIABLEs ====
    var tappedRow = 0
    var arrData: [RoomData] = []
    var categoriesArr: [CategoriesData] = []
    var selectedCategory = ""
    var selectedCategoryId = ""
    var selectedCat: CategoriesData?
//    var isFromFilterScreen = false
    var selectedIndexPath: IndexPath?
    
    var joinedRoom: Bool! {
        didSet {
            DispatchQueue.main.async {
                self.roomTableView.reloadData()
            }
        }
    }
    
    lazy var refreshCtrl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblBadge.layer.masksToBounds = true
        self.lblBadge.cornerRadius = 8.5

        // IN CASE USER CAME OUT FROM LOGOUT - Need to connect Socket again
        if !SocketIOManager.shared.isSocketConnected() {
            SocketIOManager.shared.establishConnection()
        }
        
        self.roomTableView.delegate = self
        self.roomTableView.dataSource = self
        self.roomTableView.showsVerticalScrollIndicator = false
        self.roomTableView.showsHorizontalScrollIndicator = false
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        
//        refreshCtrl.tintColor = UIColor.white
        self.roomTableView.refreshControl = refreshCtrl
//        refreshCtrl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        registerNIBs()
//        hitGetAllRoomAPI()
//        setupCategories()
        setupClosure()

        NotificationCenter.default.addObserver(self, selector: #selector(listenUnreadCountSocketEvent), name: Notification.Name.GC_UNREAD_MESSAGE_COUNT, object: nil)

        listenReceiveMessageEvent()
        NotificationCenter.default.addObserver(self, selector: #selector(roomNotificationTapped(_:)), name: Notification.Name.ROOM_NOTIFICATION_TAPPED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(friendNotificationTapped(_:)), name: Notification.Name.FRIEND_NOTIFICATION_TAPPED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeepLink(_:)), name: Notification.Name.DeepLinkNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hitGetNotificationsAPI), name: Notification.Name.FOREGROUND_NOTIFICATION, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationCount(_:)), name: Notification.Name.PUSH_NOTIFICATION_COUNT, object: nil)
    }
    
    @objc func hitGetNotificationsAPI() {
        self.homePageViewModel.getAllNotifications()
    }
    
    /*
    @objc func updateNotificationCount(_ notification: Notification) {
        if let count = notification.object as? Int {
            DispatchQueue.main.async {
                if count == 0 {
                    self.lblBadge.backgroundColor = .clear
                    self.lblBadge.text = ""
                }else{
                    self.lblBadge.backgroundColor = .red
                    self.lblBadge.text = "\(count)"
                }
            }
        }
    }
    */
    func updateBadgeCount(count: Int) {
        self.lblBadge.isHidden = count > 0 ? false : true
        self.lblBadge.backgroundColor = count > 0 ? .red : .clear
        self.lblBadge.text = count > 0 ? "\(count)" : ""
    }
    
    @objc func roomNotificationTapped(_ notification: Notification) {
        if let id = notification.object as? String {
            let nextVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: EventDetailViewController.className) as! EventDetailViewController
            nextVC.id = id
            nextVC.eventDelegate = self
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func friendNotificationTapped(_ notification: Notification) {
        if let id = notification.object as? String {
            let friendsProfileVC = kHomeStoryboard.instantiateViewController(withIdentifier: FriendsProfileVC.className) as! FriendsProfileVC
            friendsProfileVC.userId = id
            self.navigationController?.pushViewController(friendsProfileVC, animated: true)
        }
    }
    
    @objc func handleDeepLink(_ notification: Notification) {
        if let dict = notification.object as? [String: String] {
            if let roomID = dict["roomId"] {
                let nextVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: EventDetailViewController.className) as! EventDetailViewController
                nextVC.id = roomID
                nextVC.eventDelegate = self
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    /*
    @objc func listenReceivedChatMessage() {
        SocketIOManager.shared.emitUnreadCountEvent()
    }*/
    
    func listenReceiveMessageEvent() {
        SocketIOManager.shared.receiveMessage { data in
            SocketIOManager.shared.emitUnreadCountEvent()
        }
    }
    
    /*@objc func listenGCUnreadCount() {
        // UNREAD MESSAGE COUNT EVENT
        if SocketIOManager.shared.isSocketConnected() {
            SocketIOManager.shared.unreadGCCount { data in
                guard let resp = data?.first else { return }
                do {
                    let respData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                    let model = try JSONDecoder().decode(UnreadCountModel.self, from: respData)
                    if let count = model.unreadGrpMsgCount, count > 0 {
//                        self.lblMsgCount.text = "\(count)"
                        NotificationCenter.default.post(name: Notification.Name("UPDATE_GROUPCHAT_COUNT"), object: count)
                    }
                    
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if !isFromFilterScreen {
        if !FilterScreen.isFromFilterScreen && (selectedCat?.title == nil || selectedCat?.title == "") {
            self.selectedCat?.title = ""
            self.selectedCat?._id = ""
            self.selectedCategory = ""
            self.selectedCategoryId = ""
            
            self.hitGetAllRoomAPI()
            self.setupCategories()
        } else if FilterScreen.isFromFilterScreen {
            FilterScreen.isFromFilterScreen = false
        }
//        unreadCountSocketEvent()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    // MARK: - ==== CUSTOM METHODs ====
    @objc func refreshData() {
        DispatchQueue.main.async {
            self.selectedCat = nil
            self.selectedCat?.title = ""
            self.selectedCat?._id = ""
            self.selectedCategory = ""
            self.selectedCategoryId = ""
            
            self.setupCategories()
            self.hitGetAllRoomAPI()
            self.refreshCtrl.endRefreshing()
        }
    }

    func registerNIBs() {
        let homeNIB = UINib(nibName: HomePageTableViewCell.className, bundle: nil)
        let filterNIB = UINib(nibName: FiltersCollectionViewCell.className, bundle: nil)
        roomTableView.register(homeNIB, forCellReuseIdentifier: HomePageTableViewCell.className)
        filtersCollectionView.register(filterNIB, forCellWithReuseIdentifier: FiltersCollectionViewCell.className)
    }
    
    func hitGetAllRoomAPI() {
        let params = [APIKeys.categoryId            : selectedCategoryId,
                      APIKeys.startDate             : "",
                      APIKeys.startTime             : "",
                      APIKeys.isFreeOnMyCalendar    : false
                     ] as [String: Any]
        self.homePageViewModel.getAllRooms(params: params)
    }
    
    func setupCategories() {
        self.homePageViewModel.getCategories()
    }
    
    func setupClosure() {
        homePageViewModel.redirectControllerClosure = { [weak self] in
            let responseMessage = self?.homePageViewModel.roomErrorResponse?.message ?? ""
            if self?.homePageViewModel.roomErrorResponse?.status == APIKeys.error && responseMessage.localizedCaseInsensitiveContains(Constants.unauthorized) {
                DispatchQueue.main.async {
                    UIAlertController.showAlert((AlertMessage.sessionExpired, "\(responseMessage). Please Login again"), sender: self, actions: AlertAction.Okk) { action in
                        self?.navigateToSignInScreen()
//                        let nextVC = kMainStoryboard.instantiateViewController(withIdentifier: SignInViewController.className) as! SignInViewController
//                        self?.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            } else if self?.homePageViewModel.roomErrorResponse?.status == APIKeys.error {
                DispatchQueue.main.async {
                    UIAlertController.showAlert((APIKeys.error, "\(responseMessage)"), sender: self, actions: AlertAction.Okk) { action in
                        // NOTHING TO DO
                    }
                }
            } else if self?.homePageViewModel.roomResponse?.status == APIKeys.success {
                DispatchQueue.main.async {
                    if let roomData = self?.homePageViewModel.roomResponse?.data {
                        if roomData.count > 0 {
                            self?.lblDataNotFound.isHidden = true
                            self?.arrData = roomData
                            self?.roomTableView.reloadData()
                        } else {
                            self?.lblDataNotFound.isHidden = false
                            self?.arrData = roomData
                            self?.roomTableView.reloadData()
                        }
                    }
                }
            }
        }
        
        homePageViewModel.reloadListViewClosure = { [weak self] in
            DispatchQueue.main.async {
                if let categoryData = self?.homePageViewModel.categoriesResponse?.data {
                    self?.categoriesArr = categoryData
                    self?.filtersCollectionView.reloadData()
                }
            }
        }
        
        /// join Room Response
        homePageViewModel.reloadMenuClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.tappedRow, section: 0)
                let cell = self.roomTableView.cellForRow(at: indexPath) as! HomePageTableViewCell
                cell.joinRoomBtn.setImage(Images.circleTick, for: .normal)
                self.hitGetAllRoomAPI()
            }
        }
        
        /// Unjoin Room Response
        homePageViewModel.redirectControllerClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.tappedRow, section: 0)
                let cell = self.roomTableView.cellForRow(at: indexPath) as! HomePageTableViewCell
                cell.joinRoomBtn.setImage(Images.circleAdd, for: .normal)
                self.hitGetAllRoomAPI()
            }
        }
        
        /// ALL NOTIFICATIONS RESPONSE
        homePageViewModel.reloadListViewClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let data = self.homePageViewModel.notificationResp
//                var count = 0
                let friendCount = data?.friendResult ?? []
                let inviteCount = data?.privateRoomResult ?? []
                if friendCount.count > 0 || inviteCount.count > 0 {
                    let totalCount = friendCount.count + inviteCount.count
                    self.updateBadgeCount(count: totalCount)
                    NotificationCenter.default.post(name: Notification.Name.PUSH_NOTIFICATION_COUNT, object: totalCount)
                }
            }
        }
        
        
        
        /// GET ALL JOINED ROOM RESPONSEs
        /*homePageViewModel.reloadMenuClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                // PROCESS GROUP CHAT ICON
                if let allJoinedRoom = self.homePageViewModel.getJoinedRoomsResp?.data {
                    // RUN LOOP
                    allJoinedRoom.enumerated().forEach { (index, event) in
                        let matchedEvent = self.checkOngoingEvent(event: event, index: index)
                        
                    }
                    
                    if self.isOngoingEvent {
                        let event = Persistence.cachedOngoingRoom()
                        NotificationCenter.default.post(name: Notification.Name("SHOW_ONGOING_EVENT"), object: event?.roomId?.endDate)
                    }
                }
            }
        }*/
        
    }
/*
    var isOngoingEvent = false
    var ongoingEventIndex = 0
    
    func checkOngoingEvent(event: RoomJoinedData, index: Int) -> Bool {
        guard let startDate = event.roomId?.startDate?.convertStringToDate() else { return false }
        guard let endDate = event.roomId?.endDate?.convertStringToDate() else { return false }
        let currentDateTime = currentDateTime()

        let startDateResult = Calendar.current.compare(startDate, to: currentDateTime, toGranularity: .minute)
        let endDateResult = Calendar.current.compare(endDate, to: currentDateTime, toGranularity: .minute)
        
        if (startDateResult == .orderedSame || startDateResult == .orderedAscending) && endDateResult == .orderedDescending {
            return true
//            self.isOngoingEvent = true
//            self.ongoingEventIndex = index
//            Persistence.cacheOngoingRoom(event)
            
        } else {
//            Persistence.removeOngoingRoom()
            return false
        }
    }
*/

    // MARK: - ==== IBACTIONs ====
    @IBAction func createEventClicked(_ sender: UIButton) {
        let popupVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: ChooseRoomTypeViewController.className) as! ChooseRoomTypeViewController
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .popover
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.popoverPresentationController?.sourceView = self.view
        popupVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        popupVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        present(popupVC, animated: true, completion: nil)
    }

    @IBAction func filterButtonClicked(_ sender: UIButton) {
        let nextVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: FilterViewController.className) as! FilterViewController
//        self.isFromFilterScreen = true
        FilterScreen.isFromFilterScreen = true
        nextVC.categoriesArr = categoriesArr
        nextVC.homeDelegate = self
        nextVC.filterCatDelegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func notificationsClicked(_ sender: UIButton) {
        let notificationActivityVC = kHomeStoryboard.instantiateViewController(withIdentifier: NotificationsActivityVC.className) as! NotificationsActivityVC
        self.navigationController?.pushViewController(notificationActivityVC, animated: true)
    }
    
}


// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.roomTableView.dequeueReusableCell(withIdentifier: HomePageTableViewCell.className) as! HomePageTableViewCell
        cell.parentVC = self
        
        if arrData[indexPath.row].roomClass == Constants.chat {
            cell.lblroomClass.text = (arrData[indexPath.row].roomClass ?? "") + Constants.Room
            cell.roomClassIcon.image = Images.chatRoomIcon
        } else if (arrData[indexPath.row].roomClass ?? "").localizedCaseInsensitiveContains(Constants.watch) {
            cell.lblroomClass.text = Constants.watchParty // "Watch Party" // arrData[indexPath.row].roomClass
            cell.roomClassIcon.image = Images.watchPartyIcon
        }

        cell.roomNameLbl.text = arrData[indexPath.row].roomName
        
        // CONVERT START DATE TO dd/MM/yyyy FORMAT
        if let strStartDate = arrData[indexPath.row].startDate, let strEndDate = arrData[indexPath.row].endDate {

            // TIMEZONE CONVERSIONs
            let localStartDate = strStartDate.serverToLocalTime()
            let eventDate = localStartDate.extractDate()
            let startTime = localStartDate.extractStartTime()
            
            let localEndDate = strEndDate.serverToLocalTime()
            let endTime = localEndDate.extractStartTime()
            
            // CHECK FOR TODAY's DATE
            let currentDate = currentDateTime()
            let eventUTCDate = returnUTCDate(date: localStartDate)
            let result = Calendar.current.compare(eventUTCDate, to: currentDate, toGranularity: .day)
            if result == .orderedSame {
                cell.roomTimingsLbl.text = "\(startTime) - \(endTime) | Today"
            } else {
                cell.roomTimingsLbl.text = "\(startTime) - \(endTime) | \(eventDate)"
            }
 
        }
            
        let imageUrl = URL(string: arrData[indexPath.row].image ?? "")
        cell.roomImageView.kf.setImage(with: imageUrl)
//        cell.roomId = arrData[indexPath.row]._id ?? ""
//        cell.hasRoomJoined = arrData[indexPath.row].hasRoomJoined ?? false
        cell.displayJoinedRoom(hasJoined: arrData[indexPath.row].hasRoomJoined ?? false)
//        cell.setupClosure()
        cell.roomDelegate = self
        
        cell.joinRoomBtn.tag = indexPath.row
        cell.joinRoomBtn.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
       return cell
    }
    
    @objc func tapped(_ sender: UIButton) {
        self.tappedRow = sender.tag
        if arrData[sender.tag].hasRoomJoined == false {
            let params = [APIKeys.roomId: arrData[sender.tag]._id ?? "", APIKeys.userId: UserDefaultUtility.shared.getUserId() ?? ""] as [String:Any]
            homePageViewModel.joinRoom(params: params)
        } else if arrData[sender.tag].hasRoomJoined == true {
            let roomId = arrData[sender.tag]._id ?? ""
            homePageViewModel.unjoinRoom(roomID: roomId)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        let nextVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: EventDetailViewController.className) as! EventDetailViewController
        nextVC.id = arrData[indexPath.row]._id ?? ""
//        nextVC.hasJoinedRoom = arrData[indexPath.row].hasRoomJoined ?? false
        nextVC.selectedRow = indexPath.row
        nextVC.eventType = arrData[indexPath.row].roomType ?? ""
        nextVC.categoriesArr = self.categoriesArr
        nextVC.eventDelegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}


// MARK: - ==== COLLECTIONVIEW DATASOURCE & DELEGATE METHODs ====
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        debugPrint("The filters are ", categoriesArr.count)
      // return filtersArr.count
        return categoriesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersCollectionViewCell.className, for: indexPath) as! FiltersCollectionViewCell
       // let cell = collectionView.register(self, forCellWithReuseIdentifier: "FiltersCollectionViewCell") as! FiltersCollectionViewCell
        cell.filterLbl.text = categoriesArr[indexPath.row].title

//        if (cell.isSelected) {
//            cell.layer.backgroundColor = UIColor.blue.cgColor
//        } else {
//            cell.backgroundColor = .clear
//        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        debugPrint("Did Select Cell")
//       let cell = collectionView.cellForItem(at: indexPath)
//        cell?.backgroundColor = .blue
//           // cell.filterLbl.textColor = .white
//        collectionView.reloadData()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) {
//            cell.backgroundColor = .clear
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && selectedCat == nil {
            cell.isSelected = true
        } else {
            if selectedCat?.title == categoriesArr[indexPath.row].title {
                cell.isSelected = true
            } else {
                cell.isSelected = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if let title = categoriesArr[indexPath.row].title, let id = categoriesArr[indexPath.row]._id {
                self.selectedCategory = title
                self.selectedCategoryId = id
//                self.homePageViewModel.getAllRooms(params: ["categoryId": self.selectedCategoryId])
                self.hitGetAllRoomAPI()
            }
            
            for cell in collectionView.visibleCells as [UICollectionViewCell] {
                cell.isSelected = false
            }
            
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                self.selectedCategoryId = ""
//                self.homePageViewModel.getAllRooms(params: ["categoryId": self.selectedCategoryId])
                self.hitGetAllRoomAPI()
                return false
            }
        }
        return true
    }
    
}


extension HomeVC: HomePageDelegate {
    
    func didJoinRoom(reply: Bool) {
        self.joinedRoom = reply
        self.roomTableView.reloadData()
    }
    
    func passToNextVC(sender: UIButton) {
        if sender.tag == 0 {
            let nextVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: CreatePublicRoomVC.className) as! CreatePublicRoomVC
            nextVC.categoriesArr = categoriesArr
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: CreatePrivateRoomVC.className) as! CreatePrivateRoomVC
            nextVC.categoriesArr = categoriesArr
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

extension HomeVC: RefreshRoomsDelegate {
    
    func refreshRooms(roomData: [RoomData]) {
        self.arrData = roomData
        if roomData.count == 0 {
            self.lblDataNotFound.isHidden = false
        } else {
            self.lblDataNotFound.isHidden = true
        }
        self.roomTableView.reloadData()
    }
}

extension HomeVC: SelectedFilterDelegate {

    func setSelectedCategory(cat: CategoriesData?) {
        self.selectedCat = cat
        self.roomTableView.reloadData()
        self.filtersCollectionView.reloadData()
    }

}


extension HomeVC: EventDetailsDelegate {
    func didJoinRoom(row: Int, status: Bool) {
        let indexPath = IndexPath(row: row, section: 0)
        let cell = self.roomTableView.cellForRow(at: indexPath) as! HomePageTableViewCell
        if status {
            cell.joinRoomBtn.setImage(Images.circleTick, for: .normal)
        } else {
            cell.joinRoomBtn.setImage(Images.circleAdd, for: .normal)
        }
    }
    
    func didUnjoinRoom(row: Int, status: Bool) {
        let indexPath = IndexPath(row: row, section: 0)
        let cell = self.roomTableView.cellForRow(at: indexPath) as! HomePageTableViewCell
        if status {
            cell.joinRoomBtn.setImage(Images.circleAdd, for: .normal)
        } else {
            cell.joinRoomBtn.setImage(Images.circleTick, for: .normal)
        }
    }
    
    func didDeleteRoom(status: Bool) {
        self.hitGetAllRoomAPI()
    }
}
