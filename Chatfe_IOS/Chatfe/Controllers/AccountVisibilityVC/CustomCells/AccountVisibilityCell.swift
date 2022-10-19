//
//  AccountVisibilityCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 28/07/22.
//

import UIKit

class AccountVisibilityCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnAllText: UIButton!
    @IBOutlet weak var btnFriends: UIButton!
    @IBOutlet weak var btnFriendsText: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
