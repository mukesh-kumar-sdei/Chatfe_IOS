//
//  KickedPopupVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 25/08/22.
//

import UIKit

protocol KickedOutDelegate {
    func dismissFromGroup(result: Bool)
}

class KickedPopupVC: BaseViewController {

    public var delegate: KickedOutDelegate?
    
    // MARK: ==== IBOUTLETs ====
    @IBOutlet weak var customPopup: UIView!
    @IBOutlet weak var lblPopupTitle: UILabel!
    @IBOutlet weak var lblPopupMessage: UILabel!
    @IBOutlet weak var btnPopupDispute: UIButton!
    @IBOutlet weak var btnPopupOkay: UIButton!
    
    lazy var viewModel: ProfilePreviewVM = {
        let obj = ProfilePreviewVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var isKickedOut = false
    var titleMessage = ""
    var roomName = ""
    
    
    // MARK: ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblPopupTitle.text = self.titleMessage
        self.lblPopupMessage.text = "*Disputes will take some time to review. However, if you are found not in violation, the reporting party will be given a warning."
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: ==== IBACTIONs ====
    @IBAction func btnDisputeClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnOkayClicked(_ sender: UIButton) {
        self.delegate?.dismissFromGroup(result: true)
        self.dismiss(animated: false)
    }

    
}
