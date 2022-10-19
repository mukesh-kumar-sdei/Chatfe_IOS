//
//  InviteFriendsListCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 21/06/22.
//

import UIKit

class InviteFriendsListCell: UITableViewCell {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var lblFriendName: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
