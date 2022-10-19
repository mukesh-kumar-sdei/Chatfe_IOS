//
//  ProfileNameTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 12/05/22.
//

import UIKit

class ProfileNameTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileNameTableViewCell"

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var nameLblView: UIView! {
        didSet {
            let tapGesture = UITapGestureRecognizer()
            tapGesture.addTarget(self, action: #selector(tapped(_:)))
            nameLblView.addGestureRecognizer(tapGesture)
        }
    }
    
    var editNameDelegate: EditProfileNameDelegate?
    var isEdit = false
    var newName = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func tapped(_ gesture: UITapGestureRecognizer) {
        self.nameLbl.becomeFirstResponder()
    }
    
    func setupView() {
        if isEdit == true {
//            debugPrint("True")
            self.nameLblView.borderColor = AppColor.appBlueColor
            self.nameLblView.borderWidth = 2
            
            self.nameTextField.isHidden = false
            self.nameTextField.text = nameLbl.text
            self.nameTextField.delegate = self
            
            self.nameLbl.isHidden = true
        } else {
            self.nameLblView.borderColor = AppColor.accentColor
            self.nameLblView.borderWidth = 0
            
            self.nameTextField.isHidden = true
            if nameTextField.text != "" {
                self.nameLbl.text = self.nameTextField.text
            }
        }
    }
}

extension ProfileNameTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.nameLbl.text = self.nameTextField.text ?? ""
        self.nameLbl.isHidden = false
        self.editNameDelegate?.setEdit(to: false)
        self.editNameDelegate?.setName(name: self.nameLbl.text ?? "")
    }
}
