//
//  MainContainerVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 31/07/22.
//


import UIKit
import GoogleMobileAds

class MainContainerVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var countdownTimer: SRCountdownTimer!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblMsgCount: UILabel!
    @IBOutlet weak var btnGrpChat: UIButton!
    
    private var interstitial: GADInterstitialAd?
    
    lazy var viewModel: MainContainerVM = {
        let obj = MainContainerVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var getChannelIdData: ChannelIdData?
    var roomMembersList: [ParticipantsData]?
    var members_matchType_color = [MembersColorNMatch]()
    var senderColor = "49C6D8"
    var unreadCount = 0
    var counter = 0
    var isOngoingEvent = false
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        connectSocket()
        setupUI()
        createInterstitialGoogleAd()
        notificationObservers()
        setupClosures()
        listenGCReceiveMessageEvent()
    }
    
    func connectSocket() {
        if UserDefaultUtility.shared.getUserId() == "" || UserDefaultUtility.shared.getUserId() == nil {
            SocketIOManager.shared.establishConnectionAfterLogin(userId: AppInstance.shared.userId ?? "")
        } else {
            if !SocketIOManager.shared.isSocketConnected() {
                SocketIOManager.shared.establishConnection()
            }
        }
    }
    
    func setupUI() {
        self.members_matchType_color.removeAll()
        lblMsgCount.isHidden = true
        lblMsgCount.layer.masksToBounds = true
        lblMsgCount.cornerRadius = lblMsgCount.bounds.height / 2
        
        setCountDownTimerUI()
    }
    
    func setCountDownTimerUI() {
        countdownTimer.isHidden = true
        countdownTimer.lineColor = AppColor.appBlueColor
        countdownTimer.cornerRadius = 30.0
        countdownTimer.layer.masksToBounds = true
    }
    
    func notificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkEventStartedTime), name: Notification.Name.JOINED_ROOMS_RESPONSE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(listenGCUnreadCount), name: Notification.Name.UNREAD_GROUP_MESSAGE_COUNT, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateGCUnreadCount(_:)), name: Notification.Name("UPDATE_GROUPCHAT_COUNT"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(showOngoingEvent(_:)), name: Notification.Name("SHOW_ONGOING_EVENT"), object: nil)
    }
    /*
    @objc func showOngoingEvent(_ notification: Notification) {
        if let endDate = notification.object as? Date {
            DispatchQueue.main.async {
                self.viewModel.getChannelID()
                self.showHideGrpChatButton(show: true)
                let currentDateTime = currentDateTime()
                let dateComponent = Calendar.current.dateComponents([.second], from: currentDateTime, to: endDate)
                if let elapsedTime = dateComponent.second {
                    self.startCountDownTimer(duration: elapsedTime)
                }
            }
        }
    }*/
    
    @objc func updateGCUnreadCount(_ notification: Notification) {
        if let count = notification.object as? Int {
            DispatchQueue.main.async {
                self.updateBadgeCount(count: count)
            }
        }
    }
    
    @objc func listenGCUnreadCount() {
        // UNREAD MESSAGE COUNT EVENT
        if SocketIOManager.shared.isSocketConnected() {
            SocketIOManager.shared.unreadGCCount { data in
                guard let resp = data?.first else { return }
                do {
                    let respData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                    let model = try JSONDecoder().decode(UnreadCountModel.self, from: respData)
                    self.updateBadgeCount(count: model.unreadGrpMsgCount)
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    func updateBadgeCount(count: Int?) {
        if let count = count {
            self.lblMsgCount.isHidden = count > 0 && !btnGrpChat.isHidden ? false : true
            self.lblMsgCount.text = "\(count)"
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }

    
    // MARK: - ==== CUSTOM METHODs ====
    func showHideGrpChatButton(show: Bool) {
        DispatchQueue.main.async {
            self.countdownTimer.isHidden = !show
            self.btnGrpChat.isHidden = !show
        }
    }
    /*
    func checkOngoingEvent() {
        if isOngoingEvent {
            let event = Persistence.cachedOngoingRoom()
            
            let currentDateTime = currentDateTime()
            guard let endDate = event?.roomId?.endDate?.convertStringToDate() else { return }
            self.viewModel.getChannelID()
            self.showHideGrpChatButton(show: true)
            // TODO: - FOR REMAINING DURATION INSTEAD TOTAL
//                            let elapsedTime = currentDateTime - endDate
            let dateComponent = Calendar.current.dateComponents([.second], from: currentDateTime, to: endDate)
            if let elapsedTime = dateComponent.second {
//                                printMessage("--> ELAPSED TIME :> \(elapsedTime)")
                self.startCountDownTimer(duration: elapsedTime)
            }
        }
    }*/
    
    @objc func checkEventStartedTime() {
        let joinedRooms = Persistence.cachedJoinedRooms()
        if let eventDetails = joinedRooms {
            for event in eventDetails {
                DispatchQueue.main.async {
                    guard let startDate = event.roomId?.startDate?.convertStringToDate() else { return }
                    guard let endDate = event.roomId?.endDate?.convertStringToDate() else { return }
                    let currentDateTime = currentDateTime()

                    let startDateResult = Calendar.current.compare(startDate, to: currentDateTime, toGranularity: .minute)
                    let endDateResult = Calendar.current.compare(endDate, to: currentDateTime, toGranularity: .minute)
                    
                    /// SHOW CIRCULAR 'GROUP CHAT' BUTTON WHEN ANY EVENT STARTED
                    if (startDateResult == .orderedSame || startDateResult == .orderedAscending) && endDateResult == .orderedDescending {
    //                    printMessage("--> ONGOING EVENT :> \(event)")
//                        self.isOngoingEvent = true
//                        Persistence.cacheOngoingRoom(event)
                        
                        self.counter += 1
                        
                        if self.counter == 1 {
                            self.viewModel.getChannelID()
                            self.showHideGrpChatButton(show: true)
                            // TODO: - FOR REMAINING DURATION INSTEAD TOTAL
//                            let elapsedTime = currentDateTime - endDate
                            let dateComponent = Calendar.current.dateComponents([.second], from: currentDateTime, to: endDate)
                            if let elapsedTime = dateComponent.second {
//                                printMessage("--> ELAPSED TIME :> \(elapsedTime)")
                                self.startCountDownTimer(duration: elapsedTime)
                            }
                        }
//                        self.openGroupChatScreen()
                        return
                    } else {
                        /// WHEN EVENT ENDs - GROUP CHAT ICON HIDES
                        //UserDefaultUtility.shared.removeChannelID()
                        self.showHideGrpChatButton(show: false)
                        self.stopTimer()
                        self.lblMsgCount.isHidden = true
                        self.counter = 0
                        
                        self.isOngoingEvent = false
                        Persistence.removeOngoingRoom()
                    }
                }
            }
            
//            self.checkOngoingEvent()
            
        } else {
            showHideGrpChatButton(show: false)
        }
    }
    
    func startCountDownTimer(duration: Int) {
        DispatchQueue.main.async {
            self.countdownTimer.lineColor = UIColor("#5EADD4")
            self.countdownTimer.trailLineColor = AppColor.appBlueColor
            
            self.countdownTimer.isLabelHidden = true
            self.countdownTimer.lineWidth = 8.0
            self.countdownTimer.start(beginingValue: duration, interval: 1)
        }
    }
    
    func startTimer() {
        AppInstance.shared.timer?.invalidate()
        AppInstance.shared.timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(checkEventStartedTime), userInfo: nil, repeats: true)
        printMessage("TIMER :> \(String(describing: AppInstance.shared.timer?.timeInterval))")
    }
    
    func stopTimer() {
        DispatchQueue.main.async {
            AppInstance.shared.timer?.invalidate()
            AppInstance.shared.timer = nil
        }
    }
    
    func setupClosures() {
        /// GET CHANNEL ID API RESPONSE
        viewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                /// JOIN GROUP EVENT
                if let channelID = self.viewModel.channelIDResp?.data?.channelId {
//                    UserDefaultUtility.shared.saveChannelID(channelID)
                    UserDefaultUtility.shared.saveMatchMakingShown(show: true)
                    SocketIOManager.shared.joinGroupChat(channelID: channelID)
                    /// GC UNREAD COUNT
                    SocketIOManager.shared.emitUnreadGCCountEvent(channelId: channelID)
                }
                self.getChannelIdData = self.viewModel.channelIDResp?.data

                /// HIT GET ROOM PARTICIPANTs API
                if let channelID = self.getChannelIdData?.channelId {
                    self.viewModel.getEventMembers(channelID: channelID)
                }
            }
        }
        
        /// ROOM PARTICIPANTs LIST API RESPONSE
        viewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.roomMembersList = self.viewModel.getMembersResp?.data
                
                /// MAPPING USER WITH MATCHTYPE & COLOR
//                 self.members_matchType_color.removeAll()
                self.roomMembersList?.forEach({ members in
                    if let id = members._id, let matchType = members.matchType, let color = members.color {
                        let member = MembersColorNMatch(id: id, matchType: matchType, color: color)
                        self.members_matchType_color.append(member)
                    }
                })
            }
        }
    }
    
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func grpChatBtnClicked(_ sender: UIButton) {
        openGoogleAds()
        openGroupChatScreen()
    }
    
    func openGoogleAds() {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
        } else {
            printMessage("Ad wasn't ready")
        }
    }
    
    func openGroupChatScreen() {
        let openGrpEventVC = kChatStoryboard.instantiateViewController(withIdentifier: EventGroupChatVC.className) as! EventGroupChatVC
        openGrpEventVC.channelID = self.getChannelIdData?.channelId ?? ""
        self.navigationController?.pushViewController(openGrpEventVC, animated: true)
    }
}


// MARK: - ==== GOOOGLE ADMODs DELEGATE METHODS ====
extension MainContainerVC: GADFullScreenContentDelegate {
    
    private func createInterstitialGoogleAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: GoogleAdsKeys.googleAdsUnitID, request: request) { [self] ads, error in
            if let error = error {
                printMessage("Failed to load interstitial Ad with error :> \(error.localizedDescription)")
                return
            }
            interstitial = ads
            interstitial?.fullScreenContentDelegate = self
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
//        openGroupChatScreen()
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
//        openGroupChatScreen()
    }

}


// MARK: - ==== ATTRIBUTED TEXT ====
extension MainContainerVC {
    
    func setAttributedText(senderName: String, senderText: String, senderColor: UIColor) {
        let regularFont = UIFont(name: AppFont.ProximaNovaRegular, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        let boldFont = UIFont(name: AppFont.ProximaNovaBold, size: 16.0) ?? UIFont.boldSystemFont(ofSize: 16.0)
        
        let attributedNameColor = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: senderColor]
        let attributedTextColor = [NSAttributedString.Key.font: regularFont, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let attributedString1 = NSMutableAttributedString(string: "\(senderName): ", attributes: attributedNameColor)
        let attributedString2 = NSMutableAttributedString(string: senderText, attributes: attributedTextColor)
        
        attributedString1.append(attributedString2)

        self.lblMessage.attributedText = attributedString1
    }
    
    // SOCKET LISTEN EVENT
    func listenGCReceiveMessageEvent() {
        SocketIOManager.shared.receiveGroupChatMessage { data in
            guard let resp = data?.first else { return }
            do {
                let respData = try JSONSerialization.data(withJSONObject: resp, options: .prettyPrinted)
                let model = try JSONDecoder().decode(GetEventChatsModel.self, from: respData)
                
                /// EMIT UNREAD COUNT
                if let channelID = model.channelId {
                    SocketIOManager.shared.emitUnreadGCCountEvent(channelId: channelID)
                }
                
                /// MAPPING COLOR
                let matchedMember = self.members_matchType_color.filter({$0.id == model.senderId?._id})
                if matchedMember.count > 0 {
                    self.senderColor = matchedMember.first?.color ?? "49C6D8"
                }
                
                if model.reaction?.count ?? 0 > 0 {
                    let senderName = "\(model.senderId?.fname ?? "") \(model.senderId?.lname ?? "")"
                    self.showMessageView(show: true, senderName: senderName, senderText: "Reacted", senderColor: self.senderColor)
                } else {
                    let senderName = "\(model.senderId?.fname ?? "") \(model.senderId?.lname ?? "")"
                    self.showMessageView(show: true, senderName: senderName, senderText: model.message ?? "", senderColor: self.senderColor)
                }
//                printMessage("--> RECEIVE GROUP MESSAGE :> \(respData.beautifyJSON())")
                
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func showMessageView(show: Bool, senderName: String, senderText: String, senderColor: String) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.viewMessage.isHidden = !show
                
                self.setAttributedText(senderName: senderName, senderText: senderText, senderColor: UIColor(senderColor))
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.5) {
                    self.viewMessage.isHidden = true
                }
            }
        }
    }
}
