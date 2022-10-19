//
//  HometownViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class HometownViewController: BaseViewController {
    
    @IBOutlet weak var hometownTextField: UITextField!
    @IBOutlet weak var visibleAll: UIButton!
    @IBOutlet weak var visibleFriends: UIButton!
    
//    var privacy = "Friends"
    var privacy = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.visibleAll.setImage(Images.radioButtonEmpty, for: .normal)
        self.visibleFriends.setImage(Images.radioButtonEmpty, for: .normal)
//        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        if hometownTextField.text == "" {
            self.showBaseAlert("Please fill all the fields to continue.")
        } else if privacy == "" {
            self.showBaseAlert("Please select privacy option to continue.")
        } else {
            UserDefaultUtility.shared.saveHometown(city: hometownTextField.text ?? "")
            UserDefaultUtility.shared.saveHometownVisibility(visibleTo: privacy)
            let nextVC = kMainStoryboard.instantiateViewController(withIdentifier: FavouriteDrinkViewController.className) as! FavouriteDrinkViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    

}
