//
//  ForgotPasswordViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    @IBOutlet weak var mobileCodeBtn: UIButton!
    @IBOutlet weak var mobileCodeLbl: UILabel!
    @IBOutlet weak var emailCodeBtn: UIButton!
    @IBOutlet weak var emailCodeLbl: UILabel!
    
    var media = "email"
    var values = ""
    
    lazy var sendOTPViewModel: SendOTPViewModel = {
        let obj = SendOTPViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupClosure()
    }
    
    func setupView() {
        let phoneNumber = UserDefaultUtility.shared.getPhoneNumber()
        self.mobileCodeLbl.text = phoneNumber?.masked
        
        self.values = UserDefaultUtility.shared.getEmail() ?? ""
        
        let email = UserDefaultUtility.shared.getEmail()
        let halfEmail = email?.before(first: "@")
        let secondHalfEmail = email?.after(first: "@")
        let maskedHalfEmail = halfEmail?.masked
        if let firstHalf = maskedHalfEmail, let secondHalf = secondHalfEmail {
            let finalEmail = "....\(firstHalf)@\(secondHalf)"
            self.emailCodeLbl.text = finalEmail
        }
    }
    
    func setupClosure() {
        sendOTPViewModel.redirectControllerClosure = { [weak self] in
            DispatchQueue.main.async {
                let title = self?.sendOTPViewModel.sendOTPResponseModel?.status
                UIAlertController.showAlert((title, self?.sendOTPViewModel.sendOTPResponseModel?.data), sender: self, actions: AlertAction.Okk) { (target) in
                    let nextVC = self?.storyboard?.instantiateViewController(withIdentifier: "EnterCodeViewController") as! EnterCodeViewController
                    nextVC.redirect = true
                    nextVC.label = "Forgot Password"
                    nextVC.media = self?.media ?? "email"
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        }
    }
    
    
    @IBAction func mobileCodeBtnTapped(_ sender: UIButton) {
        self.mobileCodeBtn.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        self.emailCodeBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.media = "phone"
        self.values = UserDefaultUtility.shared.getPhoneNumber() ?? ""
    }
    
    @IBAction func emailCodeBtnTapped(_ sender: UIButton) {
        self.mobileCodeBtn.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.emailCodeBtn.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        self.media = "email"
        self.values = UserDefaultUtility.shared.getEmail() ?? ""
    }
    
    @IBAction func sendCodeBtnTapped(_ sender: UIButton) {
        if self.media == "phone" {
            sendOTPViewModel.sendOTP(key: media, values: values)
            
        } else if self.media == "email" {
            sendOTPViewModel.sendEmail(key: media, values: values)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}




