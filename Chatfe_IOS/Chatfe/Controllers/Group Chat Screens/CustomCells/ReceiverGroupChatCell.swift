//
//  ReceiverGroupChatCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 19/08/22.
//

import UIKit

class ReceiverGroupChatCell: UITableViewCell {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var messageView: EmojiReaction!
    @IBOutlet weak var imgMatchPref: UIImageView!
    @IBOutlet weak var lblChatMessage: UILabel!
    @IBOutlet weak var lblChatMessageBottom: NSLayoutConstraint!
    
    @IBOutlet weak var viewEmoji: UIView!
    @IBOutlet weak var viewEmojiHeight: NSLayoutConstraint!
    @IBOutlet weak var lblEmoji: UILabel!
    
    
    // MARK: - ==== CELL LIFECYCLE ====
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - ==== CUSTOM METHODs ====
    func showEmojiReaction(messages: GetEventChatsModel) {
        DispatchQueue.main.async {
            /// IF ANY REACTION PRESENT
            if messages.reaction?.count ?? 0 > 0 {
                if messages.reaction?.first?.reaction != "" {
                    self.viewEmoji.isHidden = false
                    self.lblEmoji.isHidden = false
                    self.lblEmoji.text = messages.reaction?.first?.reaction
                    self.lblChatMessageBottom.constant = 30.0
                } else {
                    self.viewEmoji.isHidden = true
                    self.lblEmoji.isHidden = true
                    self.lblChatMessageBottom.constant = 0.0
                }
            } else {
                self.viewEmoji.isHidden = true
                self.lblEmoji.isHidden = true
                self.lblChatMessageBottom.constant = 0.0
            }
        }
    }
    
    /// SETTING UP MATCH PREFERENCE IMAGE ICON
    func updateImages(matchType: String) {
        DispatchQueue.main.async {
            switch matchType {
            case MatchPrefType.MatchMore:
                self.imgMatchPref.isHidden = false
                self.imgMatchPref.image = Images.matchMoreBW
            case MatchPrefType.MatchLess:
                self.imgMatchPref.isHidden = false
                self.imgMatchPref.image = Images.matchLessBW
            case MatchPrefType.MatchNever:
                self.imgMatchPref.isHidden = false
                self.imgMatchPref.image = Images.matchNeverBW
            case MatchPrefType.NoInformation:
                self.imgMatchPref.isHidden = true
            default:
                self.imgMatchPref.isHidden = true
            }
        }
    }
    
}
