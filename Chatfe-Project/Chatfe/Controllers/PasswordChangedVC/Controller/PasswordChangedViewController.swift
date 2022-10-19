//
//  PasswordChangedViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class PasswordChangedViewController: BaseViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signInBtnTapped(_ sender: UIButton) {
//        if let nextVC = self.navigationController?.viewControllers[1] {
//            self.navigationController?.popToViewController(nextVC, animated: true)
//        }
        self.navigateToSignInScreen()
    }
    
}
