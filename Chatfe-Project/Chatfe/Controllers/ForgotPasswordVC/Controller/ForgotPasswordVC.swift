//
//  ForgotPasswordVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 03/06/22.
//

import UIKit

class ForgotPasswordVC: BaseViewController {

    @IBOutlet weak var radioBtnPhone: UIButton!
    @IBOutlet weak var radioBtnEmail: UIButton!
    @IBOutlet weak var txtPhoneOREmail: CustomTextField!
    @IBOutlet weak var btnSendCode: UIButton!

    lazy var viewModel: ForgotPasswordViewModel = {
        let obj = ForgotPasswordViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var type = "email"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupClosure()
//        hideKeyboardWhenTappedAround()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func setupView() {
        self.txtPhoneOREmail.delegate = self
        self.radioBtnEmail.setImage(Images.radioButtonFilled, for: .normal)
        self.txtPhoneOREmail.placeholder = "Email"
        self.txtPhoneOREmail.keyboardType = .emailAddress
    }
    
    func setupClosure() {
        
        viewModel.redirectControllerClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.moveToEnterOTPScreen()
            }
        }
    }
    
    func moveToEnterOTPScreen() {
        let enterCodeVC = kMainStoryboard.instantiateViewController(withIdentifier: EnterCodeViewController.className) as! EnterCodeViewController
        enterCodeVC.redirect = true
        enterCodeVC.label = "Forgot Password"
        enterCodeVC.media = self.type
        enterCodeVC.enteredValue = self.txtPhoneOREmail.text ?? ""
        self.navigationController?.pushViewController(enterCodeVC, animated: true)
    }

    
    @IBAction func radioButtonClicked(_ sender: UIButton) {
        if sender.tag == 101 {
            self.type = "phone"
            self.radioBtnPhone.setImage(Images.radioButtonFilled, for: .normal)
            self.radioBtnEmail.setImage(Images.radioButtonEmpty, for: .normal)
            
            self.txtPhoneOREmail.placeholder = "Phone Number"
            self.txtPhoneOREmail.text = ""
            if self.txtPhoneOREmail.isFirstResponder {
                txtPhoneOREmail.resignFirstResponder()
            }
            self.txtPhoneOREmail.autocorrectionType = .no
            self.txtPhoneOREmail.textContentType = .telephoneNumber
            self.txtPhoneOREmail.keyboardType = .numberPad
            self.txtPhoneOREmail.becomeFirstResponder()
        } else {
            self.type = "email"
            self.radioBtnPhone.setImage(Images.radioButtonEmpty, for: .normal)
            self.radioBtnEmail.setImage(Images.radioButtonFilled, for: .normal)
            
            self.txtPhoneOREmail.placeholder = "Email"
            self.txtPhoneOREmail.text = ""
            if self.txtPhoneOREmail.isFirstResponder {
                txtPhoneOREmail.resignFirstResponder()
            }
            self.txtPhoneOREmail.autocorrectionType = .no
            self.txtPhoneOREmail.textContentType = .emailAddress
            self.txtPhoneOREmail.keyboardType = .emailAddress
            self.txtPhoneOREmail.becomeFirstResponder()
        }
    }
    
    @IBAction func sendCodeBtnTapped(_ sender: UIButton) {
        if self.txtPhoneOREmail.text?.count ?? 0 > 0 {
            if self.radioBtnPhone.currentImage == Images.radioButtonFilled {
                self.viewModel.forgotPswrdPhoneSendOTPAPI(phone: "+91" + (self.txtPhoneOREmail.text ?? ""))
            } else if self.radioBtnEmail.currentImage == Images.radioButtonFilled {
                self.viewModel.forgotPswrdEmailSendOTPAPI(email: self.txtPhoneOREmail.text ?? "")
            }
        } else {
            self.showBaseAlert("Please enter Phone number or Email to send OTP for further process.")
        }
    }

    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension ForgotPasswordVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
