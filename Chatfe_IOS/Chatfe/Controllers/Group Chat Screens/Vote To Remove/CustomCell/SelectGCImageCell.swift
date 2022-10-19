//
//  SelectGCImageCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 22/08/22.
//

import UIKit

class SelectGCImageCell: UITableViewCell {

    @IBOutlet weak var imgMatchPref: UIImageView!
    @IBOutlet weak var lblChatMessage: UILabel!
    @IBOutlet weak var imgSentPhoto: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgSentPhoto.layer.masksToBounds = true
        self.imgSentPhoto.layer.cornerRadius = 10.0
        self.imgSentPhoto.contentMode = .scaleAspectFill
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
