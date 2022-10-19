//
//  HomePageTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 29/04/22.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {
    
    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var joinRoomBtn: UIButton!
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var roomNameLbl: UILabel!
    @IBOutlet weak var roomTimingsLbl: UILabel!
    
    @IBOutlet weak var roomClassIcon: UIImageView!
    @IBOutlet weak var lblroomClass: UILabel!
    
    lazy var homePageViewModel: HomePageViewModel = {
        let obj = HomePageViewModel(userService: UserService())
        self.parentVC.baseVwModel = obj
        return obj
    }()

    var roomId = ""
    var hasRoomJoined = false
    var roomDelegate: HomePageDelegate!
    var parentVC: BaseViewController!
    
    
    // MARK: - ==== CELL LIFECYCLE ====
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        roomImageView.contentMode = .scaleAspectFit
//        roomImageView.contentMode = .scaleAspectFill
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func displayText(name: String, time: String, image: String) {
        self.roomNameLbl.text = name
        self.roomTimingsLbl.text = time
        self.roomImageView.image = UIImage(named: image)
    }
    
    func displayJoinedRoom(hasJoined: Bool) {
//        if hasRoomJoined == true {
        if hasJoined {
            self.joinRoomBtn.setImage(Images.circleTick, for: .normal)
        } else {
            self.joinRoomBtn.setImage(Images.circleAdd, for: .normal)
        }
    }
/*
    func setupClosure() {
        homePageViewModel.reloadListViewClosure = { [weak self] in
            if self?.homePageViewModel.joinRoomResponse?.status == "SUCCESS" {
                DispatchQueue.main.async {
                    self?.joinRoomBtn.setImage(Images.circleTick, for: .normal)
                    self?.roomDelegate.didJoinRoom(reply: true)
                }
            }
        }
    }
*/
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func addBtnTapped(_ sender: UIButton) {
        // NOTHING TO DO
    }
    
}
