//
//  ReceiverImageCell.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 15/07/22.
//

import UIKit

class ReceiverImageCell: UITableViewCell {
    
    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var lblChatTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnImage.layer.masksToBounds = true
        self.btnImage.layer.cornerRadius = 10.0
        self.btnImage.imageView?.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func setupFriendImage(strImage: String) {
        DispatchQueue.main.async {
            if let profileImgURL = URL(string: strImage) {
                self.friendImage.kf.setImage(with: profileImgURL)
            }
        }
    }
    
    func sentImage(strImage: String) {
        DispatchQueue.main.async {
            if let sentImageURL = URL(string: strImage) {
                self.btnImage.kf.setImage(with: sentImageURL, for: .normal)
            }
        }
    }
    
    func setupTime(strTime: String) {
        DispatchQueue.main.async {
            let chatTime = strTime.convertDateToSpecificTime()
            self.lblChatTime.text = chatTime
        }
    }
    
}
