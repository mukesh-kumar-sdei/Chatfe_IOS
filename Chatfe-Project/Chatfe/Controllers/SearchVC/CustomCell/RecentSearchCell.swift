//
//  RecentSearchCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 23/06/22.
//

import UIKit

class RecentSearchCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var lblFriendName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var categoryIconView: UIView!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var btnRemove: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // CHANGE REMOVE BUTTON COLOR
        let customImage = Images.cross?.withRenderingMode(.alwaysTemplate)
        self.btnRemove.setImage(customImage, for: .normal)
        self.btnRemove.tintColor = AppColor.appGrayColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
