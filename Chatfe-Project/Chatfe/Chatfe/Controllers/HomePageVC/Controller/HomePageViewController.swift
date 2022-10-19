//
//  HomePageViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 28/04/22.
//

import UIKit
import Kingfisher

protocol HomePageDelegate {
    func passToNextVC(sender: UIButton)
}

protocol RefreshRoomsDelegate {
    func refreshRooms(roomData: [RoomData])
}

class HomePageViewController: BaseViewController {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var calendarImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var roomTableView: UITableView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var viewForTabs: UIView!
    
    
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
    
    var arrData: [RoomData] = []
//    let filtersArr = ["All", "Movies", "TV Shows", "Books", "Music", "Sports", "Video Games", "Theater", "Podcasts", "Other Visual", "Other Print", "Other Audio", "Other"]
    var categoriesArr: [CategoriesData] = []
    var selectedCategory = ""
    var selectedCategoryId = ""
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "HomeViews", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "ChooseRoomTypeViewController") as! ChooseRoomTypeViewController
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .popover
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.popoverPresentationController?.sourceView = self.view
        popupVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        popupVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        present(popupVC, animated: true, completion: nil)
        
//        let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreatePublicRoomViewController") as! CreatePublicRoomViewController
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController else {
            return
        }
        nextVC.categoriesArr = categoriesArr
        nextVC.homeDelegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func notificationsButtonTapped(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(roomTableView)
        roomTableView.delegate = self
        roomTableView.dataSource = self
        roomTableView.showsVerticalScrollIndicator = false
        roomTableView.showsHorizontalScrollIndicator = false
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        roomTableView.register(UINib(nibName: "HomePageTableViewCell", bundle: nil), forCellReuseIdentifier: "HomePageTableViewCell")
        filtersCollectionView.register(UINib(nibName: "FiltersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FiltersCollectionViewCell")
        setupView()
        setupCategories()
        setupClosure()
    }
    

    
    func setupView() {
        let params = ["categoryId":selectedCategoryId]
        self.homePageViewModel.getAllRooms(params: params)
        if let roomData = homePageViewModel.roomResponse?.data {
            debugPrint("The roomData is \(roomData)")
            self.arrData = roomData
        }
        DispatchQueue.main.async {
            self.roomTableView.reloadData()
        }
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(homeImageTapped(_:)))
        tapGesture1.numberOfTapsRequired = 1
        
        self.homeImage.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(searchImageTapped(_:)))
        self.searchImage.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(chatImageTapped(_:)))
        self.chatImage.addGestureRecognizer(tapGesture3)
        
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(calendarImageTapped(_:)))
        self.calendarImage.addGestureRecognizer(tapGesture4)
        
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(_:)))
        self.profileImage.addGestureRecognizer(tapGesture5)
        
        self.profileImage.cornerRadius = 20
        self.profileImage.clipsToBounds = true
    }
    
    func setupCategories() {
        self.homePageViewModel.getCategories()
      
    }
    var previousSubview: UIView!
    
    @objc func homeImageTapped(_ sender: UITapGestureRecognizer) {
        debugPrint("Home Image Tapped!")
        self.homeImage.image = UIImage(named: "homeSelected")
        self.searchImage.image = UIImage(named: "search")
        self.chatImage.image = UIImage(named: "chat")
        self.calendarImage.image = UIImage(named: "calendar")
        self.profileImage.borderColor = UIColor.black
        
        guard let Home = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController else {
            return
        }
        
        
         contentView.addSubview(Home.view)
        contentView.addSubview(homeView)
        viewDidLoad()
//        self.filtersCollectionView.reloadData()
//        self.roomTableView.reloadData()
        
         contentView.addSubview(viewForTabs)
        Home.didMove(toParent: self)
    }
    
    @objc func searchImageTapped(_ sender:UITapGestureRecognizer) {
        debugPrint("Search Image Tapped!")
        self.homeImage.image = UIImage(named: "home")
        self.searchImage.image = UIImage(named: "searchSelected")
        self.chatImage.image = UIImage(named: "chat")
        self.calendarImage.image = UIImage(named: "calendar")
        self.profileImage.borderColor = UIColor.black
        
        guard let Search = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else {
            return
        }
        contentView.addSubview(Search.view)
        contentView.addSubview(viewForTabs)
        Search.didMove(toParent: self)
        
    }
    
    @objc func chatImageTapped(_ sender: UITapGestureRecognizer) {
        self.homeImage.image = UIImage(named: "home")
        self.searchImage.image = UIImage(named: "search")
        self.chatImage.image = UIImage(named: "chatSelected")
        self.calendarImage.image = UIImage(named: "calendar")
        self.profileImage.borderColor = UIColor.black
        
        guard let Message = self.storyboard?.instantiateViewController(withIdentifier: "MessagesViewController") as? MessagesViewController else {
            return
        }
        contentView.addSubview(Message.view)
        contentView.addSubview(viewForTabs)
        Message.didMove(toParent: self)
    }
    
    @objc func calendarImageTapped(_ sender: UITapGestureRecognizer) {
        self.homeImage.image = UIImage(named: "home")
        self.searchImage.image = UIImage(named: "search")
        self.chatImage.image = UIImage(named: "chat")
        self.calendarImage.image = UIImage(named: "calendarSelected")
        self.profileImage.borderColor = UIColor.black
        
        guard let Calendar = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController else {
            return
        }
        contentView.addSubview(Calendar.view)
        contentView.addSubview(viewForTabs)
        Calendar.didMove(toParent: self)
    }
    
    @objc func profileImageTapped(_ sender: UITapGestureRecognizer) {
        self.imageContainerView.cornerRadius = 20
        self.profileImage.clipsToBounds = true
        self.profileImage.borderColor = UIColor(named: "TintColor")
        self.homeImage.image = UIImage(named: "home")
        self.searchImage.image = UIImage(named: "search")
        self.chatImage.image = UIImage(named: "chat")
        self.calendarImage.image = UIImage(named: "calendar")
        
        guard let Profile = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePageViewController") as? ProfilePageViewController else {
            return
        }
//        contentView.addSubview(Profile.view)
      //  contentView.addSubview(viewForTabs)
          
        Profile.didMove(toParent: self)
//        Profile.tabBarView.addSubview(viewForTabs)
        self.navigationController?.pushViewController(Profile, animated: false)
        
    }
    
    @IBOutlet weak var imageContainerView: UIView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupClosure() {
        homePageViewModel.redirectControllerClosure = { [weak self] in
            if self?.homePageViewModel.roomErrorResponse?.status == "ERROR" {
                DispatchQueue.main.async {
                    let title = self?.homePageViewModel.roomErrorResponse?.status
                    UIAlertController.showAlert((title, "\(self?.homePageViewModel.roomErrorResponse?.message ?? ""). Please Login again"), sender: self, actions: AlertAction.Okk) { action in
                        UserDefaultUtility.shared.saveUserId(userId: "")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let nextVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                        self?.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            } else if self?.homePageViewModel.roomResponse?.status == "SUCCESS" {
                if let roomData = self?.homePageViewModel.roomResponse?.data {
                    self?.arrData = roomData
                }
                
                DispatchQueue.main.async {
                    self?.roomTableView.reloadData()
                }
            }
          
        }
        homePageViewModel.reloadListViewClosure = { [weak self] in
            if let categoryData = self?.homePageViewModel.categoriesResponse?.data {
                self?.categoriesArr = categoryData
            }
            DispatchQueue.main.async {
                self?.filtersCollectionView.reloadData()
            }
        }
    }
}

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("No of rooms are ", arrData.count)
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.roomTableView.dequeueReusableCell(withIdentifier: "HomePageTableViewCell") as! HomePageTableViewCell
        
        //cell.displayText(name: name, time: time, image: "")
        debugPrint("ARRAY DATA :> ", arrData[indexPath.row].roomName as Any)
//        if let roomDetailName = arrData[indexPath.row].roomName {
//            cell.roomNameLbl.text = roomDetailName
//            //cell.roomTimingsLbl.text = roomDetail.startTime
//        }
        
        cell.roomNameLbl.text = arrData[indexPath.row].roomName
        cell.roomTimingsLbl.text = arrData[indexPath.row].startTime
        let imageUrl = URL(string: arrData[indexPath.row].image ?? "")
        cell.roomImageView.kf.setImage(with: imageUrl)

       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
//        nextVC.id = arrData[indexPath.row]._id ?? ""
        if let roomId = arrData[indexPath.row]._id {
            debugPrint("Row Selected ", roomId)
            nextVC.id = roomId
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint("The filters are ", categoriesArr.count)
      // return filtersArr.count
        return categoriesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiltersCollectionViewCell", for: indexPath) as! FiltersCollectionViewCell
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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if let title = categoriesArr[indexPath.row].title {
                self.selectedCategory = title
                debugPrint("Selected Cat \(self.selectedCategory)")
            }
            
            if let id = categoriesArr[indexPath.row]._id {
                self.selectedCategoryId = id
                self.homePageViewModel.getAllRooms(params: ["categoryId":self.selectedCategoryId])
            }
            
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            }
        }
        return true
    }
    
    
    
}

extension HomePageViewController: HomePageDelegate {
    func passToNextVC(sender: UIButton) {
        if sender.tag == 0 {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreatePublicRoomTableViewController") as! CreatePublicRoomTableViewController
            nextVC.categoriesArr = categoriesArr
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreatePrivateRoomTableViewController") as! CreatePrivateRoomTableViewController
            nextVC.categoriesArr = categoriesArr
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
}

//extension HomePageViewController: FilterCellDelegate {
//    func didSelectCell(selectedFilter: CategoriesData) {
//        debugPrint("The selected cell is \(selectedFilter.title)")
//    }
//    
//    
//}

extension HomePageViewController: RefreshRoomsDelegate {
    func refreshRooms(roomData: [RoomData]) {
        self.arrData = roomData
        self.roomTableView.reloadData()
    }
    
    
}
