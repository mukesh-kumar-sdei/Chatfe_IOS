//
//  ProfileImageTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 12/05/22.
//

import UIKit
import Kingfisher

protocol ProfileNameDelegate {
    func saveName(name: String)
}

class ProfileImageTableViewCell: UITableViewCell {

    static let identifier = "ProfileImageTableViewCell"
    
    @IBOutlet weak var profilePicBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var preferenceIcon: UIImageView!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    var imageUrl = ""
    var editNameDelegate: EditProfileNameDelegate?
    var username = UserDefaultUtility.shared.getUsername()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editProfileBtnTapped(_ sender: UIButton) {
        self.editNameDelegate?.setEdit(to: true)
    }
    
    func showProfileImage(image: String?) {
        if let strImageUrl = image, strImageUrl != "" {
            let imageURL = URL(string: strImageUrl)
            self.profileImageView.kf.setImage(with: imageURL)
        } else {
            self.profileImageView.image = UIImage(named: "carbonCamera")
        }
    }
    
    
}

extension ProfileNameTableViewCell: ProfileNameDelegate {
    
    func saveName(name: String) {
        
    }
    
    
}
