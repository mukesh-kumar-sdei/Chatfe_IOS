//
//  SignUpViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class SignUpViewController: BaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    lazy var viewModel : SignUpViewModel = {
        let obj = SignUpViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideBackButton()
//        self.hideKeyboardWhenTappedAround()
        setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    func setupClosure() {
        self.viewModel.redirectControllerClosure = { [weak self] in
            DispatchQueue.main.async {
                let nextVC = kMainStoryboard.instantiateViewController(withIdentifier: UserDetailViewController.className) as! UserDetailViewController
                self?.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    @IBAction func unhidePasswordBtnTapped(_ sender: UIButton) {
        self.passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func createAccountBtnTapped(_ sender: UIButton) {
        if usernameTextField.text?.count == 0 {
            self.showBaseAlert("Please enter a Username")
        } else if passwordTextField.text?.count == 0 {
            self.showBaseAlert("Please enter a Password")
        } else {
            if let username = usernameTextField.text {
                UserDefaultUtility.shared.saveUsername(name: username)
            }
            if let password = passwordTextField.text {
                UserDefaultUtility.shared.savePassword(pass: password)
            }
            
            // HIT API TO CHECK USERNAME
            self.viewModel.checkUsername(username: self.usernameTextField.text ?? "")
        }
     
    }
    
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
