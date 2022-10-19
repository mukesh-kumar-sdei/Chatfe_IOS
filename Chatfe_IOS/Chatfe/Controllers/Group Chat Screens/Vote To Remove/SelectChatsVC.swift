//
//  SelectChatsVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 02/08/22.
//

import UIKit

class SelectChatsVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var grpChatTableView: UITableView!
    @IBOutlet weak var btnSelectChats: UIButton!
    
    lazy var viewModel: GroupChatVM = {
        let obj = GroupChatVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var getGrpMessagesData = [GetEventChatsModel]() {
        didSet {
            DispatchQueue.main.async {
                self.grpChatTableView.reloadData()
            }
        }
    }
    
    private var messageIdsDict = [Int:String]()
    var viewedUserID = ""
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        SelectedVote.messageIDs.removeAll()
        enableButtonInteraction(enabled: false)
        grpChatTableView.dataSource = self
        grpChatTableView.delegate = self
        grpChatTableView.allowsSelection = true
        grpChatTableView.allowsMultipleSelection = true
        grpChatTableView.separatorColor = .clear
        registerNIBs()
        getEventChatHistory(channelID: SelectedVote.channelData?.channelId ?? "")
        setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - ==== CUSTOM METHODs ====
    func enableButtonInteraction(enabled: Bool) {
        if enabled {
            btnSelectChats.alpha = 1.0
        } else {
            btnSelectChats.alpha = 0.5
        }
        btnSelectChats.isUserInteractionEnabled = enabled
    }

    // MARK: - ==== CUSTOM METHODs ====
    func registerNIBs() {
        grpChatTableView.register(UINib(nibName: SelectGroupChatCell.className, bundle: nil), forCellReuseIdentifier: SelectGroupChatCell.className)
        grpChatTableView.register(UINib(nibName: SelectGCImageCell.className, bundle: nil), forCellReuseIdentifier: SelectGCImageCell.className)
        grpChatTableView.register(UINib(nibName: SelectGCCell.className, bundle: nil), forCellReuseIdentifier: SelectGCCell.className)
        grpChatTableView.register(UINib(nibName: SelectGCSImageCell.className, bundle: nil), forCellReuseIdentifier: SelectGCSImageCell.className)
    }
    
    func getEventChatHistory(channelID: String) {
        self.viewModel.getGroupChatsList(channelID: channelID)
    }
    
    func setupClosure() {
        /// PREVIOUS MESSAGES (CHAT HISTORY) RESPONSE
        viewModel.reloadMenuClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.getGrpMessagesData = self.viewModel.getGroupChats ?? []
                AppInstance.shared.getGrpChatModel = self.getGrpMessagesData
                /// MAPPING MATCHTYPE & COLOR
//                self.roomMembersList?.forEach({ memberData in
                SelectedVote.memberList.forEach { memberData in
                    self.getGrpMessagesData.enumerated().forEach { (index, item) in
                        if item.senderId?._id == memberData.id {
                            self.getGrpMessagesData[index].senderId?.color = memberData.color
                            self.getGrpMessagesData[index].senderId?.matchType = memberData.matchType
                        }
                    }
                }
                self.scrollToBottom(false)
            }
        }
    }
    
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func selectChatsBtnClicked(_ sender: UIButton) {
        let voteDetailVC = kChatStoryboard.instantiateViewController(withIdentifier: VoteDetailsVC.className) as! VoteDetailsVC
        voteDetailVC.userID = self.viewedUserID
        self.navigationController?.pushViewController(voteDetailVC, animated: true)
    }
    
}


// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension SelectChatsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getGrpMessagesData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.getGrpMessagesData[indexPath.row]
        if data.senderId?._id == UserDefaultUtility.shared.getUserId() {
            if data.messageType == "message" {
                if let cell = tableView.dequeueReusableCell(withIdentifier: SelectGCCell.className) as? SelectGCCell {
                    cell.selectionStyle = .none
                    cell.lblChatMessage.text = data.message
                    return cell
                }
            }
            else if data.messageType == "image" {
                if let cell = tableView.dequeueReusableCell(withIdentifier: SelectGCSImageCell.className) as? SelectGCSImageCell {
                    cell.selectionStyle = .none
                    if let sentImg = URL(string: data.message ?? "") {
                        cell.imgSentPhoto.kf.setImage(with: sentImg, for: .normal)
                    }
                    return cell
                }
            }
        } else {
            if data.messageType == "message" {
                if let cell = tableView.dequeueReusableCell(withIdentifier: SelectGroupChatCell.className) {
                    if data.senderId?._id != viewedUserID {
                        cell.selectionStyle = .none
                    }
                    showMessageContent(cell: cell, indexPath: indexPath, data: data)
                    return cell
                }
            }
            else if data.messageType == "image" {
                if let cell = tableView.dequeueReusableCell(withIdentifier: SelectGCImageCell.className) {
                    cell.selectionStyle = .none
                    showPictureContent(cell: cell, indexPath: indexPath, data: data)
                    return cell
                }
            }
        }
    
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        printMessage("ROW SELECTED :> \(indexPath.row)")
        
        let data = self.getGrpMessagesData[indexPath.row]
        if data.senderId?._id == viewedUserID {
            let view = UIView()
            view.backgroundColor = .clear
            view.borderWidth = 1.5
            view.borderColor = AppColor.appBlueColor
            if let cell = tableView.cellForRow(at: indexPath) as? SelectGroupChatCell {
                cell.selectedBackgroundView = view
            }
            if let cell = tableView.cellForRow(at: indexPath) as? SelectGCImageCell {
                cell.selectedBackgroundView = view
            }
            if let msgID = self.getGrpMessagesData[indexPath.row]._id {
                self.messageIdsDict.updateValue(msgID, forKey: indexPath.row)
                SelectedVote.messageIDs.append(msgID)
            }
        }
//        printMessage("messageIds Dict :> \(messageIdsDict)")
//        printMessage("SelectedVote.messageIDs :> \(SelectedVote.messageIDs)")
        
//        if SelectedVote.messageIDs.count > 1 {
        if SelectedVote.messageIDs.count > 0 {
            enableButtonInteraction(enabled: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        printMessage("ROW DESELECTED :> \(indexPath.row)")
        
        let data = self.getGrpMessagesData[indexPath.row]
        if data.senderId?._id == viewedUserID {
            let view = UIView()
            view.backgroundColor = .clear
            view.borderWidth = 0.0
            if let cell = tableView.cellForRow(at: indexPath) as? SelectGroupChatCell {
                cell.selectedBackgroundView = view
            }
            if let cell = tableView.cellForRow(at: indexPath) as? SelectGCImageCell {
                cell.selectedBackgroundView = view
            }
            self.messageIdsDict.removeValue(forKey: indexPath.row)
            if let msgID = self.getGrpMessagesData[indexPath.row]._id {
                if let matchedRow = SelectedVote.messageIDs.firstIndex(where: { $0 == msgID }) {
                    SelectedVote.messageIDs.remove(at: matchedRow)
                }
            }
        }
//        printMessage("messageIds Dict :> \(messageIdsDict)")
//        printMessage("SelectedVote.messageIDs :> \(SelectedVote.messageIDs)")
        
        if SelectedVote.messageIDs.count <= 1 {
            enableButtonInteraction(enabled: false)
        }
    }
    
    func scrollToBottom(_ animated: Bool) {
        self.grpChatTableView.reloadData()
        if self.getGrpMessagesData.count > 1 {
            let rowCount = self.getGrpMessagesData.count - 1
            self.grpChatTableView.scrollToRow(at: IndexPath(row: rowCount, section: 0), at: .bottom, animated: animated)
        }
    }
    
    func showMessageContent(cell: UITableViewCell?, indexPath: IndexPath, data: GetEventChatsModel) {
        if let cell = cell as? SelectGroupChatCell {
            cell.updateMatchPrefIcon(matchType: data.senderId?.matchType ?? "")
//            cell.imgMatchPref.image = Images.matchMoreBW
//            let memberColor = GroupChat.memberColor.randomElement() ?? ""
            let memberColor = data.senderId?.color ?? "808080"
            let senderColor = UIColor(memberColor)
            
            let textMessage = data.message ?? ""
            let senderName = "\(data.senderId?.fname ?? "") \(data.senderId?.lname ?? "")"
            setAttributedText(cell: cell, senderName: senderName, senderText: textMessage, senderColor: senderColor)
//            cell.showEmojiReaction(messages: data)
        }
    }
    
    func showPictureContent(cell: UITableViewCell?, indexPath: IndexPath, data: GetEventChatsModel) {
        if let cell = cell as? SelectGCImageCell {
            cell.updateMatchPrefIcon(matchType: data.senderId?.matchType ?? "")
//            cell.imgMatchPref.image = Images.matchMoreBW
//            let memberColor = GroupChat.memberColor.randomElement() ?? ""
            let memberColor = data.senderId?.color ?? "808080"
            let senderColor = UIColor(memberColor)
            
            let textMessage = data.message ?? ""
            let senderName = "\(data.senderId?.fname ?? "") \(data.senderId?.lname ?? "")"
            setAttributedText(cell: cell, senderName: senderName, senderText: textMessage, senderColor: senderColor)
//            cell.showEmojiReaction(messages: data)
        }
    }
}


// MARK: - ==== ATTRIBUTED TEXT ====
extension SelectChatsVC {
    
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
            if let sentImg = URL(string: senderText) {
                cell.imgSentPhoto.kf.setImage(with: sentImg, for: .normal)
            }
        }
    }
    
}
