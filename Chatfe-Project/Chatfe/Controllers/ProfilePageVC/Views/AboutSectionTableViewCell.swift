//
//  AboutSectionTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 12/05/22.
//

import UIKit

class AboutSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var datingLbl: UILabel!
    @IBOutlet weak var identityLbl: UILabel!
    @IBOutlet weak var religionLbl: UILabel!
    @IBOutlet weak var hometownLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    
    static let identifier = "AboutSectionTableViewCell"
    var age = ""
    var editAboutDelegate: EditProfileNameDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        debugPrint("The age is ", age)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editAboutBtnTapped(_ sender: UIButton) {
        self.editAboutDelegate?.setAbout(to: true)
    }
    
    func calculateAge(age: String) {
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        let currentYear = calendar.component(.year, from: date)
        let prevYear = age.before(first: "-")
        let birthYear = (currentYear) - (Int(prevYear) ?? 0)
        ageLbl.text = "\(birthYear)"
        
    }
}
