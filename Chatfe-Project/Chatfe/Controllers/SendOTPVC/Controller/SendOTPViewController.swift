//
//  SendOTPViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class SendOTPViewController: BaseViewController {
    var media = "email"
    var values = ""
    lazy var sendOTPViewModel: SendOTPViewModel = {
       let obj = SendOTPViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()

    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var phoneOTP: UIButton!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBAction func phoneOTPTapped(_ sender: UIButton) {
        self.phoneOTP.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        self.emailOTP.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.media = "phone"
        self.values = UserDefaultUtility.shared.getPhoneNumber() ?? ""
    }
    @IBOutlet weak var emailOTP: UIButton!
    @IBOutlet weak var emailLbl: UILabel!
    @IBAction func emailOTPTapped(_ sender: UIButton) {
        self.emailOTP.setImage(UIImage(named: "optionLogoFill"), for: .normal)
        self.phoneOTP.setImage(UIImage(named: "optionLogoBlank"), for: .normal)
        self.media = "email"
        self.values = UserDefaultUtility.shared.getEmail() ?? ""
    }
    @IBAction func sendCodeBtnTapped(_ sender: UIButton) {
        if values == "" {
            let alert = UIAlertController(title: "Error", message: "Please select an option to continue.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if self.media == "phone" {
                sendOTPViewModel.sendOTP(key: media, values: values)
                
    //            let nextVC = storyboard?.instantiateViewController(withIdentifier: "EnterCodeViewController") as! EnterCodeViewController
    //            nextVC.redirect = true
    //            nextVC.label = "Enter OTP"
    //            nextVC.media = media
    //            self.navigationController?.pushViewController(nextVC, animated: true)
    //            if let message = sendOTPViewModel.sendOTPResponseModel?.data {
    //                self.showBaseAlert(message)
    //            }
            } else if self.media == "email" {
                sendOTPViewModel.sendEmail(key: media, values: values)
                
    //            let nextVC = storyboard?.instantiateViewController(withIdentifier: "EnterCodeViewController") as! EnterCodeViewController
    //            nextVC.redirect = true
    //            nextVC.label = "Enter OTP"
    //            nextVC.media = media
    //            self.navigationController?.pushViewController(nextVC, animated: true)
    //            if let message = sendOTPViewModel.sendOTPResponseModel?.data {
    //                self.showBaseAlert(message)
    //            }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.phoneLbl.text = UserDefaultUtility.shared.getPhoneNumber()
//        self.emailLbl.text = UserDefaultUtility.shared.getEmail()
        setupView()
        setupClosure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupView()
        setupClosure()
    }
    
    func setupView() {
        self.values = UserDefaultUtility.shared.getEmail() ?? ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedLabel))
        phoneLbl.addGestureRecognizer(tapGesture)
        emailLbl.addGestureRecognizer(tapGesture)
        let phoneNumber = UserDefaultUtility.shared.getPhoneNumber()
        self.phoneLbl.text = phoneNumber?.masked
        
        let email = UserDefaultUtility.shared.getEmail()
        let halfEmail = email?.before(first: "@")
        let secondHalfEmail = email?.after(first: "@")
        let maskedHalfEmail = halfEmail?.masked
        if let firstHalf = maskedHalfEmail, let secondHalf = secondHalfEmail {
            let finalEmail = "....\(firstHalf)@\(secondHalf)"
            self.emailLbl.text = finalEmail
        }
    
    }
    
    @objc func tappedLabel(_ sender: UILabel) {
//        if sender.tag == 1 {
//            debugPrint("Phone Lbl")
//        } else if sender.tag == 2 {
//            debugPrint("Email Lbl")
//        }
    }
    
    func setupClosure() {
        self.sendOTPViewModel.redirectControllerClosure = { [weak self] in
            DispatchQueue.main.async {
                UIAlertController.showAlert((self?.sendOTPViewModel.sendOTPResponseModel?.status, self?.sendOTPViewModel.sendOTPResponseModel?.data), sender: self, actions: AlertAction.Okk) { (target) in
                    if self?.media == "phone" {
                        
                        
                        let nextVC = self?.storyboard?.instantiateViewController(withIdentifier: "EnterCodeViewController") as! EnterCodeViewController
                        nextVC.redirect = false
                        nextVC.label = "Enter OTP"
                        nextVC.media = "phone"
                        self?.navigationController?.pushViewController(nextVC, animated: true)
                      
                    } else if self?.media == "email" {
                        
                        
                        let nextVC = self?.storyboard?.instantiateViewController(withIdentifier: "EnterCodeViewController") as! EnterCodeViewController
                        nextVC.redirect = false
                        nextVC.label = "Enter OTP"
                        nextVC.media = "email"
                        self?.navigationController?.pushViewController(nextVC, animated: true)
                     

                        }
            }
            }
    }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
