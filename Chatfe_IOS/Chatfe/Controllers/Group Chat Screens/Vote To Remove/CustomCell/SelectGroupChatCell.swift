//
//  SelectGroupChatCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 09/08/22.
//

import UIKit

class SelectGroupChatCell: UITableViewCell {

    @IBOutlet weak var messageView: EmojiReaction!
    @IBOutlet weak var imgMatchPref: UIImageView!
    @IBOutlet weak var lblChatMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
