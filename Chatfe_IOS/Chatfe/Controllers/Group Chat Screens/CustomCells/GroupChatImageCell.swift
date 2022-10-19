//
//  GroupChatImageCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 08/08/22.
//

import UIKit

class GroupChatImageCell: UITableViewCell {

    @IBOutlet weak var imgMatchPref: UIImageView!
    @IBOutlet weak var lblChatMessage: UILabel!
    
    @IBOutlet weak var pictureView: EmojiReaction!
    @IBOutlet weak var sentImageButton: UIButton!
    
    @IBOutlet weak var viewEmoji: UIView!
    @IBOutlet weak var viewEmojiHeight: NSLayoutConstraint!
    @IBOutlet weak var lblEmoji: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sentImageButton.layer.masksToBounds = true
        self.sentImageButton.layer.cornerRadius = 10.0
        self.sentImageButton.imageView?.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showEmojiReaction(messages: GetEventChatsModel) {
        DispatchQueue.main.async {
            if messages.reaction?.count ?? 0 > 0 {
                if messages.reaction?.first?.reaction != "" {
                    self.viewEmoji.isHidden = false
                    self.lblEmoji.isHidden = false
                    self.lblEmoji.text = messages.reaction?.first?.reaction
                    self.viewEmojiHeight.constant = 30.0
                } else {
                    self.viewEmoji.isHidden = true
                    self.lblEmoji.isHidden = true
                    self.viewEmojiHeight.constant = 0.0
                }
            } else {
                self.viewEmoji.isHidden = true
                self.lblEmoji.isHidden = true
                self.viewEmojiHeight.constant = 0.0
            }
        }
    }
    
    func showImage(strImage: String) {
        DispatchQueue.main.async {
            if let sentImageURL = URL(string: strImage) {
                self.sentImageButton.kf.setImage(with: sentImageURL, for: .normal)
            }
        }
    }
    
    func updateMatchPrefIcon(matchType: String) {
        DispatchQueue.main.async {
            /// SETTING UP MATCH PREFERENCE IMAGE ICON
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
