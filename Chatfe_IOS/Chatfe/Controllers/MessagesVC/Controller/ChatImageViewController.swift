//
//  ChatImageViewController.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 15/07/22.
//

import UIKit

class ChatImageViewController: UIViewController {

    @IBOutlet weak var chatImage: UIImageView!
    
    var strImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageURL = URL(string: strImage) {
            self.chatImage.kf.setImage(with: imageURL)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
