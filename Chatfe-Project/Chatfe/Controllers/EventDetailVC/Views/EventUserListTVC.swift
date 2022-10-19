//
//  EventUserListTVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 13/06/22.
//

import UIKit

class EventUserListTVC: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var lblFriendName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
