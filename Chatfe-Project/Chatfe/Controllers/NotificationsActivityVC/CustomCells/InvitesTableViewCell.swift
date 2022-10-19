//
//  InvitesTableViewCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 14/06/22.
//

import UIKit

class InvitesTableViewCell: UITableViewCell {

    @IBOutlet weak var imgFriendProfile: UIImageView!
    @IBOutlet weak var lblFriendName: UILabel!
    @IBOutlet weak var btnJoin: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
