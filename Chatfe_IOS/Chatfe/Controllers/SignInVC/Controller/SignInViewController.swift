//
//  SignInViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit
import AuthenticationServices
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class SignInViewController: BaseViewController {
    
    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var incorrectPasswordLbl: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var btnAppleSignIn: UIButton!
    @IBOutlet weak var fbLoginBtn: UIButton!
    
//    let signInConfig = GIDConfiguration.init(clientID: "1042646389750-o5np5bibm88t453d8lam3chn9g34uc7m.apps.googleusercontent.com")
    let signInConfig = GIDConfiguration.init(clientID: GoogleSignInKey.clientID)
    var params: [String:Any] = [:]
    var fbEmail = "", fbFname = "", fbLname = "", fbFacebookId = "", fbUsername = "", fbProfileImage = ""
    let appleSignIn = HSAppleSignIn()
    
    lazy var signInViewModel: SignInViewModel = {
       let obj = SignInViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var incorrectPassword: Bool = false {
        didSet {
            self.view.setNeedsDisplay()
        }
    }
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideBackButton()
//        self.hideKeyboardWhenTappedAround()
        setupView()
        appleSignInRequest()
        facebookLogin()
        setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func setupView() {
//        let userEmail = UserDefaultUtility.shared.getEmail() ?? ""
//        let phoneNo = UserDefaultUtility.shared.getPhoneNumber() ?? ""
/*        if userEmail == "" && phoneNo == "" {
            self.forgotPasswordBtn.isHidden = true
        } else {
            self.forgotPasswordBtn.isHidden = false
        }
*/
        if incorrectPassword {
            self.incorrectPasswordLbl.isHidden = false
        } else {
            self.incorrectPasswordLbl.isHidden = true
        }
    }
    
    func setupClosure() {
       
        signInViewModel.redirectControllerClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.usernameTextField.text = ""
                self?.passwordTextField.text = ""
                if self?.signInViewModel.loginResponse?.status == "ERROR" {
                    debugPrint("Error in Login")
                    self?.incorrectPasswordLbl.isHidden = false
                    self?.incorrectPassword = true
                    self?.view.layoutSubviews()
                    return
                } else {

                }
                self?.navigateToHomeScreen()
            }
        }
    }
    
    func appleSignInRequest() {
        if #available(iOS 13.0, *) {
            appleSignIn.loginWithApple(button: btnAppleSignIn) { userInfo, errorMessge in
                if let userInfo = userInfo {
                    UserDefaultUtility.shared.saveAppleInfo(userInfo)
                    let params = ["username"    : userInfo.userid,
                                  "email"       : userInfo.email,
                                  "fname"       : userInfo.firstName,
                                  "lname"       : userInfo.lastName,
//                                  "appleToken"  : token,
                                  "designation" : "User",
                                  "loginType"   : "Apple",
                                  "fcmToken"    : AppInstance.shared.deviceToken ?? ""
                    ]
                    self.signInViewModel.loginByApple(params: params)
                }
            }
        }
    }
    
    func facebookLogin() {
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to the next view controller.
            let token = token.tokenString
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, picture, short_name, name, middle_name, name_format, age_range"], tokenString: token, version: nil, httpMethod: .get)
            request.start { (connection, result, error) in
//                debugPrint("\(result)")
            }
        } else {
//            fbLoginBtn = FBLoginButton(frame: .zero, permissions: [.publicProfile, .email])
//            fbLoginBtn.permissions = ["public_profile", "email"]
//            fbLoginBtn.delegate = self
        }
    }
    
    func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: { result, error in
            if error != nil {
                debugPrint("ERROR: Trying to get login results")
            } else if result?.isCancelled != nil {
                debugPrint("The token is \(result?.token?.tokenString ?? "")")
                if result?.token?.tokenString != nil {
                    debugPrint(" Logged in ")
                    self.getFBUserProfile(token: result?.token, userId: result?.token?.userID)
                } else {
                    debugPrint("Cancelled!")
                }
            }
        })
    }
    
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        if usernameTextField.text == "" {
            self.showBaseAlert("Please Enter Username")
        } else if passwordTextField.text == "" {
            self.showBaseAlert("Please Enter Password")
        } else {
            params = ["username": usernameTextField.text ?? "", "password": passwordTextField.text ?? "", "fcmToken": AppInstance.shared.deviceToken ?? ""]
            signInViewModel.login(params: params)
        }
    }
    
    @IBAction func createAccountBtnTapped(_ sender: UIButton) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func unhidePasswordBtnTapped(_ sender: UIButton) {
        self.passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func forgotPasswordBtnTapped(_ sender: UIButton) {
//        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
//        self.navigationController?.pushViewController(nextVC, animated: true)
        let forgetPasswordVC = kMainStoryboard.instantiateViewController(withIdentifier: ForgotPasswordVC.className) as! ForgotPasswordVC
        self.navigationController?.pushViewController(forgetPasswordVC, animated: true)
    }
    
    @IBAction func googleLoginBtnTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else {
                return
            }
            if GIDSignIn.sharedInstance.currentUser != nil {
                guard let email = user?.profile?.email else { return }
                guard let fname = user?.profile?.givenName else { return }
                guard let lname = user?.profile?.familyName else { return }
                guard let googleId = GIDSignIn.sharedInstance.currentUser?.userID else { return }
//                guard let username = user?.profile?.name else { return }
                guard let profileImage = user?.profile?.imageURL(withDimension: 100) else { return }
                self.params = ["email": email, "fname": fname, "lname": lname,
                               "googleId": googleId, "designation": "User",
                               "username": googleId, "profileImg": ["image": "\(profileImage)", "privacy": "All"],
                               "loginType": "Google",
                               "fcmToken": AppInstance.shared.deviceToken ?? ""
                ]
                self.signInViewModel.loginByGoogle(params: self.params)
            }
        }
    }

    
    @IBAction func fbLoginBtnTapped(_ sender: UIButton) {
        loginButtonClicked()
    }
    
    @IBAction func mailSignInTapped(_ sender: UIButton) {
    }
    

    func getFBUserProfile(token: AccessToken?, userId: String?) {
        let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
        graphRequest.start { _, result, error in
            if error == nil {
                let data: [String: AnyObject] = result as! [String: AnyObject]
 
                // Facebook Id
                if let facebookId = data["id"] as? String {
                    debugPrint("Facebook Id: \(facebookId)")
                    self.fbFacebookId = facebookId
                } else {
                    debugPrint("Facebook Id: Not exists")
                }
                
                // Facebook First Name
                if let facebookFirstName = data["first_name"] as? String {
//                    debugPrint("Facebook First Name: \(facebookFirstName)")
                    self.fbFname = facebookFirstName
                } else {
                    debugPrint("Facebook First Name: Not exists")
                }
                
                // Facebook Middle Name
                if let facebookMiddleName = data["middle_name"] as? String {
                    debugPrint("Facebook Middle Name: \(facebookMiddleName)")
                } else {
                    debugPrint("Facebook Middle Name: Not exists")
                }
                
                // Facebook Last Name
                if let facebookLastName = data["last_name"] as? String {
//                    print("Facebook Last Name: \(facebookLastName)")
                    self.fbLname = facebookLastName
                } else {
                    debugPrint("Facebook Last Name: Not exists")
                }
                
                // Facebook Name
                if let facebookName = data["name"] as? String {
//                    print("Facebook Name: \(facebookName)")
                    self.fbUsername = facebookName
                } else {
                    debugPrint("Facebook Name: Not exists")
                }
                
                // Facebook Profile Pic URL
                let facebookProfilePicURL = "https://graph.facebook.com/\(userId ?? "")/picture?type=large"
//                print("Facebook Profile Pic URL: \(facebookProfilePicURL)")
                self.fbProfileImage = facebookProfilePicURL
                
                // Facebook Email
                if let facebookEmail = data["email"] as? String {
//                    print("Facebook Email: \(facebookEmail)")
                    self.fbEmail = facebookEmail
                } else {
                    debugPrint("Facebook Email: Not exists")
                }
                
//                print("Facebook Access Token: \(token?.tokenString ?? "")")
                
            } else {
                debugPrint("Error: Trying to get user's info")
            }
            
            self.params = ["email": self.fbEmail, "fname": self.fbFname, "lname": self.fbLname, "facebookId": self.fbFacebookId, "designation": "User",
                           "username": self.fbFacebookId, "profileImg": ["image": self.fbProfileImage, "privacy": "All"], "loginType": "Facebook", "fcmToken": AppInstance.shared.deviceToken ?? ""]
            self.signInViewModel.loginByFacebook(params: self.params)
        }
//        self.params = ["email": fbEmail, "fname": fbFname, "lname": fbLname, "facebookId": fbFacebookId, "designation": "User",
//                       "username": fbUsername, "profileImg": ["image": fbProfileImage, "privacy": "All"], "loginType": "Facebook"]
//        signInViewModel.loginByFacebook(params: params)
    }

}


extension SignInViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        request.start { (connection, result, error) in
//            debugPrint(result)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        debugPrint("Logout")
    }
}
