//
//  RoomClassTableViewCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 07/06/22.
//

import UIKit

class RoomClassTableViewCell: UITableViewCell {

    @IBOutlet weak var radioButtonChat: UIButton!
    @IBOutlet weak var radioButtonWatchParty: UIButton!
    
    let typeArr = [Constants.chat, Constants.watchParty]
    var isEditRoom = false
    var selectedRoomClass = String()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        radioButtonChat.setImage(Images.radioButtonEmpty, for: .normal)
        radioButtonChat.setImage(Images.radioButtonFilled, for: .selected)
        radioButtonWatchParty.setImage(Images.radioButtonEmpty, for: .normal)
        radioButtonWatchParty.setImage(Images.radioButtonFilled, for: .selected)
        
        
        if !isEditRoom {
//            radioButtonChat.isSelected = true
//            UserDefaultUtility.shared.saveRoomClass(typeArr[0])
            self.selectedChatRoom()
        } else {
            if selectedRoomClass == Constants.chat {
                self.selectedChatRoom()
            } else {
                self.selectedWatchParty()
            }
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(editRoomDefault(_:)), name: Notification.Name.EditRoomClassDefault, object: nil)
    }
/*
    @objc func editRoomDefault(_ notification: Notification) {
        DispatchQueue.main.async {
            if let object = notification.object as? String {
                if object.localizedCaseInsensitiveContains(Constants.chat) {
                    self.radioButtonChat.isSelected = true
                    self.radioButtonWatchParty.isSelected = false
                    UserDefaultUtility.shared.saveRoomClass(self.typeArr[0])
                } else {
                    self.radioButtonChat.isSelected = false
                    self.radioButtonWatchParty.isSelected = true
                    UserDefaultUtility.shared.saveRoomClass(self.typeArr[1])
                }
            }
        }
    }
*/
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        printMessage("SELECTED ROOM CLASS :> \(selected)")
        /*if selected {
            self.selectedChatRoom()
        } else {
            self.selectedWatchParty()
        }*/
    }
    
    
    @IBAction func radioButtonChatClicked(_ sender: UIButton) {
        self.selectedChatRoom()
    }
    
    @IBAction func radioButtonWatchPartyClicked(_ sender: UIButton) {
        self.selectedWatchParty()
    }
    
    func selectedChatRoom() {
        self.radioButtonChat.isSelected = true
        self.radioButtonWatchParty.isSelected = false
        UserDefaultUtility.shared.saveRoomClass(typeArr[0])
        NotificationCenter.default.post(name: Notification.Name.SelectedRoomClass, object: typeArr[0])
    }
    
    func selectedWatchParty() {
        self.radioButtonChat.isSelected = false
        self.radioButtonWatchParty.isSelected = true
        UserDefaultUtility.shared.saveRoomClass(typeArr[1])
        NotificationCenter.default.post(name: Notification.Name.SelectedRoomClass, object: typeArr[1])
    }
}
