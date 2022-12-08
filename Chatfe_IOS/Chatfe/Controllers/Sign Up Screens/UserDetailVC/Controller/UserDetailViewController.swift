//
//  UserDetailViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class UserDetailViewController: BaseViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    
    lazy var viewModel: UserDetailsVM = {
        let obj = UserDetailsVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let countryCode = Locale.current.regionCode
        
//        self.hideKeyboardWhenTappedAround()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        phoneNumberTextField.maxLength = 12
        setupClosure()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150 // Move 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move the view to its original position
    }
    
    func setupClosure() {
        viewModel.redirectControllerClosure = { [weak self] in
            DispatchQueue.main.async {
                let nextVC = kMainStoryboard.instantiateViewController(withIdentifier: SendOTPViewController.className) as! SendOTPViewController
                self?.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func continueBtnTapped(_ sender: UIButton) {
        if (firstNameTextField.text?.count == 0) {
            self.showBaseAlert("Please Enter First Name")
        } else if (lastNameTextField.text?.count == 0) {
            self.showBaseAlert("Please Enter Last Name")
        } else if (emailTextField.text?.count == 0) {
            self.showBaseAlert("Please Enter Email")
        } else if (phoneNumberTextField.text?.count == 0) {
            self.showBaseAlert("Please Enter Phone Number")
        } else {
            UserDefaultUtility.shared.saveFirstName(name: firstNameTextField.text ?? "")
            UserDefaultUtility.shared.saveLastName(name: lastNameTextField.text ?? "")
            UserDefaultUtility.shared.saveEmail(email: emailTextField.text ?? "")
            UserDefaultUtility.shared.savePhoneNumber(phone: phoneNumberTextField.text ?? "")
            
            self.viewModel.checkPhoneOrEmail(phone: phoneNumberTextField.text ?? "", email: emailTextField.text ?? "")
        }
    }
    
}

