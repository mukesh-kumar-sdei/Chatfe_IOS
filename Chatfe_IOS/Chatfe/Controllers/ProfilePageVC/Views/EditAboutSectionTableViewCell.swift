//
//  EditAboutSectionTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 26/05/22.
//

import UIKit

class EditAboutSectionTableViewCell: UITableViewCell {
    
    static let identifier = "EditAboutSectionTableViewCell"
    
    var editAboutDelegate: EditProfileNameDelegate?
    var parentVC: BaseViewController!
    
    lazy var profilePageViewModel: ProfilePageViewModel = {
        let obj = ProfilePageViewModel(userService: UserService())
        self.parentVC.baseVwModel = obj
        return obj
    }()
    
    
    var editAbout = false
//    @IBOutlet weak var datingLbl: UILabel!
//    @IBOutlet weak var identityLbl: UILabel!
//    @IBOutlet weak var hometownLbl: UILabel!
//    @IBOutlet weak var ageLbl: UILabel!
//    @IBOutlet weak var upperStackView: UIStackView!
    @IBOutlet weak var lowerStackView: UIStackView!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var transgenderFemaleBtn: UIButton!
    @IBOutlet weak var religionTextField: UITextField!
    @IBOutlet weak var hometownTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var yesStackView: UIStackView!
    @IBOutlet weak var noStackView: UIStackView!
    @IBOutlet weak var otherStackView: UIStackView!
    @IBOutlet weak var maleStackView: UIStackView!
    @IBOutlet weak var femaleStackView: UIStackView!
    @IBOutlet weak var transgenderFemaleStackView: UIStackView!
    @IBOutlet weak var transgenderMaleStackView: UIStackView!
    @IBOutlet weak var genderVariantStackView: UIStackView!
    @IBOutlet weak var preferNotStackView: UIStackView!
    @IBOutlet weak var transgenderMaleBtn: UIButton!
    @IBOutlet weak var genderVariantBtn: UIButton!
    @IBOutlet weak var preferNotBtn: UIButton!
    @IBOutlet weak var notListedStackView: UIStackView!
    @IBOutlet weak var notListedBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        if editAbout == false {
//            self.saveBtn.setImage(UIImage(named: "editIcon"), for: .normal)
//             self.saveBtn.setTitle("", for: .normal)
//             self.saveBtn.backgroundColor = .black
//            self.lowerStackView.isHidden = true
//        } else {
//            self.saveBtn.setImage(nil, for: .normal)
//            self.saveBtn.backgroundColor = AppColor.appBlueColor
//            self.saveBtn.setTitle("Save", for: .normal)
//            self.saveBtn.setTitleColor(.white, for: .normal)
//            self.upperStackView.isHidden = true
//        }
        
       hometownTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        self.yesStackView.addGestureRecognizer(tapGesture)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(tapped1(_:)))
        self.noStackView.addGestureRecognizer(tapGesture1)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(tapped2(_:)))
        self.otherStackView.addGestureRecognizer(tapGesture2)
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(tapped3(_:)))
        self.maleStackView.addGestureRecognizer(tapGesture3)
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(tapped4(_:)))
        self.femaleStackView.addGestureRecognizer(tapGesture4)
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(tapped5(_:)))
        self.transgenderFemaleStackView.addGestureRecognizer(tapGesture5)
        let tapGesture6 = UITapGestureRecognizer(target: self, action: #selector(tapped6(_:)))
        self.transgenderMaleStackView.addGestureRecognizer(tapGesture6)
        let tapGesture7 = UITapGestureRecognizer(target: self, action: #selector(tapped7(_:)))
        self.genderVariantStackView.addGestureRecognizer(tapGesture7)
        let tapGesture8 = UITapGestureRecognizer(target: self, action: #selector(tapped8(_:)))
        self.notListedStackView.addGestureRecognizer(tapGesture8)
        let tapGesture9 = UITapGestureRecognizer(target: self, action: #selector(tapped9(_:)))
        self.preferNotStackView.addGestureRecognizer(tapGesture9)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        self.religionTextField.isUserInteractionEnabled = false
        self.ageTextField.isUserInteractionEnabled = false
        
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        parentVC.view.frame.origin.y = -150 // Move 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        parentVC.view.frame.origin.y = 0 // Move the view to its original position
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
//        if editAbout == false {
//            self.editAbout.toggle()
//            self.saveBtn.setImage(nil, for: .normal)
//            self.saveBtn.backgroundColor = AppColor.appBlueColor
//            self.saveBtn.setTitle("Save", for: .normal)
//            self.saveBtn.setTitleColor(.white, for: .normal)
//            self.upperStackView.isHidden = true
//            self.lowerStackView.isHidden = false
//        } else {
//            self.editAbout.toggle()
//            self.saveBtn.setImage(UIImage(named: "editIcon"), for: .normal)
//             self.saveBtn.setTitle("", for: .normal)
//             self.saveBtn.backgroundColor = .black
//             self.upperStackView.isHidden = false
//            self.lowerStackView.isHidden = true
        if UserDefaultUtility.shared.getIdentity() == "" {
            self.parentVC.showBaseAlert("Please choose your identity.")
        } else if UserDefaultUtility.shared.getDatingInterest() == "" {
            self.parentVC.showBaseAlert("Please choose your dating interest")
        } else if UserDefaultUtility.shared.getHometown() == "" {
            self.parentVC.showBaseAlert("Please enter your hometown.")
        } else {
            let params = ["gender": ["gen":UserDefaultUtility.shared.getIdentity() ?? ""],"dating":["datings": UserDefaultUtility.shared.getDatingInterest()],"hometown": ["homeTown": UserDefaultUtility.shared.getHometown()]] as [String:Any]
            profilePageViewModel.updateProfile(params: params)
        }
   
//        }
    }
    
    @IBAction func datingInterestTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            sender.setImage(UIImage(named: "optionLogoFill"), for: .normal)
            self.noBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.otherBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            UserDefaultUtility.shared.saveDatingInterest(reply: "Yes")
        case 1:
            self.yesBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            sender.setImage(UIImage(named: "optionLogoFill"), for: .normal)
            self.otherBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            UserDefaultUtility.shared.saveDatingInterest(reply: "No")
        case 2:
            self.yesBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.noBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            sender.setImage(UIImage(named: "optionLogoFill"), for: .normal)
            UserDefaultUtility.shared.saveDatingInterest(reply: "Other")
        default:
            return
        }
    }
    
    @IBAction func identityButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            sender.setImage(UIImage(named: "optionLogoFill"), for: .normal)
            self.femaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.transgenderFemaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.transgenderMaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.genderVariantBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.notListedBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.preferNotBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            UserDefaultUtility.shared.saveIdentity(identity: "Male")
            
        case 1:
            self.maleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            sender.setImage(UIImage(named: "optionLogoFill"), for: .normal)
            self.transgenderFemaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.transgenderMaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.genderVariantBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.notListedBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.preferNotBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            UserDefaultUtility.shared.saveIdentity(identity: "Female")
            
        case 2:
            self.maleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.femaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            sender.setImage(UIImage(named: "optionLogoFill"), for: .normal)
            self.transgenderMaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.genderVariantBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.notListedBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.preferNotBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            UserDefaultUtility.shared.saveIdentity(identity: "Transgender Female")
            
        case 3:
            self.maleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.femaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.transgenderFemaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            sender.setImage(UIImage(named: "optionLogoFill"), for: .normal)
            self.genderVariantBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.notListedBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.preferNotBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            UserDefaultUtility.shared.saveIdentity(identity: "Transgender Male")
            
        case 4:
            self.maleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.femaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.transgenderFemaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.transgenderMaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            sender.setImage(UIImage(named: "optionLogoFill"), for: .normal)
            self.notListedBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.preferNotBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            UserDefaultUtility.shared.saveIdentity(identity: "Gender Variant")
            
        case 5:
            self.maleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.femaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.transgenderFemaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.transgenderMaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.genderVariantBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            sender.setImage(UIImage(named: "optionLogoFill"), for: .normal)
            self.preferNotBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            UserDefaultUtility.shared.saveIdentity(identity: "Not Listed")
            
        case 6:
            self.maleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.femaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.transgenderFemaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.transgenderMaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.genderVariantBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            self.notListedBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
            sender.setImage(UIImage(named: "optionLogoFill"), for: .normal)
            UserDefaultUtility.shared.saveIdentity(identity: "Prefer Not to Answer")
            
        default:
            return
        }
    }
    
    
    @objc func tapped(_ gesture: UITapGestureRecognizer) {
        self.yesBtn.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        self.noBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.otherBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        UserDefaultUtility.shared.saveDatingInterest(reply: "Yes")
        debugPrint(UserDefaultUtility.shared.getDatingInterest())
        }
    @objc func tapped1(_ gesture: UITapGestureRecognizer) {
        self.noBtn.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        self.yesBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.otherBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        UserDefaultUtility.shared.saveDatingInterest(reply: "No")
    }
    
    @objc func tapped2(_ gesture: UITapGestureRecognizer) {
        self.otherBtn.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        self.yesBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.noBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        UserDefaultUtility.shared.saveDatingInterest(reply: "Other")
    }
    
    @objc func tapped3(_ gesture: UITapGestureRecognizer) {
        self.maleBtn.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        self.femaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.transgenderFemaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.transgenderMaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.genderVariantBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.notListedBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.preferNotBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        UserDefaultUtility.shared.saveIdentity(identity: "Male")
    }
    
    @objc func tapped4(_ gesture: UITapGestureRecognizer) {
        self.maleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.femaleBtn.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        self.transgenderFemaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.transgenderMaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.genderVariantBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.notListedBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.preferNotBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        UserDefaultUtility.shared.saveIdentity(identity: "Female")
    }
    
    @objc func tapped5(_ gesture: UITapGestureRecognizer) {
        self.maleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.femaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.transgenderFemaleBtn.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        self.transgenderMaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.genderVariantBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.notListedBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.preferNotBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        UserDefaultUtility.shared.saveIdentity(identity: "Transgender Female")
    }
    
    @objc func tapped6(_ gesture: UITapGestureRecognizer) {
        self.maleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.femaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.transgenderFemaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.transgenderMaleBtn.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        self.genderVariantBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.notListedBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.preferNotBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        UserDefaultUtility.shared.saveIdentity(identity: "Transgender Male")
    }
    
    @objc func tapped7(_ gesture: UITapGestureRecognizer) {
        self.maleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.femaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.transgenderFemaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.transgenderMaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.genderVariantBtn.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        self.notListedBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.preferNotBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        UserDefaultUtility.shared.saveIdentity(identity: "Gender Variant/Non-Conforming")
    }
    
    @objc func tapped8(_ gesture: UITapGestureRecognizer) {
        self.maleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.femaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.transgenderFemaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.transgenderMaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.genderVariantBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.notListedBtn.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        self.preferNotBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        UserDefaultUtility.shared.saveIdentity(identity: "Not Listed")
    }
    
    @objc func tapped9(_ gesture: UITapGestureRecognizer) {
        self.maleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.femaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.transgenderFemaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.transgenderMaleBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.genderVariantBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.notListedBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.preferNotBtn.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        UserDefaultUtility.shared.saveIdentity(identity: "Prefer Not to Answer")
    }

    
    
    func calculateAge(age: String) {
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        let currentYear = calendar.component(.year, from: date)
        let prevYear = age.before(first: "-")
        let birthYear = (currentYear) - (Int(prevYear) ?? 0)
        ageTextField.text = "\(birthYear)"
       // ageLbl.text = "\(birthYear)" ?? "Nil"
    }
    
    func setupClosure() {
        profilePageViewModel.reloadListViewClosure = { [weak self] in
            if self?.profilePageViewModel.updateProfileResponse?.status == "SUCCESS" {
                DispatchQueue.main.async {
//                    self?.parentVC.showBaseAlert(self?.profilePageViewModel.updateProfileResponse?.data ?? "")
                    self?.editAboutDelegate?.setAbout(to: false)
                }
            }  else if self?.profilePageViewModel.updateProfileErrorResponse?.status == "ERROR" {
                DispatchQueue.main.async {
                    self?.parentVC.showBaseAlert(self?.profilePageViewModel.updateProfileErrorResponse?.message ?? "")
                    self?.editAboutDelegate?.setAbout(to: false)
                }
            }
        }
    }
    
}

extension EditAboutSectionTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        debugPrint("The Hometown is ", self.hometownTextField.text)
        UserDefaultUtility.shared.saveHometown(city: self.hometownTextField.text ?? "")
//        if hometownTextField.text == "" {
//            self.parentVC.showBaseAlert("Please enter your hometown.")
//        } else {
//            UserDefaultUtility.shared.saveHometown(city: self.hometownTextField.text ?? "")
//        }
        
    }
    
}
