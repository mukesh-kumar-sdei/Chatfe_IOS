//
//  SettingsViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 13/05/22.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    lazy var settingsViewModel: SettingsViewModel = {
        let obj = SettingsViewModel(userService: UserService())
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupClosure() {
        settingsViewModel.reloadListViewClosure = { [weak self] in
            if self?.settingsViewModel.logoutResponse?.status == APIKeys.success {
                DispatchQueue.main.async {
                    SocketIOManager.shared.closeConnection()
                    self?.navigateToSignInScreen()
                }
            }
            // ERROR HANDLE
            let errorResponse = self?.settingsViewModel.logoutErrorResponse
            if errorResponse?.status == APIKeys.error && (errorResponse?.message?.localizedCaseInsensitiveContains(Constants.unauthorized) ?? false) {
                DispatchQueue.main.async {
                    UIAlertController.showAlert((AlertMessage.sessionExpired, "\(errorResponse?.message ?? ""). Please Login again"), sender: self, actions: AlertAction.Okk) { action in
                        self?.navigateToSignInScreen()
                    }
                }
            }
        }
        settingsViewModel.reloadListViewClosure1 = { [weak self] in
            DispatchQueue.main.async {
                if self?.settingsViewModel.deleteAccountResponse?.status == APIKeys.success {
                    DispatchQueue.main.async {
                        SocketIOManager.shared.closeConnection()
                        self?.navigateToSignInScreen()
                    }
                }
                // ERROR HANDLE
                let errorResponse = self?.settingsViewModel.deleteAccountErrorResponse
                if errorResponse?.status == APIKeys.error && (errorResponse?.message?.localizedCaseInsensitiveContains(Constants.unauthorized) ?? false) {
                    DispatchQueue.main.async {
                        UIAlertController.showAlert((AlertMessage.sessionExpired, "\(errorResponse?.message ?? ""). Please Login again"), sender: self, actions: AlertAction.Okk) { action in
                            self?.navigateToSignInScreen()
                        }
                    }
                }
            }
        }
    }
    

    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signOutBtnTapped(_ sender: UIButton) {
        settingsViewModel.logout(params: [:])
    }
    
    @IBAction func accountVisibilityBtnTapped(_ sender: UIButton) {
        self.clearSavedVisibilityValues()
        let visibilityVC = kHomeStoryboard.instantiateViewController(withIdentifier: AccountVisibilityVC.className) as! AccountVisibilityVC
        self.navigationController?.pushViewController(visibilityVC, animated: true)
    }
    
    @IBAction func activityBtnTapped(_ sender: UIButton) {
        let activityVC = kHomeStoryboard.instantiateViewController(withIdentifier: ActivityVC.className) as! ActivityVC
        self.navigationController?.pushViewController(activityVC, animated: true)
    }
    
    @IBAction func communityRulesBtnTapped(_ sender: UIButton) {
        let webviewVC = kHomeStoryboard.instantiateViewController(withIdentifier: WebViewController.className) as! WebViewController
        webviewVC.strTitle = "Community Rules"
//        webviewVC.strURL = Config.communityRulesURL
        webviewVC.strURL = Config.baseURL + ApiEndpoints.communityRulesURL
        self.navigationController?.pushViewController(webviewVC, animated: true)
    }
    
    @IBAction func privacyBtnTapped(_ sender: UIButton) {
        let webviewVC = kHomeStoryboard.instantiateViewController(withIdentifier: WebViewController.className) as! WebViewController
        webviewVC.strTitle = "Privacy & Security"
//        webviewVC.strURL = Config.privacySecurityURL
        webviewVC.strURL = Config.baseURL + ApiEndpoints.privacySecurityURL
        self.navigationController?.pushViewController(webviewVC, animated: true)
    }
    
    @IBAction func helpSupportBtnTapped(_ sender: UIButton) {
        let webviewVC = kHomeStoryboard.instantiateViewController(withIdentifier: WebViewController.className) as! WebViewController
        webviewVC.strTitle = "Help & Support & FAQs"
//        webviewVC.strURL = Config.helpSupportFAQsURL
        webviewVC.strURL = Config.baseURL + ApiEndpoints.helpSupportFAQsURL
        self.navigationController?.pushViewController(webviewVC, animated: true)
    }
    
    @IBAction func myEventsBtnTapped(_ sender: UIButton) {
        let myEventVC = kHomeStoryboard.instantiateViewController(withIdentifier: MyEventsVC.className) as! MyEventsVC
        self.navigationController?.pushViewController(myEventVC, animated: true)
    }
    
    @IBAction func blockListBtnTapped(_ sender: UIButton) {
        let blockListVC = kHomeStoryboard.instantiateViewController(withIdentifier: BlockListVC.className) as! BlockListVC
        self.navigationController?.pushViewController(blockListVC, animated: true)
    }
    
    @IBAction func deleteAccountBtnTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "All of your data including Chat, Friends, Events will be deleted permanently. \nDo you want to proceed further?" , preferredStyle: .alert)

        let okAction = UIAlertAction(title: "No", style: .cancel)
        let cancelAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.settingsViewModel.deleteAccount(params: [:])
        }

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func clearSavedVisibilityValues() {
        UserDefaultUtility.shared.saveProfileImageVisibility(visibleTo: "")
        UserDefaultUtility.shared.saveDatingVisibility(visibleTo: "")
        UserDefaultUtility.shared.saveIdentityVisibility(visibleTo: "")
        UserDefaultUtility.shared.saveHometownVisibility(visibleTo: "")
        UserDefaultUtility.shared.saveBirthdayVisibility(visibleTo: "")
    }
}
