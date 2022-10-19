//
//  DatingInterestViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class DatingInterestViewController: BaseViewController {
    
    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var visibleAll: UIButton!
    @IBOutlet weak var visibleFriends: UIButton!
    
    var reply = ""
//    var privacy = "Friends"
    var privacy = ""
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        self.visibleFriends.setImage(Images.radioButtonEmpty, for: .normal)
        self.visibleAll.setImage(Images.radioButtonEmpty, for: .normal)
    }
    
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func yesBtnTapped(_ sender: UIButton) {
//        self.yesBtn.backgroundColor = UIColor(cgColor: CGColor(red: 0/255, green: 155/255, blue: 204/255, alpha: 1.0))
        self.yesBtn.backgroundColor = AppColor.appBlueColor
        self.yesBtn.setTitleColor(.white, for: .normal)
        self.noBtn.backgroundColor = .white
        self.otherBtn.backgroundColor = .white
        self.noBtn.setTitleColor(.black, for: .normal)
        self.otherBtn.setTitleColor(.black, for: .normal)
        self.reply = "Yes"
    }
    
    @IBAction func noBtnTapped(_ sender: UIButton) {
//        self.noBtn.backgroundColor = UIColor(cgColor: CGColor(red: 0/255, green: 155/255, blue: 204/255, alpha: 1.0))
        self.noBtn.backgroundColor = AppColor.appBlueColor
        self.noBtn.setTitleColor(.white, for: .normal)
        self.yesBtn.backgroundColor = .white
        self.otherBtn.backgroundColor = .white
        self.yesBtn.setTitleColor(.black, for: .normal)
        self.otherBtn.setTitleColor(.black, for: .normal)
        self.reply = "No"
    }
    
    @IBAction func otherBtnTapped(_ sender: UIButton) {
//        self.otherBtn.backgroundColor = UIColor(cgColor: CGColor(red: 0/255, green: 155/255, blue: 204/255, alpha: 1.0))
        self.otherBtn.backgroundColor = AppColor.appBlueColor
        self.otherBtn.setTitleColor(.white, for: .normal)
        self.yesBtn.backgroundColor = .white
        self.noBtn.backgroundColor = .white
        self.yesBtn.setTitleColor(.black, for: .normal)
        self.noBtn.setTitleColor(.black, for: .normal)
        self.reply = "Other"
    }
    
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
    
    @IBAction func continueBtnTapped(_ sender: UIButton) {
        if reply == "" {
            self.showBaseAlert("Please select an option to continue.")
        } else if privacy == "" {
            self.showBaseAlert("Please select privacy option to continue.")
        } else {
            UserDefaultUtility.shared.saveDatingInterest(reply: reply)
            UserDefaultUtility.shared.saveDatingVisibility(visibleTo: privacy)
            let nextVC = kMainStoryboard.instantiateViewController(withIdentifier: HometownViewController.className) as! HometownViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
}
