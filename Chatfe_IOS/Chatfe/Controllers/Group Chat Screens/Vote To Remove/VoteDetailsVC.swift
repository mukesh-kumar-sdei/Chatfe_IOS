//
//  VoteDetailsVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 02/08/22.
//

import UIKit

class VoteDetailsVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgDrink: UIImageView!
    @IBOutlet weak var imgMatchPref: UIImageView!
    
    @IBOutlet weak var lblQ1Ans: UILabel!
    @IBOutlet weak var lblQ2Ans: UILabel!
    
    @IBOutlet weak var selectedChatTableView: UITableView!
    @IBOutlet weak var btnSubmitVote: UIButton!
    
    lazy var viewModel: ProfilePreviewVM = {
        let obj = ProfilePreviewVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var getGrpMessagesData = [GetEventChatsModel]()
    var userID = ""
    private var selectedColor = ""
    private var selectedMatchType = ""
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        registerNIBs()
        setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func setupUI() {
        // FILTER SELECTED DATA & PASS IN ABOVE DECLARED ARRAY
        for msgID in SelectedVote.messageIDs {
//            let filteredMessageData = getGrpMessagesData.filter({$0._id == msgID})
            guard let chatArr = AppInstance.shared.getGrpChatModel else { return }
            guard let matchedData = chatArr.filter({$0._id == msgID}).first else { return }
            self.getGrpMessagesData.append(matchedData)
            self.selectedChatTableView.dataSource = self
            self.selectedChatTableView.delegate = self
            self.selectedChatTableView.allowsSelection = false
//                self.selectedChatTableView.reloadData()
//            }
        }
        
        /// SELECTED USER UI
        if let index = SelectedVote.memberList.firstIndex(where: {$0.id == userID}) {
            if let colorCode = SelectedVote.memberList[index].color {
                self.selectedColor = colorCode
                self.viewUser.backgroundColor = UIColor(colorCode, alpha: 0.2)
                self.lblUsername.textColor = UIColor(colorCode)
                self.lblUsername.text = SelectedVote.member?.fullname
            }
            if let matchType = SelectedVote.memberList[index].matchType {
                self.selectedMatchType = matchType
                self.updateMatchPrefIcon(matchType: matchType)
            }
        }
        
        if let drinkImg = URL(string: SelectedVote.member?.drinkImg ?? "") {
            self.imgDrink.kf.setImage(with: drinkImg)
        }
        
        self.lblQ1Ans.text = SelectedVote.isRacist ?? false ? "Yes" : "No"
        self.lblQ2Ans.text = SelectedVote.isHarassing ?? false ? "Yes" : "No"
    }
    
    func registerNIBs() {
        selectedChatTableView.register(UINib(nibName: SelectGroupChatCell.className, bundle: nil), forCellReuseIdentifier: SelectGroupChatCell.className)
//        selectedChatTableView.register(UINib(nibName: GroupChatImageCell.className, bundle: nil), forCellReuseIdentifier: GroupChatImageCell.className)
        selectedChatTableView.register(UINib(nibName: SelectGCImageCell.className, bundle: nil), forCellReuseIdentifier: SelectGCImageCell.className)
    }
    
    func setupClosure() {
        /// VOTE TO REMOVE RESPONSE
        viewModel.reloadListViewClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                
                SelectedVote.isRacist = nil
                SelectedVote.isHarassing = nil
                SelectedVote.messageIDs.removeAll()
                
                self.emitVoteMessageEvent()
                let message = self.viewModel.voteRemoveResp?.message ?? ""
                UIAlertController.showAlertAction(title: kAppName, message: message, buttonTitles: [Constants.OkAlertTitle]) { selectedIndex in
                    if selectedIndex == 0 {
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: EventGroupChatVC.self) {
                                self.navigationController?.popToViewController(controller, animated: false)
                                break
                            }
                        }
                    }
                }
            }
        }
    }

    func emitVoteMessageEvent() {
        let params = ["reportedBy"  : UserDefaultUtility.shared.getUserId() ?? "",
                      "reportedTo"  : SelectedVote.member?._id ?? "",
                      "channelId"   : SelectedVote.channelData?.channelId ?? "",
                      "RoomId"      : SelectedVote.channelData?.roomId ?? ""
                    ]
        SocketIOManager.shared.emitVoteMessage(params: params)
    }
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func submitVoteBtnClicked(_ sender: UIButton) {
        // HIT API
        let params = ["reportedBy"  : UserDefaultUtility.shared.getUserId() ?? "",
                      "reportedTo"  : SelectedVote.member?._id ?? "",
                      "channelId"   : SelectedVote.channelData?.channelId ?? "",
                      "RoomId"      : SelectedVote.channelData?.roomId ?? "",
                      "behaviors"   : ["isRacist"   : SelectedVote.isRacist ?? false,
                                       "isHarassing": SelectedVote.isHarassing ?? false],
                      "messageIds"  : SelectedVote.messageIDs
        ] as [String : Any]
        self.viewModel.voteToRemoveAPI(params: params)
    }

}


// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension VoteDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getGrpMessagesData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.getGrpMessagesData[indexPath.row]
        if data.messageType == "message" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SelectGroupChatCell.className) {
                showMessageContent(cell: cell, indexPath: indexPath, data: data)
                return cell
            }
        }
        else if data.messageType == "image" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SelectGCImageCell.className) {
                showPictureContent(cell: cell, indexPath: indexPath, data: data)
                return cell
            }
        }
    
        return UITableViewCell()
    }
    
    func showMessageContent(cell: UITableViewCell?, indexPath: IndexPath, data: GetEventChatsModel) {
        if let cell = cell as? SelectGroupChatCell {
//            cell.imgMatchPref.image = Images.matchMoreBW
            cell.updateMatchPrefIcon(matchType: self.selectedMatchType)
//            let memberColor = GroupChat.memberColor.randomElement() ?? ""
//            let senderColor = UIColor(memberColor)
            let senderColor = UIColor(selectedColor)
            
            let textMessage = data.message ?? ""
            let senderName = "\(data.senderId?.fname ?? "") \(data.senderId?.lname ?? "")"
            setAttributedText(cell: cell, senderName: senderName, senderText: textMessage, senderColor: senderColor)
        }
    }
    
    func showPictureContent(cell: UITableViewCell?, indexPath: IndexPath, data: GetEventChatsModel) {
        if let cell = cell as? SelectGCImageCell {
//            cell.imgMatchPref.image = Images.matchMoreBW
            cell.updateMatchPrefIcon(matchType: self.selectedMatchType)
//            let memberColor = GroupChat.memberColor.randomElement() ?? ""
//            let senderColor = UIColor(memberColor)
            let senderColor = UIColor(selectedColor)
            
            let textMessage = data.message ?? ""
            let senderName = "\(data.senderId?.fname ?? "") \(data.senderId?.lname ?? "")"
            setAttributedText(cell: cell, senderName: senderName, senderText: textMessage, senderColor: senderColor)
        }
    }
}


// MARK: - ==== ATTRIBUTED TEXT ====
extension VoteDetailsVC {
    
    func setAttributedText(cell: UITableViewCell?, senderName: String, senderText: String, senderColor: UIColor) {
        let regularFont = UIFont(name: AppFont.ProximaNovaRegular, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        let boldFont = UIFont(name: AppFont.ProximaNovaBold, size: 16.0) ?? UIFont.boldSystemFont(ofSize: 16.0)
        
        let attributedNameColor = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: senderColor]
        let attributedTextColor = [NSAttributedString.Key.font: regularFont, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let attributedString1 = NSMutableAttributedString(string: "\(senderName): ", attributes: attributedNameColor)
        let attributedString2 = NSMutableAttributedString(string: senderText, attributes: attributedTextColor)
        
        if let cell = cell as? SelectGroupChatCell {
            attributedString1.append(attributedString2)
            cell.lblChatMessage.attributedText = attributedString1
        } else if let cell = cell as? SelectGCImageCell {
            cell.lblChatMessage.attributedText = attributedString1
            if let imgURL = URL(string: senderText) {
                cell.imgSentPhoto.kf.setImage(with: imgURL, for: .normal)
            }
        }
    }
    
    func updateMatchPrefIcon(matchType: String) {
        DispatchQueue.main.async {
            switch matchType {
            case MatchPrefType.MatchMore:
                self.imgMatchPref.isHidden = false
                self.imgMatchPref.image = Images.matchMoreBW
            case MatchPrefType.MatchLess:
                self.imgMatchPref.isHidden = false
                self.imgMatchPref.image = Images.matchLessBW
            case MatchPrefType.MatchNever:
                self.imgMatchPref.isHidden = false
                self.imgMatchPref.image = Images.matchNeverBW
            case MatchPrefType.NoInformation:
                self.imgMatchPref.isHidden = true
            default:
                self.imgMatchPref.isHidden = true
            }
        }
    }
    
}
