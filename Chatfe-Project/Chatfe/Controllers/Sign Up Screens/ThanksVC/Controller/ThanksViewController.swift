//
//  ThanksViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class ThanksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func finishButtonTapped(_ sender: UIButton) {

        // Navigate to SignInViewController
        if let destinationViewController = self.navigationController?.viewControllers
            .filter({$0 is SignInViewController})
            .first {
            self.navigationController?.popToViewController(destinationViewController, animated: false)
        }
    }

}
