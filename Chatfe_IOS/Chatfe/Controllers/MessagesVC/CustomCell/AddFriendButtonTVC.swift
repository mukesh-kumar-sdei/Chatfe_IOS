//
//  AddFriendButtonTVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 07/07/22.
//

import UIKit

class AddFriendButtonTVC: UITableViewCell {

    @IBOutlet weak var imgAddFriend: UIImageView!
    @IBOutlet weak var lblAddFriend: UILabel!
    @IBOutlet weak var btnAddFriend: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let addFriendImage = Images.personAdd?.withRenderingMode(.alwaysTemplate)
        self.imgAddFriend.image = addFriendImage
        self.imgAddFriend.tintColor = AppColor.appBlueColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
