//
//  BaseViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 21/04/22.
//

import Foundation
import MBProgressHUD
import UIKit
import EventKit

protocol BaseDataSources {
    func setUpClosures()
    func setUpView()
}

class BaseViewController: UIViewController {
    
    private var eventStore = EKEventStore()
    
    var baseVwModel: BaseViewModel? {
        didSet {
            initBaseModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar(true, animated: true)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func convertTimeToDate(time: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let hour = Int(time.components(separatedBy: ":").first ?? "0") ?? 0
        let minutes = Int(time.components(separatedBy: ":").last ?? "0") ?? 0
        
        guard let date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: Date()) else {
            return Date()
        }
        debugPrint(date)
        return date
    }
    
    func showBaseAlert(_ message: String) {
        let configAlert: AlertUI = (kAppName, message)
        UIAlertController.showAlert(configAlert, sender: self, actions: AlertAction.Okk) { (target) in
            // NOTHING TO DO
            if message == "Unauthorized Access" {
                self.navigateToSignInScreen()
            }
        }
    }
    
    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    func hideNavigationBar(_ hide: Bool, animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(hide, animated: animated)
    }
    
    func CheckTimeExist(hour: Int, minutes: Int) -> Bool {
        var timeExist: Bool
        let calendar = Calendar.current
        let startTimeComponent = DateComponents(calendar: calendar, hour: hour)
        let endTimeComponent = DateComponents(calendar: calendar, hour: hour, minute: minutes)
        
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startTime = calendar.date(byAdding: startTimeComponent, to: startOfToday)!
        let endTime = calendar.date(byAdding: endTimeComponent, to: startOfToday)!
        
        if startTime <= now && now <= endTime {
            debugPrint("\(startTime), \(now), \(endTime)")
            timeExist = true
        } else {
            debugPrint("\(startTime), \(now), \(endTime)")
            timeExist = false
        }
        return timeExist
    }
    
    // Can't be overriden by subclass
    final func initBaseModel() {
        // Native Binding...
        baseVwModel?.showAlertClosure = { [weak self] (_ type: AlertType) in
            DispatchQueue.main.async {
                if type == .success, let message = self?.baseVwModel?.alertMessage {
                    if message.count > 0 {
                        let configAlert: AlertUI = ("", message)
                        UIAlertController.showAlert(configAlert)
                    }
                } else {
                    if let errorMessage = self?.baseVwModel?.errorMessage, errorMessage.count > 0 {
                        let configAlert: AlertUI = (kAppName, errorMessage)
                        UIAlertController.showAlert(configAlert)
                    }
                }
            }
        }
        baseVwModel?.updateLoadingStatus = { [weak self] () in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                let isLoading = self.baseVwModel?.isLoading ?? false
                if isLoading == true {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
}

extension UIViewController {
    var isDarkMode: Bool {
        return false
    }
}


extension BaseViewController {
    
    func navigateToSignInScreen() {
        UserDefaultUtility.shared.saveUserId(userId: "")
        let signInVC = kMainStoryboard.instantiateViewController(withIdentifier: SignInViewController.className) as! SignInViewController
        let nav = UINavigationController(rootViewController: signInVC)
//        UIApplication.shared.keyWindow?.rootViewController = nav
//        UIApplication.shared.keyWindow?.window?.makeKeyAndVisible()
        let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        delegate?.window?.rootViewController = nav
        delegate?.window?.makeKeyAndVisible()
    }
    
    func navigateToHomeScreen() {
//        let tabBarVC = kHomeStoryboard.instantiateViewController(withIdentifier: MainTabBarController.className) as! MainTabBarController
        let tabBarVC = kHomeStoryboard.instantiateViewController(withIdentifier: "MainContainerVC")
        let nav = UINavigationController(rootViewController: tabBarVC)
//        UIApplication.shared.keyWindow?.rootViewController = nav
//        UIApplication.shared.keyWindow?.window?.makeKeyAndVisible()
        let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        delegate?.window?.rootViewController = nav
        delegate?.window?.makeKeyAndVisible()
    }
    
}


// MARK: - APPLE CALENDAR OPERATION METHODs
extension BaseViewController {
    /// REMOVE EVENT
    func removeEventFromAppleCalendar(event: EKEvent) {
        if EKEventStore.authorizationStatus(for: .event) == .authorized {
            do {
                try eventStore.remove(event, span: .thisEvent)
            } catch let e as NSError {
                debugPrint(e.localizedDescription)
                return
            }
        }
    }
    
    /// FETCH ALL EVENTS
    func fetchAllEvents(model: RoomData, startDate: Date, endDate: Date, completion: @escaping ((_ events: [EKEvent]) -> Void)) {
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == eventStore.defaultCalendarForNewEvents?.title {
                let selectedCalendar = calendar

                let currentCalendar = Calendar.current
//                var oneYearFromNow = currentCalendar.date(byAdding: oneYearEndDate, to: Date(), options: [])
                guard let oneYearEndDate = currentCalendar.date(byAdding: .year, value: 1, to: Date()) else { return }
                let predicate = eventStore.predicateForEvents(withStart: Date(), end: oneYearEndDate, calendars: [selectedCalendar])
                let allEvents = eventStore.events(matching: predicate)
                completion(allEvents)
            }
        }
    }
    
}


//MARK: - EXTENSION - CALCUATE END TIME
extension BaseViewController {
    
//    func calculateEndTime(arrData: RoomData) -> String? {
    func calculateEndTime(startTime: String?, duration: Double?) -> String {
        let startTime = startTime ?? ""
        let duration = duration ?? 0.0

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = startTime.contains(":") ? "hh:mma" : "hha"
        
        if let startTimeInDate = dateFormatter.date(from: startTime) {
            let timeAdded = startTimeInDate.addingTimeInterval(duration * 60 * 60)
     
            dateFormatter.dateFormat = "hh:mma"
            let strEndDate = dateFormatter.string(from: timeAdded)
            if let endDate = dateFormatter.date(from: strEndDate) {
                let endTime = dateFormatter.string(from: endDate)
                return endTime
            }
        }
        return ""
    }
}

/*
extension BaseViewController {
    
    func showCameraGalleryOptions() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
*/


extension BaseViewController {
    
    @objc func listenUnreadCountSocketEvent() {
        // UNREAD MESSAGE COUNT EVENT
        if SocketIOManager.shared.isSocketConnected() {
            SocketIOManager.shared.unreadCount { data in
                guard let resp = data?.first else { return }
                do {
                    let respData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                    let model = try JSONDecoder().decode(UnreadCountModel.self, from: respData)
                    if let count = model.unreadMsgCount, count > 0 {
                        if let tabItems = self.tabBarController?.tabBar.items {
                            let messageTab = tabItems[2]
                            messageTab.badgeValue = "\(count)"
                        }
                    } else {
                        if let tabItems = self.tabBarController?.tabBar.items {
                            let messageTab = tabItems[2]
                            messageTab.badgeValue = nil
                        }
                    }
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
}
