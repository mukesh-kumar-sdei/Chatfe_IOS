//
//  InviteFriendsTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 10/05/22.
//

import UIKit
import TagListView

class InviteFriendsTableViewCell: UITableViewCell {
    
    static let identifier = "InviteFriendsTableViewCell"
    
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var friendsTagView: TagListView!
    @IBOutlet weak var txtEmail: CustomTextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.txtEmail.delegate = self
        self.txtEmail.attributedPlaceholder = NSAttributedString(string: self.txtEmail.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor("#383D44")])
        self.txtEmail.tintColor = UIColor.white
    }
   
    func setupTagUI(titles: [String]) {
        DispatchQueue.main.async {
            self.friendsTagView.tagBackgroundColor = UIColor("#2A2F35")
            self.friendsTagView.textFont = UIFont(name: AppFont.ProximaNovaBold, size: 16.0) ?? UIFont.boldSystemFont(ofSize: 16.0)
            self.friendsTagView.enableRemoveButton = true
            
            /// ADDING TAGs
            self.friendsTagView.addTags(titles)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

extension InviteFriendsTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtEmail {
            UserDefaultUtility.shared.saveInvitedFriendEmail(self.txtEmail.text ?? "")
        }
    }
}

