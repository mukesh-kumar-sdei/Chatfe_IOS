//
//  IdentifyViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class IdentifyViewController: BaseViewController {
    
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
//    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var transFemaleBtn: UIButton!
    @IBOutlet weak var transMaleBtn: UIButton!
    @IBOutlet weak var genderVariantBtn: UIButton!
    @IBOutlet weak var notListedBtn: UIButton!
    @IBOutlet weak var notListedTextField: UITextField!
    @IBOutlet weak var preferNotBtn: UIButton!
    
    @IBOutlet weak var visibleAll: UIButton!
    @IBOutlet weak var visibleFriends: UIButton!
    
    var identity = ""
//    var privacy = "Friends"
    var privacy = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.visibleFriends.setImage(Images.radioButtonEmpty, for: .normal)
        self.visibleAll.setImage(Images.radioButtonEmpty, for: .normal)
//        self.hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func maleBtnTapped(_ sender: UIButton) {
        self.femaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.maleBtn.setImage(Images.radioButtonFilled, for: .normal)
        self.transFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.transMaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.transFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.genderVariantBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.notListedBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.preferNotBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.identity = "Male"
    }
    
    @IBAction func femaleBtnTapped(_ sender: UIButton) {
        self.femaleBtn.setImage(Images.radioButtonFilled, for: .normal)
        self.maleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.transFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.transMaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.genderVariantBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.notListedBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.preferNotBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.identity = "Female"
    }
    /*
    @IBAction func otherBtnTapped(_ sender: UIButton) {
        self.maleBtn.backgroundColor = .white
        self.femaleBtn.backgroundColor = .white
        self.otherBtn.backgroundColor = UIColor(cgColor: CGColor(red: 0/255, green: 155/255, blue: 204/255, alpha: 1.0))
        self.otherBtn.setTitleColor(.white, for: .normal)
        self.maleBtn.setTitleColor(.black, for: .normal)
        self.femaleBtn.setTitleColor(.black, for: .normal)
        self.identity = "Other"
    }
    */
    @IBAction func visibleAllTapped(_ sender: UIButton) {
        self.visibleAll.setImage(Images.radioButtonFilled, for: .normal)
        self.visibleFriends.setImage(Images.radioButtonEmpty, for: .normal)
        self.privacy = "All"
    }
    
    @IBAction func visibleFriendsTapped(_ sender: UIButton) {
        self.visibleFriends.setImage(Images.radioButtonFilled, for: .normal)
        self.visibleAll.setImage(Images.radioButtonEmpty, for: .normal)
        self.privacy = "Friends"
    }
    
    @IBAction func transFemaleBtnTapped(_ sender: UIButton) {
        self.maleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.femaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.transFemaleBtn.setImage(Images.radioButtonFilled, for: .normal)
        self.transMaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.genderVariantBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.notListedBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.preferNotBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.identity = "Transgender Female"
    }
    @IBAction func transMaleBtnTapped(_ sender: UIButton) {
        self.femaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.maleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.transFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.transMaleBtn.setImage(Images.radioButtonFilled, for: .normal)
        self.genderVariantBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.notListedBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.preferNotBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.identity = "Transgender Male"
    }
    
    
    @IBAction func genderVariantBtnTapped(_ sender: UIButton) {
        self.femaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.maleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.transFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.transMaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.genderVariantBtn.setImage(Images.radioButtonFilled, for: .normal)
        self.notListedBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.preferNotBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.identity = "Gender Variant"
    }
    
    @IBAction func notListedBtnTapped(_ sender: UIButton) {
        self.femaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.maleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.transFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.transMaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.genderVariantBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.notListedBtn.setImage(Images.radioButtonFilled, for: .normal)
        self.preferNotBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.identity = self.notListedTextField.text ?? ""
    }
    
    @IBAction func preferNotBtnTapped(_ sender: UIButton) {
        self.femaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.maleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.transFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.transMaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.genderVariantBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.notListedBtn.setImage(Images.radioButtonEmpty, for: .normal)
        self.preferNotBtn.setImage(Images.radioButtonFilled, for: .normal)
        self.identity = "Prefer Not to Answer"
    }
    
    @IBAction func continueBtnTapped(_ sender: UIButton) {
        if identity == "" {
            self.showBaseAlert("Please select an option to continue")
        } else if privacy == "" {
            self.showBaseAlert("Please select privacy option to continue.")
        } else {
            UserDefaultUtility.shared.saveIdentity(identity: identity)
            UserDefaultUtility.shared.saveIdentityVisibility(visibleTo: privacy)
            let nextVC = kMainStoryboard.instantiateViewController(withIdentifier: DatingInterestViewController.className) as! DatingInterestViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

}
