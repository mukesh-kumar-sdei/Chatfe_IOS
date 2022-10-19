//
//  BlockListCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 26/07/22.
//

import UIKit

class BlockListCell: UITableViewCell {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnUnblock: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
