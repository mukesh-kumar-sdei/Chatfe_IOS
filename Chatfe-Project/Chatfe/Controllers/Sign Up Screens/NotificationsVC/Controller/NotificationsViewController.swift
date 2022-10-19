//
//  NotificationsViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class NotificationsViewController: BaseViewController {
    
    @IBOutlet weak var allowBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    var imageData: Data?
    
    lazy var notificationsViewModel: NotificationsViewModel = {
        let obj = NotificationsViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupClosure()
    }
    
    private func setupClosure() {
        notificationsViewModel.redirectControllerClosure = { [weak self] in
            DispatchQueue.main.async {
                if self?.notificationsViewModel.registerResponseModel?.status == "SUCCESS" {
                    let nextVC = self?.storyboard?.instantiateViewController(withIdentifier: ThanksViewController.className) as! ThanksViewController
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                } else if self?.notificationsViewModel.registerErrorResponse?.status == "ERROR" {
                    UIAlertController.showAlert((self?.notificationsViewModel.registerErrorResponse?.status, self?.notificationsViewModel.registerErrorResponse?.message), sender: self, actions: AlertAction.Okk) { (target) in
                        if let destinationViewController = self?.navigationController?.viewControllers
                            .filter({$0 is SignInViewController}).first {
                            self?.navigationController?.popToViewController(destinationViewController, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func allowBtnTapped(_ sender: UIButton) {
        self.allowBtn.backgroundColor = UIColor(cgColor: CGColor(red: 57/255, green: 153/255, blue: 207/255, alpha: 1.0))
        self.allowBtn.setTitleColor(.white, for: .normal)
        self.skipBtn.backgroundColor = UIColor(cgColor: CGColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0))
        self.skipBtn.setTitleColor(.black, for: .normal)
        UserDefaultUtility.shared.sendNotifcations(reply: true)

        let params = ["dating"          : ["datings" : UserDefaultUtility.shared.getDatingInterest(),
                                           "privacy" : UserDefaultUtility.shared.getDatingVisibility()],
                      "designation"     : "User",
                      "dob"             : ["birthdate": UserDefaultUtility.shared.getBirthday(),
                                           "privacy": UserDefaultUtility.shared.getBirthdayVisibility()],
                      "drink"           : UserDefaultUtility.shared.getSelectedDrink() ?? "",
                      "email"           : UserDefaultUtility.shared.getEmail() ?? "",
                      "fname"           : UserDefaultUtility.shared.getFirstName(),
                      "gender"          : ["gen": UserDefaultUtility.shared.getIdentity(),
                                           "privacy": UserDefaultUtility.shared.getIdentityVisiblity()],
                      "hometown"        : ["homeTown": UserDefaultUtility.shared.getHometown(),
                                           "privacy": UserDefaultUtility.shared.getHometownVisibility()],
                      "interestedInDate": false,
                      "username"        : UserDefaultUtility.shared.getUsername() ?? "",
                      "lname"           : UserDefaultUtility.shared.getLastName(),
                      "password"        : UserDefaultUtility.shared.getPassword(),
                      "phone"           : UserDefaultUtility.shared.getPhoneNumber() ?? "",
                      "profileImg"      : ["image": UserDefaultUtility.shared.getProfileImageURL(),
                                           "privacy": UserDefaultUtility.shared.getProfileImageVisibility()],
                      "notification"    : UserDefaultUtility.shared.getNotifications(),
                      "isEmailVerified" : UserDefaultUtility.shared.getEmailVerified(),
                      "isMobileVerified": UserDefaultUtility.shared.getMobileVerified(),
                      "fcmToken"        : AppInstance.shared.deviceToken ?? ""
        ] as [String : Any]
        if imageData == nil {
            notificationsViewModel.registerUser(params: params, doc: [])
        } else {
            let imageFile = File(name: "profile_photo", fileName: "profile_photo.jpeg", data: imageData)
            notificationsViewModel.registerUser(params: params, doc: [imageFile])
        }
    }
    
    
    @IBAction func skipBtnTapped(_ sender: UIButton) {
        self.allowBtn.backgroundColor = UIColor(cgColor: CGColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0))
        self.allowBtn.setTitleColor(.black, for: .normal)
        self.skipBtn.backgroundColor = UIColor(cgColor: CGColor(red: 57/255, green: 153/255, blue: 207/255, alpha: 1.0))
        self.skipBtn.setTitleColor(.white, for: .normal)
        UserDefaultUtility.shared.sendNotifcations(reply: false)
        
        let params = ["dating":["datings": UserDefaultUtility.shared.getDatingInterest(),
                                "privacy": UserDefaultUtility.shared.getDatingVisibility()],
                      "designation": "User",
                      "dob": ["birthdate": UserDefaultUtility.shared.getBirthday(),
                              "privacy": UserDefaultUtility.shared.getBirthdayVisibility()],
                      "drink": "625800fccea4e51b9d865ef5",
                      "email": UserDefaultUtility.shared.getEmail() ?? "",
                      "fname": UserDefaultUtility.shared.getFirstName(),
                      "gender": ["gen": UserDefaultUtility.shared.getIdentity(),
                                 "privacy": UserDefaultUtility.shared.getIdentityVisiblity()],
                      "hometown": ["homeTown": UserDefaultUtility.shared.getHometown(),
                                   "privacy": UserDefaultUtility.shared.getHometownVisibility()],
                      "interestedInDate": false,
                      "username": UserDefaultUtility.shared.getUsername() ?? "",
                      "lname": UserDefaultUtility.shared.getLastName(),
                      "password": UserDefaultUtility.shared.getPassword(),
                      "phone": UserDefaultUtility.shared.getPhoneNumber() ?? "",
                      "profileImg": ["image": UserDefaultUtility.shared.getProfileImageURL(),
                                     "privacy": UserDefaultUtility.shared.getProfileImageVisibility()],
                      "notification": UserDefaultUtility.shared.getNotifications(),
                      "isEmailVerified": UserDefaultUtility.shared.getEmailVerified(),
                      "isMobileVerified": UserDefaultUtility.shared.getMobileVerified(),
                      "fcmToken"        : AppInstance.shared.deviceToken ?? ""
        ] as [String : Any]
        if imageData == nil {
            notificationsViewModel.registerUser(params: params, doc: [])
        } else {
            let imageFile = File(name: "profile_photo", fileName: "profile_photo.jpeg", data: imageData)
            notificationsViewModel.registerUser(params: params, doc: [imageFile])
        }
    }
    

}
