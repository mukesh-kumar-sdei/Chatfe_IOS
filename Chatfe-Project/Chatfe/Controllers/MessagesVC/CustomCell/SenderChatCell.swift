//
//  SenderChatCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 30/06/22.
//

import UIKit
import ReactionButton
//import Reactions

class SenderChatCell: UITableViewCell {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblChatTime: UILabel!
    @IBOutlet weak var cellButton: EmojiReaction!
    @IBOutlet weak var viewEmoji: UIView!
    @IBOutlet weak var lblEmoji: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewEmoji.isHidden = true
        self.lblEmoji.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
