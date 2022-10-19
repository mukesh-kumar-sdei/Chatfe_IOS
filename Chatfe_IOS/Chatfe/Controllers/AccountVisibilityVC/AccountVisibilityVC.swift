//
//  AccountVisibilityVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 28/07/22.
//

import UIKit

class AccountVisibilityVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var optionsTableView: UITableView!
    
    lazy var viewModel: AccountVisibilityVM = {
        let obj = AccountVisibilityVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    private var visibilityData: VisibilityData?
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        optionsTableView.dataSource = self
        optionsTableView.delegate = self
//        optionsTableView.rowHeight = UITableView.automaticDimension
        registerNIBs()
        self.viewModel.getVisibilityData()
        setupClosures()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func registerNIBs() {
        optionsTableView.register(UINib(nibName: AccountVisibilityCell.className, bundle: nil), forCellReuseIdentifier: AccountVisibilityCell.className)
        optionsTableView.register(UINib(nibName: SubmitButtonCell.className, bundle: nil), forCellReuseIdentifier: SubmitButtonCell.className)
    }
    
    func setupClosures() {
        /// GET DATA RESPONSE
        viewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.visibilityData = self.viewModel.getVisibilityResp?.data
                if let profileImgVisibility = self.visibilityData?.profileImg?.privacy {
                    UserDefaultUtility.shared.saveProfileImageVisibility(visibleTo: profileImgVisibility)
                }
                if let datingVisibility = self.visibilityData?.dating?.privacy {
                    UserDefaultUtility.shared.saveDatingVisibility(visibleTo: datingVisibility)
                }
                if let genderVisibility = self.visibilityData?.gender?.privacy {
                    UserDefaultUtility.shared.saveIdentityVisibility(visibleTo: genderVisibility)
                }
                if let hometownVisibility = self.visibilityData?.hometown?.privacy {
                    UserDefaultUtility.shared.saveHometownVisibility(visibleTo: hometownVisibility)
                }
                if let birthdayVisibility = self.visibilityData?.dob?.privacy {
                    UserDefaultUtility.shared.saveBirthdayVisibility(visibleTo: birthdayVisibility)
                }
                
                self.optionsTableView.reloadData()
            }
        }
        
        /// UPDATE DATA RESPONSE
        viewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let message = self.viewModel.updateVisibilityResp?.data {
                    self.showBaseAlert(message)
                }
            }
        }
    }

    // MARK: - ==== IBACTIONs ====
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension AccountVisibilityVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountVisibilityCell.className) as! AccountVisibilityCell
        switch indexPath.row {
        case 0: // Profile Picture
            cell.lblTitle.text = "Profile Picture"
            let datingV = UserDefaultUtility.shared.getProfileImageVisibility()
            if datingV == "All" {
                cell.btnAll.setImage(Images.radioButtonFilled, for: .normal)
                cell.btnFriends.setImage(Images.radioButtonEmpty, for: .normal)
            } else if datingV == "Friends" {
                cell.btnAll.setImage(Images.radioButtonEmpty, for: .normal)
                cell.btnFriends.setImage(Images.radioButtonFilled, for: .normal)
            }
        case 1: // Are you interested in dating?
            cell.lblTitle.text = "Are you interested in dating?"
            let datingV = UserDefaultUtility.shared.getDatingVisibility()
            if datingV == "All" {
                cell.btnAll.setImage(Images.radioButtonFilled, for: .normal)
                cell.btnFriends.setImage(Images.radioButtonEmpty, for: .normal)
            } else if datingV == "Friends" {
                cell.btnAll.setImage(Images.radioButtonEmpty, for: .normal)
                cell.btnFriends.setImage(Images.radioButtonFilled, for: .normal)
            }
        case 2: // I identify as...
            cell.lblTitle.text = "I identify as..."
            let datingV = UserDefaultUtility.shared.getIdentityVisiblity()
            if datingV == "All" {
                cell.btnAll.setImage(Images.radioButtonFilled, for: .normal)
                cell.btnFriends.setImage(Images.radioButtonEmpty, for: .normal)
            } else if datingV == "Friends" {
                cell.btnAll.setImage(Images.radioButtonEmpty, for: .normal)
                cell.btnFriends.setImage(Images.radioButtonFilled, for: .normal)
            }
        case 3: // Hometown
            cell.lblTitle.text = "Hometown"
            let datingV = UserDefaultUtility.shared.getHometownVisibility()
            if datingV == "All" {
                cell.btnAll.setImage(Images.radioButtonFilled, for: .normal)
                cell.btnFriends.setImage(Images.radioButtonEmpty, for: .normal)
            } else if datingV == "Friends" {
                cell.btnAll.setImage(Images.radioButtonEmpty, for: .normal)
                cell.btnFriends.setImage(Images.radioButtonFilled, for: .normal)
            }
        case 4: // Age
            cell.lblTitle.text = "Age"
            let datingV = UserDefaultUtility.shared.getBirthdayVisibility()
            if datingV == "All" {
                cell.btnAll.setImage(Images.radioButtonFilled, for: .normal)
                cell.btnFriends.setImage(Images.radioButtonEmpty, for: .normal)
            } else if datingV == "Friends" {
                cell.btnAll.setImage(Images.radioButtonEmpty, for: .normal)
                cell.btnFriends.setImage(Images.radioButtonFilled, for: .normal)
            }
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubmitButtonCell.className) as! SubmitButtonCell
            
            cell.btnSubmit.tag = indexPath.row
            cell.btnSubmit.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
            
            return cell
        default:
            break
        }
        
        cell.btnAll.tag = indexPath.row
        cell.btnAll.addTarget(self, action: #selector(btnAllTapped(_:)), for: .touchUpInside)
        cell.btnAllText.tag = indexPath.row
        cell.btnAllText.addTarget(self, action: #selector(btnAllTapped(_:)), for: .touchUpInside)
        
        cell.btnFriends.tag = indexPath.row
        cell.btnFriends.addTarget(self, action: #selector(btnFriendsTapped(_:)), for: .touchUpInside)
        cell.btnFriendsText.tag = indexPath.row
        cell.btnFriendsText.addTarget(self, action: #selector(btnFriendsTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        if indexPath.row == 5 {
            return 80.0
        } else {
            return 125.0
        }
    }

    @objc func btnAllTapped(_ sender: UIButton) {
        
        self.setAllRadioButtonFilled(row: sender.tag)
        
        switch sender.tag {
        case 0: // Profile Picture
            UserDefaultUtility.shared.saveProfileImageVisibility(visibleTo: "All")
        case 1: // Dating
            UserDefaultUtility.shared.saveDatingVisibility(visibleTo: "All")
        case 2: // Identity
            UserDefaultUtility.shared.saveIdentityVisibility(visibleTo: "All")
        case 3: // Hometown
            UserDefaultUtility.shared.saveHometownVisibility(visibleTo: "All")
        case 4: // Age
            UserDefaultUtility.shared.saveBirthdayVisibility(visibleTo: "All")
        default:
            break
        }
    }
    
    func setAllRadioButtonFilled(row: Int) {
        if let cell = self.optionsTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AccountVisibilityCell {
            cell.btnAll.setImage(Images.radioButtonFilled, for: .normal)
            cell.btnFriends.setImage(Images.radioButtonEmpty, for: .normal)
        }
    }
    
    func setFriendsRadioButtonEmpty(row: Int) {
        if let cell = self.optionsTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AccountVisibilityCell {
            cell.btnAll.setImage(Images.radioButtonEmpty, for: .normal)
            cell.btnFriends.setImage(Images.radioButtonFilled, for: .normal)
        }
    }
    
    @objc func btnFriendsTapped(_ sender: UIButton) {
        self.setFriendsRadioButtonEmpty(row: sender.tag)
        switch sender.tag {
        case 0: // Profile Picture
            UserDefaultUtility.shared.saveProfileImageVisibility(visibleTo: "Friends")
        case 1: // Dating
            UserDefaultUtility.shared.saveDatingVisibility(visibleTo: "Friends")
        case 2: // Identity
            UserDefaultUtility.shared.saveIdentityVisibility(visibleTo: "Friends")
        case 3: // Hometown
            UserDefaultUtility.shared.saveHometownVisibility(visibleTo: "Friends")
        case 4: // Age
            UserDefaultUtility.shared.saveBirthdayVisibility(visibleTo: "Friends")
        default:
            break
        }
    }
    
    @objc func submitButtonTapped() {
        // HIT UPDATE API
        let params = ["dating"      : ["privacy": UserDefaultUtility.shared.getDatingVisibility()],
                      "dob"         : ["privacy": UserDefaultUtility.shared.getBirthdayVisibility()],
                      "gender"      : ["privacy": UserDefaultUtility.shared.getIdentityVisiblity()],
                      "hometown"    : ["privacy": UserDefaultUtility.shared.getHometownVisibility()],
                      "profileImg"  : ["privacy": UserDefaultUtility.shared.getProfileImageVisibility()]
                    ]
        self.viewModel.updateVisibilityData(params: params)
    }
    
}
