//
//  MyEventsVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 09/06/22.
//

import UIKit

class MyEventsVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var roomTableView: UITableView!
    @IBOutlet weak var lblDataNotFound: UILabel!
    
    lazy var homePageViewModel: HomePageViewModel = {
        let obj = HomePageViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var arrData: [RoomData] = []
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        self.roomTableView.delegate = self
        self.roomTableView.dataSource = self
        self.roomTableView.showsVerticalScrollIndicator = false
        self.roomTableView.showsHorizontalScrollIndicator = false
        
        let homeNIB = UINib(nibName: HomePageTableViewCell.className, bundle: nil)
        roomTableView.register(homeNIB, forCellReuseIdentifier: HomePageTableViewCell.className)
        
        self.homePageViewModel.getUsersCreatedRoom(userId: UserDefaultUtility.shared.getUserId() ?? "")
        setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    
    // MARK: - ==== CUSTOM METHODs ====
    func setupClosure() {
        homePageViewModel.redirectControllerClosure = { [weak self] in
            if self?.homePageViewModel.roomErrorResponse?.status == APIKeys.error {
                DispatchQueue.main.async {
                    let title = self?.homePageViewModel.roomErrorResponse?.status
                    UIAlertController.showAlert((title, "\(self?.homePageViewModel.roomErrorResponse?.message ?? ""). Please Login again"), sender: self, actions: AlertAction.Okk) { action in
                        self?.navigateToSignInScreen()
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
    }
    
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension MyEventsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.roomTableView.dequeueReusableCell(withIdentifier: HomePageTableViewCell.className) as! HomePageTableViewCell
        cell.parentVC = self
        
        if arrData[indexPath.row].roomClass == Constants.chat {
            cell.lblroomClass.text = (arrData[indexPath.row].roomClass ?? "") + " Room"
            cell.roomClassIcon.image = Images.chatRoomIcon
        } else if (arrData[indexPath.row].roomClass ?? "").localizedCaseInsensitiveContains("Watch") {
            cell.lblroomClass.text = Constants.watchParty // "Watch Party" // arrData[indexPath.row].roomClass
            cell.roomClassIcon.image = Images.watchPartyIcon
        }
       
        cell.roomNameLbl.text = arrData[indexPath.row].roomName
        
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
        /*
        let startTime = self.arrData[indexPath.row].startTime
        let duration = self.arrData[indexPath.row].duration
        
        if let strDate = arrData[indexPath.row].date {
            let currentDate = Date.getCurrentDate()
            let dat = strDate.convertToDate()
            let endTime = self.calculateEndTime(startTime: startTime, duration: duration)
            if dat == currentDate {
                cell.roomTimingsLbl.text = "\(arrData[indexPath.row].startTime ?? "") - \(endTime)"
            } else {
                cell.roomTimingsLbl.text = "\(arrData[indexPath.row].startTime ?? "") - \(endTime) | \(dat)"
            }
        }
        */
        let imageUrl = URL(string: arrData[indexPath.row].image ?? "")
        cell.roomImageView.kf.setImage(with: imageUrl)
        cell.roomId = arrData[indexPath.row]._id ?? ""
//        cell.hasRoomJoined = arrData[indexPath.row].hasRoomJoined ?? false
        cell.displayJoinedRoom(hasJoined: arrData[indexPath.row].hasRoomJoined ?? false)
//        cell.setupClosure()
        cell.joinRoomBtn.isHidden = true
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: EventDetailViewController.className) as! EventDetailViewController
        nextVC.id = arrData[indexPath.row]._id ?? ""
//        nextVC.hasJoinedRoom = arrData[indexPath.row].hasRoomJoined ?? false
        nextVC.selectedRow = indexPath.row
        nextVC.isFromSettings = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
