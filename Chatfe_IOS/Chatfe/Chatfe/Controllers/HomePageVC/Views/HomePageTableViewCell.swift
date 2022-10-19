//
//  HomePageTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 29/04/22.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var roomNameLbl: UILabel!
    @IBOutlet weak var roomTimingsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func displayText(name: String, time: String, image: String) {
        self.roomNameLbl.text = name
        self.roomTimingsLbl.text = time
        self.roomImageView.image = UIImage(named: image)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        debugPrint("Add Btn Tapped!")
    }
    
}
