//
//  ProfileVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 28/05/22.
//

import UIKit

protocol EditProfileNameDelegate {
    func setEdit(to: Bool)
    func setName(name: String)
    func setAbout(to: Bool)
    func setDrink(to: Bool)
}

class ProfileVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var profileTableView: UITableView!
    
    lazy var profilePageViewModel: ProfilePageViewModel = {
        let obj = ProfilePageViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    // MARK: - ==== VARIABLEs ====
    var profileDetails: ProfileData? {
        didSet {
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
                print("Profile name:",self.profileDetails?.lname ?? "")
            }
        }
    }
    var isupdate = false
    var indexPath: IndexPath?
    var tagIcon = ""
    var imageURL = ""
    var drinksArr: [FavouriteDrink] = []
    
    var editName = false {
        didSet {
            self.profileTableView.reloadData()
            print("Profile name**:",self.profileDetails?.lname ?? "")
        }
//        willSet {
//            self.profileTableView.reloadData()
//        }
    }
    
    var editAbout = false {
        didSet {
            self.profileTableView.reloadData()
        }
    }
    
    var updatedName: String? {
        didSet {
            self.profileTableView.reloadData()
        }
    }
    
    var editDrink = false {
        didSet {
            self.profileTableView.reloadData()
        }
    }
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.hideKeyboardWhenTappedAround()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        registerCell()
        if isupdate{
        profilePageViewModel.getProfile(params: [:])
        profilePageViewModel.getDrinks(params: [:])
        }
        setupClosure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isupdate == false{
        profilePageViewModel.getProfile(params: [:])
        profilePageViewModel.getDrinks(params: [:])
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillLayoutSubviews() {
//        self.tabBarItem.image = UIImage(named: "chatfe")
//        tabBarItem.imageInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func registerCell() {
       // profilePageViewModel.getProfile(params: [:])
        profileTableView.register(UINib(nibName: ProfileImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileImageTableViewCell.identifier)
        profileTableView.register(UINib(nibName: ProfileNameTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileNameTableViewCell.identifier)
        profileTableView.register(UINib(nibName: DrinkTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DrinkTableViewCell.identifier)
        profileTableView.register(UINib(nibName: FriendsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FriendsTableViewCell.identifier)
        profileTableView.register(UINib(nibName: AboutSectionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AboutSectionTableViewCell.identifier)
        profileTableView.register(UINib(nibName: EditProfileImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: EditProfileImageTableViewCell.identifier)
        profileTableView.register(UINib(nibName: EditDrinkTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: EditDrinkTableViewCell.identifier)
        profileTableView.register(UINib(nibName: EditAboutSectionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: EditAboutSectionTableViewCell.identifier)
    }
    
    func setupClosure() {
        profilePageViewModel.reloadListViewClosure = { [weak self] in
            if self?.profilePageViewModel.profileResponse?.status == APIKeys.success {
                DispatchQueue.main.async {
                    if let response = self?.profilePageViewModel.profileResponse?.data {
                        self?.profileDetails = response
    //                    debugPrint("The Profile Details are ", self?.profileDetails)
                    }
                    UserDefaultUtility.shared.saveProfileImageURL(strURL: self?.profileDetails?.profileImg?.image ?? "")
                    UserDefaultUtility.shared.saveSelectedDrink(id: self?.profileDetails?.drink?._id ?? "")
                    UserDefaultUtility.shared.saveDatingInterest(reply: self?.profileDetails?.dating?.datings ?? "NA")
                    UserDefaultUtility.shared.saveIdentity(identity: self?.profileDetails?.gender?.gen ?? "NA")
                    UserDefaultUtility.shared.saveHometown(city: self?.profileDetails?.hometown?.homeTown ?? "NA")
                    self?.profileTableView.reloadData()
                    if let tabBarCtrl = self?.tabBarController as? MainTabBarController {
                        if let strImage = UserDefaultUtility.shared.getProfileImageURL(), strImage != "" {
                            tabBarCtrl.addSubviewToLastTabItem(strImage, isSelected: true)
                        }
                    }
                }
//            } else if self?.profilePageViewModel.profileErrorResponse?.status == APIKeys.error {
            } else if self?.profilePageViewModel.profileResponse?.status == APIKeys.error {
                DispatchQueue.main.async {
                    UIAlertController.showAlert((self?.profilePageViewModel.profileResponse?.status, self?.profilePageViewModel.profileResponse?.message), sender: self, actions: AlertAction.Okk) { action in
//                        self?.navigationController?.popToViewController(SignInViewController(), animated: true)
                    }
                }
            }
            if self?.profilePageViewModel.favouriteDrinkResponse?.status == APIKeys.success {
                if let arr = self?.profilePageViewModel.favouriteDrinkResponse?.data {
                    self?.drinksArr = arr
//                    debugPrint("The Drinks are ", self?.drinksArr)
                }
            }
        }
    }
    

    // MARK: - ==== IBACTIONs ====
    @IBAction func settingsButtonClicked(_ sender: UIButton) {
        let nextVC = kHomeViewStoryboard.instantiateViewController(withIdentifier: SettingsViewController.className) as! SettingsViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}


// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileImageTableViewCell.identifier) as! EditProfileImageTableViewCell
            cell.imageUrl = self.profileDetails?.profileImg?.image ?? ""
            
            cell.parentVC = self
            cell.editNameTextField.text = "\(self.profileDetails?.fname ?? "") \(self.profileDetails?.lname ?? "")"
            cell.lblUsername.text =  UserDefaultUtility.shared.getLoginType() == Constants.AppName ? self.profileDetails?.username : ""
            cell.editAboutTextField.text = self.profileDetails?.aboutYourself
            cell.aboutTextView.text = self.profileDetails?.aboutYourself
            
            cell.setupProfileImage()
            if isupdate == false{
            cell.editNameDelegate = self
            cell.setupClosure()
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: EditDrinkTableViewCell.identifier) as! EditDrinkTableViewCell
            self.indexPath = indexPath
            cell.parentVC = self
            cell.drinkArr = drinksArr
            cell.showDrinkImage(image: self.profileDetails?.drink?.image)
            cell.drinkLabel.text = self.profileDetails?.drink?.drinkName ?? "NA"
            cell.editDrinkDelegate = self
            cell.initialSetup()
            cell.setupClosure()
            cell.selectedIndexPath = indexPath
            cell.selectedDrinkId = self.profileDetails?.drink?._id ?? ""
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier) as! FriendsTableViewCell
            cell.friendsArr = self.profileDetails?.friendsArr
            cell.parentVC = self
            if self.profileDetails?.friendsArr?.count == 0 {
                cell.btnViewAll.isUserInteractionEnabled = false
            } else {
                cell.btnViewAll.isUserInteractionEnabled = true
                cell.btnViewAll.tag = indexPath.row
                cell.btnViewAll.addTarget(self, action: #selector(viewAllButtonTapped(_:)), for: .touchUpInside)
            }
            
            return cell
        case 4:
            if editAbout == false {
                let cell = tableView.dequeueReusableCell(withIdentifier: AboutSectionTableViewCell.identifier) as! AboutSectionTableViewCell
                cell.editAboutDelegate = self
//                cell.datingLbl.text = self.profileDetails?.dating?.datings ?? "NA"
                cell.datingLbl.text = self.profileDetails?.dating?.datings != "" ? self.profileDetails?.dating?.datings : "NA"
                
//                cell.identityLbl.text = self.profileDetails?.gender?.gen ?? "NA"
                cell.identityLbl.text = self.profileDetails?.gender?.gen != "" ? self.profileDetails?.gender?.gen : "NA"
                
//                cell.hometownLbl.text = self.profileDetails?.hometown?.homeTown ?? "NA"
                cell.hometownLbl.text = self.profileDetails?.hometown?.homeTown != "" ? self.profileDetails?.hometown?.homeTown : "NA"
                
                if let birthDate = self.profileDetails?.dob?.birthdate {
                    cell.calculateAge(age: birthDate)
                } else {
                    cell.ageLbl.text = "NA"
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: EditAboutSectionTableViewCell.identifier) as! EditAboutSectionTableViewCell
                switch self.profileDetails?.dating?.datings {
//                case "Yes":
                case Constants.Yes:
                    cell.yesBtn.setImage(Images.radioButtonFilled, for: .normal)
                    cell.noBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.otherBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    
//                case "No":
                case Constants.No:
                    cell.yesBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.noBtn.setImage(Images.radioButtonFilled, for: .normal)
                    cell.otherBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    
//                case "Other":
                case Constants.other:
                    cell.yesBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.noBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.otherBtn.setImage(Images.radioButtonFilled, for: .normal)
                default:
//                    return UITableViewCell()
                    cell.yesBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.noBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.otherBtn.setImage(Images.radioButtonEmpty, for: .normal)
                }
                switch self.profileDetails?.gender?.gen {
//                case "Male":
                case Constants.Male:
                    cell.maleBtn.setImage(Images.radioButtonFilled, for: .normal)
                    cell.femaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderMaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.genderVariantBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.notListedBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.preferNotBtn.setImage(Images.radioButtonEmpty, for: .normal)
//                case "Female":
                case Constants.Female:
                    cell.maleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.femaleBtn.setImage(Images.radioButtonFilled, for: .normal)
                    cell.transgenderFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderMaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.genderVariantBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.notListedBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.preferNotBtn.setImage(Images.radioButtonEmpty, for: .normal)
//                case "Transgender Female":
                case Constants.TransFemale:
                    cell.maleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.femaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderFemaleBtn.setImage(Images.radioButtonFilled, for: .normal)
                    cell.transgenderMaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.genderVariantBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.notListedBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.preferNotBtn.setImage(Images.radioButtonEmpty, for: .normal)
//                case "Transgender Male":
                case Constants.TransMale:
                    cell.maleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.femaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderMaleBtn.setImage(Images.radioButtonFilled, for: .normal)
                    cell.genderVariantBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.notListedBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.preferNotBtn.setImage(Images.radioButtonEmpty, for: .normal)
//                case "Gender Variant":
                case Constants.GenderVariant:
                    cell.maleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.femaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderMaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.genderVariantBtn.setImage(Images.radioButtonFilled, for: .normal)
                    cell.notListedBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.preferNotBtn.setImage(Images.radioButtonEmpty, for: .normal)
//                case "Not Listed":
                case Constants.NotListed:
                    cell.maleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.femaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderMaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.genderVariantBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.notListedBtn.setImage(Images.radioButtonFilled, for: .normal)
                    cell.preferNotBtn.setImage(Images.radioButtonEmpty, for: .normal)
//                case "Prefer Not to Answer":
                case Constants.PreferNotToAnswer:
                    cell.maleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.femaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderMaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.genderVariantBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.notListedBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.preferNotBtn.setImage(Images.radioButtonFilled, for: .normal)
                default:
//                    return UITableViewCell()
                    cell.maleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.femaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderFemaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.transgenderMaleBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.genderVariantBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.notListedBtn.setImage(Images.radioButtonEmpty, for: .normal)
                    cell.preferNotBtn.setImage(Images.radioButtonEmpty, for: .normal)
                }
                cell.hometownTextField.text = self.profileDetails?.hometown?.homeTown ?? "NA"
                if let birthDate = self.profileDetails?.dob?.birthdate {
                    cell.calculateAge(age: birthDate)
                } else {
                    cell.ageTextField.text = "NA"
                }
                cell.parentVC = self
                cell.editAboutDelegate = self
                cell.setupClosure()
                if let birthDate = self.profileDetails?.dob?.birthdate {
                    cell.calculateAge(age: birthDate)
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 150
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
//            return 125
//            return 300
//            return UserDefaultUtility.shared.getLoginType() == Constants.AppName ? 285.0 : 300.0
            return UITableView.automaticDimension
        case 1:
//            return 125
            if editName == false {
                return 0
            } else {
                return 0
            }
        case 2:
//            return 125
//            return 200
            return 180
        case 3:
            return 215
        case 4:
//            return 600
            if editAbout == false {
                return 500
            } else {
                return 850
            }
        default:
            return UITableView.automaticDimension
        }
    }

    
    @objc func viewAllButtonTapped(_ sender: UIButton) {
        let allFriendsVC = kHomeStoryboard.instantiateViewController(withIdentifier: AllFriendsVC.className) as! AllFriendsVC
        allFriendsVC.friendsArr = self.profileDetails?.friendsArr ?? []
        self.navigationController?.pushViewController(allFriendsVC, animated: true)
    }
}


extension ProfileVC: EditProfileNameDelegate {
    func setEdit(to: Bool) {
//        debugPrint("Is Edit \(to)")
        self.isupdate = true
        //self.editName = to
        self.viewDidLoad()
//        self.viewDidAppear(true)
    }
    func setName(name: String) {
        self.updatedName = name
//        self.profileTableView.reloadData()
        self.isupdate = true
        self.viewDidLoad()
//        self.viewDidAppear(true)
    }
    
    func setAbout(to: Bool) {
        self.isupdate = true
        self.editAbout = to
        self.viewDidLoad()
//        debugPrint("About to ")
    }
    
    func setDrink(to: Bool) {
//        debugPrint("Set drink to \(to)")
        self.isupdate = true
        self.editDrink = to
        self.viewDidLoad()
    }
    
}
