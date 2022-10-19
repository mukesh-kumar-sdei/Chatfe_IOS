//
//  EnterCodeViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class EnterCodeViewController: BaseViewController {
    
    @IBOutlet weak var forgotPasswordLbl: UILabel!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    
    lazy var enterCodeViewModel: EnterCodeViewModel = {
        let obj = EnterCodeViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    lazy var sendOTPViewModel: SendOTPViewModel = {
        let obj = SendOTPViewModel(userService: UserService())
        return obj
    }()
    
    var redirect = false
    var label = ""
    var media = ""
    var otp = ""
    var enteredValue = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        setUpClosure()
//        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setUpView() {
        self.forgotPasswordLbl.text = label
        
        self.textField1.borderStyle = .none
        self.textField2.borderStyle = .none
        self.textField3.borderStyle = .none
        self.textField4.borderStyle = .none
        
        textField1.delegate = self
        textField1.tag = 0
        textField2.delegate = self
        textField2.tag = 1
        textField3.delegate = self
        textField3.tag = 2
        textField4.delegate = self
        textField4.tag = 3
        
        textField1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == textField1 {
            if (textField1.text?.count)! >= 1 {
                textField2.becomeFirstResponder()
            }
        } else if textField == textField2 {
            if (textField2.text?.count)! >= 1 {
                textField3.becomeFirstResponder()
            }
        } else if textField == textField3 {
            if (textField3.text?.count)! >= 1 {
                textField4.becomeFirstResponder()
            }
        } else if textField == textField4 {
            if (textField4.text?.count)! >= 1 {
                textField4.resignFirstResponder()
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        if (textField1.text?.count != 0 && textField2.text?.count != 0 && textField3.text?.count != 0 && textField4.text?.count != 0) {
            if let otp1 = textField1.text, let otp2 = textField2.text, let otp3 = textField3.text, let otp4 = textField4.text {
                otp = ("\(otp1)\(otp2)\(otp3)\(otp4)")
                if self.redirect == true {
                    if media == "phone" {
                        self.enterCodeViewModel.verifyForgotPasswordOTP(email: "", phone: "+91" + enteredValue, otp: otp)
                    } else if media == "email" {
                        self.enterCodeViewModel.verifyForgotPasswordOTP(email: enteredValue, phone: "", otp: otp)
                    }
                } else {
                    if media == "phone" {
                        enterCodeViewModel.verifyPhone(phNo: UserDefaultUtility.shared.getPhoneNumber() ?? "", otp: otp)
                    } else if media == "email" {
                        enterCodeViewModel.verifyEmail(email: UserDefaultUtility.shared.getEmail() ?? "", otp: otp)
                    }
                }
            }
        } else {
            self.showBaseAlert("Please Enter Correct OTP")
        }
    }
    @IBAction func resendCodeBtnTapped(_ sender: UIButton) {
        if media == "phone" {
            sendOTPViewModel.sendOTP(key: media, values: UserDefaultUtility.shared.getPhoneNumber() ?? "")
        } else if media == "email" {
            sendOTPViewModel.sendEmail(key: media, values: UserDefaultUtility.shared.getEmail() ?? "")
        }
    }
    
    func setUpClosure() {
        enterCodeViewModel.redirectControllerClosure = { [weak self] in
            DispatchQueue.main.async {
                if self?.redirect == false {
//                    debugPrint("ERROR", self?.enterCodeViewModel.enterCodeErrorResponse?.status)
                    if self?.enterCodeViewModel.enterCodeResponseModel?.status == "SUCCESS"
                    {
                        UIAlertController.showAlert((self?.enterCodeViewModel.enterCodeResponseModel?.status, self?.enterCodeViewModel.enterCodeResponseModel?.data), sender: self, actions: AlertAction.Okk) { (target) in
                            let nextVC = self?.storyboard?.instantiateViewController(withIdentifier: "BirthdayViewController") as! BirthdayViewController
                            self?.navigationController?.pushViewController(nextVC, animated: true)
                        }
                    } else
                    if self?.enterCodeViewModel.enterCodeErrorResponse?.status == "ERROR" {
                        UIAlertController.showAlert((self?.enterCodeViewModel.enterCodeErrorResponse?.status, self?.enterCodeViewModel.enterCodeErrorResponse?.message), sender: self, actions: AlertAction.Okk) { (target) in
                            
                        }
                    }
                } else if self?.redirect == true {
                    self?.moveToChangePassword()
                    /*if self?.enterCodeViewModel.enterCodeResponseModel?.status == "SUCCESS" {
                        UIAlertController.showAlert((self?.enterCodeViewModel.enterCodeResponseModel?.status, self?.enterCodeViewModel.enterCodeResponseModel?.data), sender: self, actions: AlertAction.Okk) { (target) in
                            let nextVC = self?.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                            nextVC.media = self?.media ?? "email"
                            if self?.media == "phone" {
                                nextVC.mediaValue = UserDefaultUtility.shared.getPhoneNumber() ?? ""
                            } else if self?.media == "email" {
                                nextVC.mediaValue = UserDefaultUtility.shared.getEmail() ?? ""
                            }
                            nextVC.otpResponse = self?.otp ?? ""
                            self?.navigationController?.pushViewController(nextVC, animated: true)
                        }
                    } else if self?.enterCodeViewModel.enterCodeErrorResponse?.status == "ERROR" {
                        UIAlertController.showAlert((self?.enterCodeViewModel.enterCodeErrorResponse?.status, self?.enterCodeViewModel.enterCodeErrorResponse?.message), sender: self, actions: AlertAction.Okk){ (target) in
                        }
                    }*/
                }
            
            }
        }
        
        sendOTPViewModel.redirectControllerClosure = { [weak self] in
            DispatchQueue.main.async {
                UIAlertController.showAlert((self?.sendOTPViewModel.sendOTPResponseModel?.status, self?.sendOTPViewModel.sendOTPResponseModel?.data), sender: self, actions: AlertAction.Okk) { (target) in
                    if self?.media == "phone" {
                        
                        
//                        let nextVC = self?.storyboard?.instantiateViewController(withIdentifier: "EnterCodeViewController") as! EnterCodeViewController
//                        nextVC.redirect = true
//                        nextVC.label = "Enter OTP"
//                        nextVC.media = self?.media ?? "phone"
//                        self?.navigationController?.pushViewController(nextVC, animated: true)
                      
                    } else if self?.media == "email" {
                        
                        
//                        let nextVC = self?.storyboard?.instantiateViewController(withIdentifier: "EnterCodeViewController") as! EnterCodeViewController
//                        nextVC.redirect = true
//                        nextVC.label = "Enter OTP"
//                        nextVC.media = "email"
//                        self?.navigationController?.pushViewController(nextVC, animated: true)
                     

                        }
            }
            }
        }
    }
    
    
    func moveToChangePassword() {
        let changePswrdVC = kMainStoryboard.instantiateViewController(withIdentifier: ChangePasswordViewController.className) as! ChangePasswordViewController
        changePswrdVC.media = self.media
        changePswrdVC.mediaValue = self.enteredValue
        self.navigationController?.pushViewController(changePswrdVC, animated: true)
    }
}

extension EnterCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle backspace/delete
        guard !string.isEmpty else {
            // Backspace detected, allow text change, no need to process the text any further
            return true
        }
        // Input Validations
        // Prevent invalid character input, if keyboard is numberpad
        if textField.keyboardType == .numberPad {
            // Check for invalid input characters
//            if CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
//                // Present alert so the user knows what went wrong
//                self.showBaseAlert("This field accepts only numeric entries")
//                // Invalid characters detected, disallow text change
//                return false
//            }
        }
        
        // Length Processing
        // Need to convert the NSRange to a Swift-appropriate type
        if let text = textField.text, let range = Range(range, in: text) {
            let proposedText = text.replacingCharacters(in: range, with: string)
            // Check proposed text length does not exceed max character count
            guard proposedText.count <= 1 else {
                // Present alert if pasting text
                // easy: pasted data has a length greater than 1; who copy/pastes one character?
                if string.count > 1 {
                    // Pasting text, present alert so the user knows what went wrong
                    self.showBaseAlert("Paste failed: Maximum character count exceeded.")
                }
                // Character count exceeded, disallow text change
                return false
            }
        }
        return true
    }
    
    private func tagBasedTextField(_ textField: UITextField) {
        let nextTextFieldTag = textField.tag + 1
        
        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tagBasedTextField(textField)
        return true
    }
}
