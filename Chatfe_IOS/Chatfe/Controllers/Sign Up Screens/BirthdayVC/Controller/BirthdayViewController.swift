//
//  BirthdayViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class BirthdayViewController: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var visibleFriends: UIButton!
    @IBOutlet weak var visibleAll: UIButton!
    
    let datePicker = UIDatePicker()
//    var privacy = "Friends"
    var privacy = ""
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        // INITIAL VALUES
        self.visibleFriends.setImage(Images.radioButtonEmpty, for: .normal)
        self.visibleAll.setImage(Images.radioButtonEmpty, for: .normal)
        
        showDatePicker()
//        self.hideKeyboardWhenTappedAround()
    }
    
    
    func showDatePicker() {
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        
        // Toolbar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicking));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicking));
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        birthdayTextField.inputAccessoryView = toolbar
        birthdayTextField.inputView = datePicker
    }
    
    @objc func doneDatePicking() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        birthdayTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
      
    }
    
    @objc func cancelDatePicking() {
        self.view.endEditing(true)
    }
    
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func backButtonTaped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func visibleFriendsTapped(_ sender: UIButton) {
        self.visibleFriends.setImage(Images.radioButtonFilled, for: .normal)
        self.visibleAll.setImage(Images.radioButtonEmpty, for: .normal)
        self.privacy = "Friends"
    }
    
    @IBAction func visibleAllTapped(_ sender: UIButton) {
        self.visibleAll.setImage(Images.radioButtonFilled, for: .normal)
        self.visibleFriends.setImage(Images.radioButtonEmpty, for: .normal)
        self.privacy = "All"
    }
    
    @IBAction func continueBtnTapped(_ sender: UIButton) {
        if birthdayTextField.text == "" {
            self.showBaseAlert("Please fill all required fields to continue.")
        } else if self.privacy == "" {
            self.showBaseAlert("Please select privacy option to continue.")
        } else {
            UserDefaultUtility.shared.saveBirthdayVisibility(visibleTo: privacy)
            if let dob = birthdayTextField.text {
                UserDefaultUtility.shared.saveBirthday(date: dob)
                let nextVC = kMainStoryboard.instantiateViewController(withIdentifier: IdentifyViewController.className) as! IdentifyViewController
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }

}
