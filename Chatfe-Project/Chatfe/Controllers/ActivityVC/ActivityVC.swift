//
//  ActivityVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 07/08/22.
//

import UIKit

class ActivityVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var birthdaySwitch: UISwitch!
    @IBOutlet weak var invitesSwitch: UISwitch!
    @IBOutlet weak var upcomingRoomsSwitch: UISwitch!
    @IBOutlet weak var friendsPublicRoomsSwitch: UISwitch!
    
    lazy var viewModel: ActivityVM = {
        let obj = ActivityVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var getActivityData: ActivityData?
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hitGetActivityAPI()
        setupClosures()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func hitGetActivityAPI() {
        self.viewModel.getActivityData()
    }
    
    func hitUpdateActivityAPI(result: [String: Bool]) {
//        var params = getActivityData?.activity
        var params = [String: Bool]()
        params = ["birthday"            : getActivityData?.activity?.birthday ?? false,
                  "invites"             : getActivityData?.activity?.invites ?? false,
                  "upcomingRooms"       : getActivityData?.activity?.upcomingRooms ?? false,
                  "friendsPublicRoom"   : getActivityData?.activity?.friendsPublicRoom ?? false
        ]
        
        if let value = result.first?.value, let key = result.first?.key {
//            params.updateValue(value, forKey: key)
            params[key] = value
        }
        self.viewModel.updateActivityData(params: params)
    }
    
    func updateUI() {
        self.birthdaySwitch.isOn = false
        self.invitesSwitch.isOn = false
        self.upcomingRoomsSwitch.isOn = false
        self.friendsPublicRoomsSwitch.isOn = false
    }
    
    func setupClosures() {
        /// GET ACTIVITY API RESPONSE
        viewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.getActivityData = self.viewModel.getActivityResp?.data
                print("birthday:",self.getActivityData?.activity?.birthday)
                self.birthdaySwitch.isOn = self.getActivityData?.activity?.birthday ?? false ? true:false
                self.invitesSwitch.isOn = self.getActivityData?.activity?.invites ?? false ? true:false
                self.upcomingRoomsSwitch.isOn = self.getActivityData?.activity?.upcomingRooms ?? false ? true:false
                self.friendsPublicRoomsSwitch.isOn = self.getActivityData?.activity?.friendsPublicRoom ?? false ? true:false
            }
        }
        
        /// UPDATE ACTIVITY API RESPONSE
        viewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                // UPDATE DATA
            }
        }
        
    }
    
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func switchBtnClicked(_ sender: UISwitch) {
        print("State:",sender.isOn)
        if sender.tag == 10 {           // BIRTHDAY
            self.hitUpdateActivityAPI(result: ["birthday": sender.isOn])
        } else if sender.tag == 11 {    // INVITES
            self.hitUpdateActivityAPI(result: ["invites": sender.isOn])
        } else if sender.tag == 12 {    // UPCOMING ROOMS
            self.hitUpdateActivityAPI(result: ["upcomingRooms": sender.isOn])
        } else if sender.tag == 13 {    // FRIEND'S PUBLIC ROOMS
            self.hitUpdateActivityAPI(result: ["friendsPublicRoom": sender.isOn])
        }
    }

}
