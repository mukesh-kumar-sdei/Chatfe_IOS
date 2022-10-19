//
//  VoteToRemoveVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 02/08/22.
//

import UIKit

struct SelectedVote {
    static var isRacist: Bool?
    static var isHarassing: Bool?
    static var channelData: ChannelIdData?
    static var messageIDs = [String]()
    static var member: MemberData?
    static var memberList = [MembersColorNMatch]()
}

class VoteToRemoveVC: UIViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var btnQ1Yes: UIButton!
    @IBOutlet weak var imgQ1Yes: UIImageView!
    @IBOutlet weak var btnQ1No: UIButton!
    @IBOutlet weak var imgQ1No: UIImageView!
    
    @IBOutlet weak var btnQ2Yes: UIButton!
    @IBOutlet weak var imgQ2Yes: UIImageView!
    @IBOutlet weak var btnQ2No: UIButton!
    @IBOutlet weak var imgQ2No: UIImageView!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    var viewedUserID = ""
    var q1Clicked = false
    var q2Clicked = false
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        imgQ1Yes.image = Images.radioButtonEmpty
        imgQ1No.image = Images.radioButtonEmpty
        imgQ2Yes.image = Images.radioButtonEmpty
        imgQ2No.image = Images.radioButtonEmpty
        enableButtonInteraction(enabled: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func enableButtonInteraction(enabled: Bool) {
        if enabled {
            btnContinue.alpha = 1.0
        } else {
            btnContinue.alpha = 0.5
        }
        btnContinue.isUserInteractionEnabled = enabled
    }
    
    func updateRadioButton(img: UIImageView, img2: UIImageView) {
        // UPDATE RADIO BUTTON UI ONLY
        switch img.image {
        case Images.radioButtonEmpty:
            img.image = Images.radioButtonFilled
            img2.image = Images.radioButtonEmpty
        case Images.radioButtonFilled:
            img.image = Images.radioButtonEmpty
            img2.image = Images.radioButtonFilled
        default:
            SelectedVote.isRacist = nil
            SelectedVote.isHarassing = nil
        }
        
        // UPDATE SELECTION VALUE BASED ON Q1 AND Q2
        if img == self.imgQ1Yes || img == imgQ1No {
            SelectedVote.isRacist = img == self.imgQ1Yes ? true : false
        } else if img == self.imgQ2Yes || img == imgQ2No {
            SelectedVote.isHarassing = img == self.imgQ2Yes ? true : false
        }
        
        // ENABLE / DISABLE CONTINUE BUTTON BASED ON ANSWER SELECTION
        print("SelectedVote.isRacist: ",SelectedVote.isRacist)
        print("SelectedVote.isHarassing: ",SelectedVote.isHarassing)
//        if (SelectedVote.isRacist != nil) && (SelectedVote.isHarassing != nil) {
//            enableButtonInteraction(enabled: true)
//        }else {
//            enableButtonInteraction(enabled: false)
//        }
    }
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnQ1Clicked(_ sender: UIButton) {
        if sender.tag == 10 {
            updateRadioButton(img: self.imgQ1Yes, img2: self.imgQ1No)
        } else if sender.tag == 11 {
            updateRadioButton(img: self.imgQ1No, img2: self.imgQ1Yes)
        }
        q1Clicked = true
        if q2Clicked && q1Clicked {
            enableButtonInteraction(enabled: true)
        }
    }
    
    @IBAction func btnQ2Clicked(_ sender: UIButton) {
        if sender.tag == 12 {
            updateRadioButton(img: self.imgQ2Yes, img2: self.imgQ2No)
        } else if sender.tag == 13 {
            updateRadioButton(img: self.imgQ2No, img2: self.imgQ2Yes)
        }
        q2Clicked = true
        if q2Clicked && q1Clicked {
            enableButtonInteraction(enabled: true)
        }
    }
    
    @IBAction func continueBtnClicked(_ sender: UIButton) {
        let selectChatVC = kChatStoryboard.instantiateViewController(withIdentifier: SelectChatsVC.className) as! SelectChatsVC
        selectChatVC.viewedUserID = viewedUserID
        self.navigationController?.pushViewController(selectChatVC, animated: true)
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
}

