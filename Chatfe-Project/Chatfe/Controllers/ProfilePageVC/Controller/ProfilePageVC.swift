//
//  ProfilePageVC.swift
//  Chatfe
//
//  Created by Piyush Mohan on 18/05/22.
//

import UIKit

class ProfilePageVC: BaseViewController {

    @IBOutlet weak var settingsImage: UIImageView!
    @IBOutlet weak var settingsBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        self.settingsImage.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func settingsBtnTapped(_ sender: UIButton) {
        debugPrint("Settings Tapped!")
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func tapImage() {
        debugPrint("Tapped Image")
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    

}
