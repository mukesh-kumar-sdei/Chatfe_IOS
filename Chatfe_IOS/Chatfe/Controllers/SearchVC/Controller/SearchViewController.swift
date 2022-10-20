//
//  SearchViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 12/05/22.
//

import UIKit

class SearchViewController: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var customSearchBar: UISearchBar!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var lblDataNotFound: UILabel!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblBadge: UILabel!
    
    lazy var viewModel: SearchViewModel = {
        let obj = SearchViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    // MARK: - ==== VARIABLEs ====
    var categoriesArr = [Constants.chatRoom, Constants.watchParty, Constants.people]
    var selectedRow: Int?
    var searchRoomResult = [RoomData]()
    var searchUserResult: [SearchUserData]?
    var recentSearchData = [RecentSearchData]()
    
    /// FOR PAGINATION
    var page: Int = 0
    var pageSize: Int = 10
    var isDataLoading = false
    var didEndReached = false
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

//        hideKeyboardWhenTappedAround()
        self.lblBadge.layer.masksToBounds = true
        self.lblBadge.cornerRadius = 8.5
//        self.lblBadge.isHidden = true
        registerNIBs()
        initialSetup()
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationCount(_:)), name: Notification.Name.PUSH_NOTIFICATION_COUNT, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hitGetRecentSearchAPI()
        setupClosures()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationCount(_:)), name: Notification.Name("HOME_NOTIFICATION_TAPPED"), object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - ==== CUSTOM METHODs ====
    func initialSetup() {
        self.tableViewTopConstraint.constant = 40.0
        self.lblDataNotFound.isHidden = false
        self.lblDataNotFound.text = AlertMessage.noRecentSearch
        
        self.searchRoomResult.removeAll()
        self.searchUserResult?.removeAll()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.showsVerticalScrollIndicator = false
        searchTableView.showsHorizontalScrollIndicator = false
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        
        customSearchBar.delegate = self
        setupSearchUI()
    }
    
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
    
    func hitGetRecentSearchAPI() {
        self.viewModel.getRecentSearch()
    }
    
    func setupSearchUI() {
        customSearchBar.layer.masksToBounds = true
        customSearchBar.layer.cornerRadius = 20.0
        customSearchBar.tintColor = .white
        customSearchBar.searchTextField.leftView?.tintColor = AppColor.searchMagnifyColor // UIColor("#4F5863")
        customSearchBar.autocapitalizationType = .none
        customSearchBar.searchTextField.font = UIFont(name: AppFont.ProximaNovaMedium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .medium)
    }
    
    func registerNIBs() {
        let filterNIB = UINib(nibName: FiltersCollectionViewCell.className, bundle: nil)
        filtersCollectionView.register(filterNIB, forCellWithReuseIdentifier: FiltersCollectionViewCell.className)
        let homeNIB = UINib(nibName: RecentSearchCell.className, bundle: nil)
        searchTableView.register(homeNIB, forCellReuseIdentifier: RecentSearchCell.className)
    }
    
    func setupClosures() {
        /// SEARCH ROOM
        self.viewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
//                self.searchRoomResult = self.viewModel.searchRoomModel?.data
                self.searchRoomResult.append(contentsOf: self.viewModel.searchRoomModel?.data ?? [])
                self.tableViewTopConstraint.constant = 0.0
                if self.searchRoomResult.count == 0 {
                    self.lblDataNotFound.isHidden = false
                    self.lblDataNotFound.text = AlertMessage.noDataFound
                } else {
                    self.lblDataNotFound.isHidden = true
                    self.lblDataNotFound.text = ""
                }
                self.searchTableView.reloadData()
            }
        }
        
        /// SEARCH USER
        self.viewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableViewTopConstraint.constant = 0.0
                self.searchUserResult = self.viewModel.searchUserResponse?.data
                if self.searchUserResult?.count ?? 0 == 0 {
                    self.lblDataNotFound.isHidden = false
                    self.lblDataNotFound.text = AlertMessage.noDataFound
                } else {
                    self.lblDataNotFound.isHidden = true
                    self.lblDataNotFound.text = ""
                }
                self.searchTableView.reloadData()
            }
        }
        
        /// GET RECENT SEARCH
        self.viewModel.redirectControllerClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.recentSearchData = self.viewModel.recentSearchResponse?.data ?? []
                self.tableViewTopConstraint.constant = 40.0
                if self.recentSearchData.count > 0 {
                    self.lblDataNotFound.text = ""
                    self.lblDataNotFound.isHidden = true
                } else {
                    self.lblDataNotFound.text = AlertMessage.noRecentSearch
                    self.lblDataNotFound.isHidden = false
                }
                self.searchTableView.reloadData()
                
            }
        }
        
        /// DELETE RECENT SEARCH
        self.viewModel.reloadMenuClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                /// IF DATA DELETED, GETTING FRESH DATA & RELOADING TABLEVIEW
                self.hitGetRecentSearchAPI()
            }
        }
    }
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func filterBtnTapped(_ sender: UIButton) {
//        debugPrint("Notify Search")
    }
    
    @IBAction func notificationsClicked(_ sender: UIButton) {
        let notificationActivityVC = kHomeStoryboard.instantiateViewController(withIdentifier: NotificationsActivityVC.className) as! NotificationsActivityVC
        self.navigationController?.pushViewController(notificationActivityVC, animated: true)
    }

}


// MARK: - ==== COLLECTIONVIEW DATASOURCE & DELEGATE METHODs ====
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersCollectionViewCell.className, for: indexPath) as! FiltersCollectionViewCell
        cell.filterLbl.text = categoriesArr[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        
        if self.recentSearchData.isEmpty {
            self.lblDataNotFound.isHidden = false
            self.lblDataNotFound.text = AlertMessage.searchChatRoom
        }
        self.page = 0
        self.clearSearchedData()
        
        if let cell = collectionView.cellForItem(at: indexPath) as? FiltersCollectionViewCell {
            cell.collView.backgroundColor = AppColor.selectedMenuBGColor
            cell.filterLbl.textColor = AppColor.appBlueColor
            cell.collView.layer.cornerRadius = 20.0
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FiltersCollectionViewCell {
            cell.filterLbl.textColor = UIColor.white
            cell.collView.backgroundColor = AppColor.accentColor
        }
    }
    
    
}



// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchRoomResult.count > 0 || self.searchUserResult?.count ?? 0 > 0 {
            if let row = selectedRow {
                if self.categoriesArr[row] == Constants.people {
                    return self.searchUserResult?.count ?? 0
                } else if self.categoriesArr[row] == Constants.watchParty || self.categoriesArr[row] == Constants.chatRoom {
                    return self.searchRoomResult.count
                } else {
                    return 0
                }
            }
        } else if self.recentSearchData.count > 0 {
            /// SHOWING LATEST 5 DATA ONLY
            return self.recentSearchData.count > 5 ? 5 : self.recentSearchData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.className) as! RecentSearchCell
        if self.searchRoomResult.count > 0 || self.searchUserResult?.count ?? 0 > 0 {
            cell.btnRemove.isHidden = true
            if let row = selectedRow {
                if self.categoriesArr[row] == Constants.people {
                    let data = self.searchUserResult?[indexPath.row]
                    cell.lblFriendName.text = "\(data?.fname ?? "") \(data?.lname ?? "")"
                    cell.lblDateTime.text = "User"
                    if let imageURL = URL(string: data?.profileImg?.image ?? "") {
                        cell.friendImage.kf.setImage(with: imageURL)
                    }
                    cell.categoryIconView.isHidden = true
                } else if self.categoriesArr[row] == Constants.watchParty || self.categoriesArr[row] == Constants.chatRoom {
                    let data = self.searchRoomResult[indexPath.row]
                    cell.lblFriendName.text = data.roomName
                    
//                    let customDate = data.date?.convertDateToSpecificFormat() ?? ""
//                    cell.lblDateTime.text =  "\(customDate)  |  \(data.startTime ?? "") - \(data.endTime ?? "")"
                    
                    /// START DATE & START TIME
                    let strStartDate = data.startDate ?? ""
                    let localStartDate = strStartDate.serverToLocalTime()
//                    let eventDate = localStartDate.extractDate()
                    let eventDate = localStartDate.extractCustomizeDate()
                    let startTime = localStartDate.extractStartTime()
                    
                    /// END DATE & END TIME
                    let strEndDate = data.endDate ?? ""
                    let localEndDate = strEndDate.serverToLocalTime()
                    let endTime = localEndDate.extractStartTime()
                    
                    cell.lblDateTime.text =  "\(eventDate)  |  \(startTime) - \(endTime)"
                    
                    
                    if let imageURL = URL(string: data.image ?? "") {
                        cell.friendImage.kf.setImage(with: imageURL)
                    }
                    cell.categoryIconView.isHidden = false
                    cell.categoryIcon.image = self.categoriesArr[row].localizedStandardContains(Constants.chat) ? Images.chatRoomIcon : Images.watchPartyIcon
                }
            }
        } else if self.recentSearchData.count > 0 {
            cell.btnRemove.isHidden = false
            let data = self.recentSearchData[indexPath.row]
            /// FOR PEOPLE
            if data.fname?.count ?? 0 > 0 {
                cell.lblFriendName.text = "\(data.fname ?? "") \(data.lname ?? "")"
                cell.lblDateTime.text = "User"
                if let imageURL = URL(string: data.image ?? "") {
                    cell.friendImage.kf.setImage(with: imageURL)
                }
                cell.categoryIconView.isHidden = true
            } else if data.roomName?.count ?? 0 > 0 {
                cell.lblFriendName.text = data.roomName

//                let customDate = data.startDate?.convertDateToSpecificFormat1() ?? ""
//                cell.lblDateTime.text =  "\(customDate)  |  \(data.startTime ?? "") - \(data.endTime ?? "")"
                
                /// START DATE & START TIME
                let strStartDate = data.startDate ?? ""
                let localStartDate = strStartDate.serverToLocalTime()
                
//                let eventDate = localStartDate.extractDate()
                let eventDate = localStartDate.extractCustomizeDate()
                let startTime = localStartDate.extractStartTime()
                
                /// END DATE & END TIME
                let strEndDate = data.endDate ?? ""
                let localEndDate = strEndDate.serverToLocalTime()
                let endTime = localEndDate.extractStartTime()
                
                cell.lblDateTime.text =  "\(eventDate)  |  \(startTime) - \(endTime)"
                
                if let imageURL = URL(string: data.image ?? "") {
                    cell.friendImage.kf.setImage(with: imageURL)
                }
                cell.categoryIconView.isHidden = false
                if let type = data.type {
                    cell.categoryIcon.image = type.localizedStandardContains(Constants.chat) ? Images.chatRoomIcon : Images.watchPartyIcon
                }
            }
            
            cell.btnRemove.tag = indexPath.row
            cell.btnRemove.addTarget(self, action: #selector(removeButtonTapped(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchRoomResult.count > 0 || self.searchUserResult?.count ?? 0 > 0 {
            if let row = selectedRow {
                if self.categoriesArr[row] == Constants.people {
                    let friendsProfileVC = kHomeStoryboard.instantiateViewController(withIdentifier: FriendsProfileVC.className) as! FriendsProfileVC
                    friendsProfileVC.userId = self.searchUserResult?[indexPath.row]._id ?? ""
                    friendsProfileVC.isFromSearch = true
                    friendsProfileVC.isFromMyProfile = true
                    friendsProfileVC.isFromRecentSearch = false
                    self.navigationController?.pushViewController(friendsProfileVC, animated: true)
                } else if self.categoriesArr[row] == Constants.watchParty || self.categoriesArr[row] == Constants.chatRoom {
                    let detailsVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: EventDetailViewController.className) as! EventDetailViewController
                    detailsVC.isFromSearch = true
                    detailsVC.id = self.searchRoomResult[indexPath.row]._id ?? ""
                    detailsVC.selectedRow = indexPath.row
                    self.navigationController?.pushViewController(detailsVC, animated: true)
                }
            }
        } else if self.recentSearchData.count > 0 {
            switch self.recentSearchData[indexPath.row].type {
            case Constants.user:
                let friendsProfileVC = kHomeStoryboard.instantiateViewController(withIdentifier: FriendsProfileVC.className) as! FriendsProfileVC
                friendsProfileVC.userId = self.recentSearchData[indexPath.row].categoryId ?? ""
                friendsProfileVC.isFromSearch = false
                friendsProfileVC.isFromRecentSearch = true
//                friendsProfileVC.isFromMyProfile = true
                self.navigationController?.pushViewController(friendsProfileVC, animated: true)
            case Constants.chat, Constants.watchParty:
                let detailsVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: EventDetailViewController.className) as! EventDetailViewController
                detailsVC.isFromSearch = false
                detailsVC.id = self.recentSearchData[indexPath.row].categoryId ?? ""
//                detailsVC.selectedRow = indexPath.row
                self.navigationController?.pushViewController(detailsVC, animated: true)
            default:
                break
            }
        }
    }
    
    @objc func removeButtonTapped(_ sender: UIButton) {
        if let id = self.recentSearchData[sender.tag]._id {
            self.viewModel.deleteRecentSearch(id: id)
        }
    }
    
}



// MARK: - ==== SEARCHBAR DELEGATE METHODs ====
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            clearSearchedData()
            self.recentSearchData.removeAll()
        } else {
            self.lblDataNotFound.text = ""
            self.lblDataNotFound.isHidden = true
//            self.searchData(searchText: searchText)
        }
    }
    
    func searchData(searchText: String) {
        if let row = selectedRow {
            if self.categoriesArr[row] == Constants.people {
                self.viewModel.searchPeople(searchText: searchText)
            } else if categoriesArr[row].contains(Constants.chat) {
                self.viewModel.searchRoom(roomClass: Constants.chat, searchText: searchText, page: self.page, limit: self.pageSize)
            } else {
                self.viewModel.searchRoom(roomClass: self.categoriesArr[row], searchText: searchText, page: self.page, limit: self.pageSize)
            }
        } else {
            self.showBaseAlert(AlertMessage.chooseCategoryForSearch)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        self.clearSearchedData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.clearSearchedData()
        /*if let searchText = searchBar.text, searchText.count > 1 {
            self.searchData(searchText: searchText)
        }*/
        self.recentSearchData.removeAll()
        if searchBar.text?.count ?? 0 > 3 {
            self.searchData(searchText: searchBar.text ?? "")
        }
        searchBar.resignFirstResponder()
    }
    
    func clearSearchedData() {
        DispatchQueue.main.async {
//            self.lblDataNotFound.text = AlertMessage.searchChatRoom // "Search for a chat room"
//            self.lblDataNotFound.isHidden = false
            self.searchRoomResult.removeAll()
            self.searchUserResult?.removeAll()
            self.searchTableView.reloadData()
        }
    }
    
}


// MARK: - ==== SCROLLVIEW METHODs ====
 
extension SearchViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (self.searchTableView.contentOffset.y + self.searchTableView.frame.size.height) >= self.searchTableView.contentSize.height {
            if !isDataLoading {
                if self.viewModel.searchRoomModel?.totalCount ?? 0 != self.searchRoomResult.count {
                    self.isDataLoading = true
                    self.page += 1
//                    self.pageSize += 10
                    if let row = selectedRow, categoriesArr[row].contains(Constants.chat) {
                        self.viewModel.searchRoom(roomClass: Constants.chat, searchText: self.customSearchBar.text ?? "", page: self.page, limit: self.pageSize)
                    } else {
                        self.viewModel.searchRoom(roomClass: self.categoriesArr[selectedRow ?? 0], searchText: self.customSearchBar.text ?? "", page: self.page, limit: self.pageSize)
                    }
                }
            }
        }
    }
}

