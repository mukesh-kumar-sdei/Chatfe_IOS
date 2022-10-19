//
//  ChooseRoomTypeViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 04/05/22.
//

import UIKit

class ChooseRoomTypeViewController: UIViewController {
    
    var delegate: HomePageDelegate?

    @IBOutlet weak var chooseRoomView: ChooseRoomTypeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }
    
    
    @IBAction func dismissBtnTapped(_ sender: UIButton) {
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func publicRoomBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate?.passToNextVC(sender: sender)

//        let nextVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: CreatePublicRoomViewController.className) as! CreatePublicRoomViewController
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func privateRoomBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate?.passToNextVC(sender: sender)
//        let nextVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: CreatePrivateRoomViewController.className) as! CreatePrivateRoomViewController
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}
