//
//  MessagesChatTVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 29/06/22.
//

import UIKit

class MessagesChatTVC: UITableViewCell {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var onlineDotImage: UIImageView!
    @IBOutlet weak var unreadDotImage: UIImageView!
    @IBOutlet weak var lblFriendName: UILabel!
    @IBOutlet weak var lblChatMessage: UILabel!
    @IBOutlet weak var lblChatTime: UILabel!
    @IBOutlet weak var lblFriendNameLeading: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.lblChatMessage.textColor = AppColor.appGrayColor
//        self.lblChatTime.textColor = AppColor.appGrayColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
