//
//  ReceiverChatCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 30/06/22.
//

import UIKit
import ReactionButton

class ReceiverChatCell: UITableViewCell {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblChatTime: UILabel!
    @IBOutlet weak var viewEmoji: UIView!
    @IBOutlet weak var lblEmoji: UILabel!
    @IBOutlet weak var cellButton: EmojiReaction!
//    @IBOutlet weak var cellButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.viewEmoji.isHidden = true
        self.lblEmoji.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
