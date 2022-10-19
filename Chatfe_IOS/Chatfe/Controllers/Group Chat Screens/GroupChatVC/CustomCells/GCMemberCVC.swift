//
//  GCMemberCVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 01/08/22.
//

import UIKit

class GCMemberCVC: UICollectionViewCell {

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var imgMatchPrefIcon: UIImageView!
    @IBOutlet weak var imgDrinkIcon: UIImageView!
    @IBOutlet weak var imgDrinkIconLeading: NSLayoutConstraint!
    @IBOutlet weak var lblMemberName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateImages(data: ParticipantsData?) {
        DispatchQueue.main.async {
            // SETTING UP DRINK IMAGE ICON
            if let drinkImgURL = URL(string: data?.drinkImg ?? "") {
                self.imgDrinkIcon.kf.setImage(with: drinkImgURL)
            }
            
            /// SETTING UP MATCH PREFERENCE IMAGE ICON
            let matchType = data?.matchType ?? ""
            switch matchType {
            case MatchPrefType.MatchMore:
                self.imgMatchPrefIcon.isHidden = false
                self.imgDrinkIconLeading.constant = 55.0
                self.imgMatchPrefIcon.image = Images.matchMoreBW
            case MatchPrefType.MatchLess:
                self.imgMatchPrefIcon.isHidden = false
                self.imgDrinkIconLeading.constant = 55.0
                self.imgMatchPrefIcon.image = Images.matchLessBW
            case MatchPrefType.MatchNever:
                self.imgMatchPrefIcon.isHidden = false
                self.imgDrinkIconLeading.constant = 55.0
                self.imgMatchPrefIcon.image = Images.matchNeverBW
            case MatchPrefType.NoInformation:
                self.imgMatchPrefIcon.isHidden = true
                self.imgDrinkIconLeading.constant = 15.0
            default:
                self.imgMatchPrefIcon.isHidden = true
                self.imgDrinkIconLeading.constant = 15.0
            }
        }
    }
}
