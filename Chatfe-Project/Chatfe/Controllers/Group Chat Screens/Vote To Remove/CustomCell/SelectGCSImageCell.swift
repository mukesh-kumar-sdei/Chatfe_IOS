//
//  SelectGCSImageCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 22/08/22.
//

import UIKit

class SelectGCSImageCell: UITableViewCell {

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
    
}
