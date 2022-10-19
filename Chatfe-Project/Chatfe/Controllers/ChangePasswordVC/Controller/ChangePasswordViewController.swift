//
//  ChangePasswordViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var changePasswordTextField: UITextField!
    
    lazy var changePasswordViewModel: ChangePasswordViewModel = {
        let obj = ChangePasswordViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var media = ""
    var mediaValue = ""
    var otpResponse = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupClosure()
        
    }
    
    func setupClosure() {
        changePasswordViewModel.redirectControllerClosure = { [weak self] in
            DispatchQueue.main.async {
                if self?.changePasswordViewModel.resetPasswordResponse?.status == "SUCCESS" {
                    let nextVC = self?.storyboard?.instantiateViewController(withIdentifier: "PasswordChangedViewController") as! PasswordChangedViewController
                    self?.navigationController?.pushViewController(nextVC, animated: true)
//                    UIAlertController.showAlert((self?.changePasswordViewModel.resetPasswordResponse?.status, self?.changePasswordViewModel.resetPasswordResponse?.data), sender: self, actions: AlertAction.Okk) {(target) in
//                        let nextVC = self?.storyboard?.instantiateViewController(withIdentifier: "PasswordChangedViewController") as! PasswordChangedViewController
//                        self?.navigationController?.pushViewController(nextVC, animated: true)
//                    }
                } else if self?.changePasswordViewModel.resetPasswordErrorResponse?.status == "ERROR" {
                    UIAlertController.showAlert((self?.changePasswordViewModel.resetPasswordErrorResponse?.status, self?.changePasswordViewModel.resetPasswordErrorResponse?.message), sender: self, actions: AlertAction.Okk) {(target) in
                        
                    }
                }
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePasswordBtnTapped(_ sender: UIButton) {
        if passwordTextField.text?.count == 0 {
            showBaseAlert("Please enter a new password")
        } else if changePasswordTextField.text?.count == 0 {
            showBaseAlert("Please confirm your new password")
        } else if changePasswordTextField.text != passwordTextField.text {
            showBaseAlert("Both Password did not match")
        } else {
            if self.media == "phone" {
                self.mediaValue = "+91" + mediaValue
            }
            let params = ["\(media)": mediaValue, "otp": "", "password": changePasswordTextField.text ?? ""]
            changePasswordViewModel.resetPassword(params: params)
        }
    }

}
