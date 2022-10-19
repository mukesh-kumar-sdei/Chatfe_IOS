//
//  CreatePrivateRoomVC.swift
//  Chatfe
//
//  Created by Piyush Mohan on 10/05/22.
//

import UIKit
import TagListView

protocol CategorySelectDelegate: AnyObject {
    func didSelect(selectedCat: CategoriesData)
}

protocol TimeSelectDelegate: AnyObject {
    func didSelectTime(time: String)
}

protocol PrivateRoomDelegate {
    func passToImagePickerController()
    func uploadImage(files: UIImage)
}

protocol CreatePrivateRoomDelegate {
    func didCreateRoom()
}

class CreatePrivateRoomVC: BaseViewController {
    
    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var privateRoomTableView: UITableView!
    
    lazy var createPrivateRoomViewModel: CreatePublicRoomViewModel = {
        let obj = CreatePublicRoomViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        return imagePicker
    }()
    
    var categoriesArr: [CategoriesData] = []
    var selectedCategory: CategoriesData!
    var selectedTime = ""
//    var invitedFriendsArr = [SaveFriendsModel]()
    var invitedFriendsDict = [Int: SaveFriendsModel]()
    let datePicker = UIDatePicker()
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()
        
        privateRoomTableView.delegate = self
        privateRoomTableView.dataSource = self
//        keyboardHandler()
        registerCell()
        resetDefaults()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    // MARK: - ==== CUSTOM METHODs ====
    func keyboardHandler() {
//        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -200 // Move 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move the view to its original position
    }
    
    func registerCell() {
        privateRoomTableView.register(UINib(nibName: RoomClassTableViewCell.className, bundle: nil), forCellReuseIdentifier: RoomClassTableViewCell.className)
        privateRoomTableView.register(UINib(nibName: CategoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.identifier)
        privateRoomTableView.register(UINib(nibName: RoomNameTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RoomNameTableViewCell.identifier)
        privateRoomTableView.register(UINib(nibName: InviteFriendsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InviteFriendsTableViewCell.identifier)
//        privateRoomTableView.register(UINib(nibName: DateTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DateTableViewCell.identifier)
        privateRoomTableView.register(UINib(nibName: SelectDateTVC.className, bundle: nil), forCellReuseIdentifier: SelectDateTVC.className)
        privateRoomTableView.register(UINib(nibName: StartTimeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: StartTimeTableViewCell.identifier)
        privateRoomTableView.register(UINib(nibName: DurationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DurationTableViewCell.identifier)
        privateRoomTableView.register(UINib(nibName: ThumbnailTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ThumbnailTableViewCell.identifier)
    }
    
    func resetDefaults() {
//        UserDefaultUtility.shared.saveCategoryId(id: "")
        UserDefaultUtility.shared.saveCategoryIdName(id: "", name: "")
        UserDefaultUtility.shared.saveStartTime(time: "")
        UserDefaultUtility.shared.saveDuration(duration: 0.0)
        UserDefaultUtility.shared.saveRoomName(name: "")
        UserDefaultUtility.shared.saveDate(date: "")
//        UserDefaultUtility.shared.saveRoomAbout(about: "")
        UserDefaultUtility.shared.saveAbout(about: "")
    }
    
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}


// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension CreatePrivateRoomVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return 7
        return 8
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: RoomClassTableViewCell.className, for: indexPath) as! RoomClassTableViewCell
            return cell
//        case 0:
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as? CategoryTableViewCell else {
                return UITableViewCell()
            }
//            debugPrint("The no of Cats \(categoriesArr.count)")
            cell.delegate = self
            
            // Remove first element or ALL category
            if let allIndex = categoriesArr.firstIndex(where: {$0.title == "All"}) {
                self.categoriesArr.remove(at: allIndex)
            }
            cell.categories = categoriesArr
            return cell
//        case 1:
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoomNameTableViewCell.identifier) as? RoomNameTableViewCell else {
                return UITableViewCell()
            }
            // FOR IMDB API
            cell.isPrivateRoom = true
            cell.viewModel = self.createPrivateRoomViewModel
            cell.setupClosure()
            
            return cell
//        case 2:
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InviteFriendsTableViewCell.identifier) as? InviteFriendsTableViewCell else {
                return UITableViewCell()
            }
            
            cell.btnInvite.tag = indexPath.row
            cell.btnInvite.addTarget(self, action: #selector(inviteBtnTapped(_:)), for: .touchUpInside)
            cell.friendsTagView.delegate = self
            /*8if invitedFriendsArr.count > 0 {
                let fullname = invitedFriendsArr.compactMap({$0.fullname})
                cell.setupTagUI(titles: fullname)
            }*/
            
            return cell
//        case 3:
        case 4:
            /*guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.identifier) as? DateTableViewCell else {
                return UITableViewCell()
            }*/
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectDateTVC.className) as! SelectDateTVC
            cell.parentVC = self
            return cell
//        case 4:
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StartTimeTableViewCell.identifier) as? StartTimeTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
//        case 5:
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DurationTableViewCell.identifier) as? DurationTableViewCell else {
                return UITableViewCell()
            }
            return cell
//        case 6:
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ThumbnailTableViewCell.identifier) as? ThumbnailTableViewCell else {
                return UITableViewCell()
            }
            cell.parentVC = self
            cell.viewModel = createPrivateRoomViewModel
            cell.createPrivateRoomDelegate = self
            cell.roomType = "Private"
            cell.setupClosure()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
//        case 0:
        case 1:
            return 120
//        case 1:
        case 2:
            return 120
//        case 2:
        case 3:
            /// Title with Invite Button + dynamic friends tags + email textfield
            return 135 + CGFloat(self.invitedFriendsDict.count * 50) + 70
//        case 3:
        case 4:
            return UITableView.automaticDimension
//        case 4:
        case 5:
//            return 200
            return 140
//        case 5:
        case 6:
            return 300
//        case 6:
        case 7:
            return 400
        default:
            return UITableView.automaticDimension
        }
    }
    
    
    @objc func inviteBtnTapped(_ sender: UIButton) {
        // OPEN NEW SCREEN OF ALL FRIENDS
        let friendsListVC = kHomeStoryboard.instantiateViewController(withIdentifier: InviteFriendsListVC.className) as! InviteFriendsListVC
        friendsListVC.isFromMessages = false
        friendsListVC.inviteDelegate = self
        self.navigationController?.pushViewController(friendsListVC, animated: true)
    }
    
}

extension CreatePrivateRoomVC: CategorySelectDelegate {
    
    func didSelect(selectedCat: CategoriesData) {
        self.selectedCategory = selectedCat
//        debugPrint("Sel \(selectedCategory.title)")
        if let id = self.selectedCategory._id, let title = selectedCategory.title {
//            UserDefaultUtility.shared.saveCategoryId(id: id)
            UserDefaultUtility.shared.saveCategoryIdName(id: id, name: title)
        }
    }
}

extension CreatePrivateRoomVC: TimeSelectDelegate {
    
    func didSelectTime(time: String) {
        self.selectedTime = time
//        debugPrint("Sel Time is \(selectedTime)")
        UserDefaultUtility.shared.saveStartTime(time: selectedTime)
    }
}

extension CreatePrivateRoomVC: TagListViewDelegate {
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if let names = UserDefaultUtility.shared.getInviteFriendNames(), names.count > 0 {
            for name in names {
                if title == name {
                    let indexPath = IndexPath(row: 0, section: 3)
                    if let cell = self.privateRoomTableView.cellForRow(at: indexPath) as? InviteFriendsTableViewCell {
                        cell.friendsTagView.removeTag(title)
                        let searchedDict = self.invitedFriendsDict.filter({$0.1.fullname == title})
                        if let matchedKey = searchedDict.first?.key {
                            self.invitedFriendsDict.removeValue(forKey: matchedKey)
                            self.privateRoomTableView.reloadData()
                            /// REMOVED OLD SAVE IDs & Names
                            UserDefaultUtility.shared.removeInvitedFriendsIDs()
                            UserDefaultUtility.shared.removeInvitedFriendNames()
                            
                            let idsArr = self.invitedFriendsDict.values.compactMap({$0.id})
                            let namesArr = self.invitedFriendsDict.values.compactMap({$0.fullname})
                            /// SAVE NEW IDs & Names
                            UserDefaultUtility.shared.saveInviteFriendsIDs(idsArr)
                            UserDefaultUtility.shared.saveInviteFriendNames(names: namesArr)
                        }
                    }
                }
            }
        }
    }
}

extension CreatePrivateRoomVC: InviteFriendsDelegate {
    
    func invitedFriendsDict(dict: [Int : SaveFriendsModel]) {
        self.invitedFriendsDict = dict
        var fullnameArr = [String]()
        var idArr = [String]()
        
        /// DISPLAY TAG IN CELL
        let indexPath = IndexPath(row: 0, section: 3)
        if dict.count > 0 {
            if let cell = self.privateRoomTableView.cellForRow(at: indexPath) as? InviteFriendsTableViewCell {
                fullnameArr = dict.values.compactMap({$0.fullname})
                idArr = dict.values.compactMap({$0.id})
                cell.setupTagUI(titles: fullnameArr)
            }
            
            /// SAVE IDs & Names
            UserDefaultUtility.shared.saveInviteFriendsIDs(idArr)
            UserDefaultUtility.shared.saveInviteFriendNames(names: fullnameArr)
            
            /// RELOAD TABLEVIEW
            self.privateRoomTableView.reloadData()
        }
    }
}

extension CreatePrivateRoomVC: PrivateRoomDelegate {
    
    func passToImagePickerController() {
        debugPrint("Delegated")
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have permission to access gallery", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    func uploadImage(files: UIImage) {
        debugPrint("The file to be uploaded is \(files)")
        let params: [String: Any] = [:]
        let imageData = files.jpegData(compressionQuality: 0.8)! as NSData
        let file = File(name: "", fileName: "", data: imageData as Data)
        self.createPrivateRoomViewModel.uploadImage(params: params, files:[file])
    }
    
    
}

// MARK: ImagePickerDelegate

extension CreatePrivateRoomVC: ImagePickerDelegate {
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        
        //profileImage.image = image
        imagePicker.dismiss()
    }
    func cancelButtonDidClick(on imageView: ImagePicker) {
        imagePicker.dismiss()
    }
    
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool, to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else {
            return
        }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}

extension CreatePrivateRoomVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        _ = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
       // profileImage.image = tempImage
        self.dismiss(animated: true, completion: nil)
        //self.takePictureBtn.setTitle("Proceed", for: .normal)
        
//        if let imageURL = (info[UIImagePickerController.InfoKey.imageURL]) {
//            UserDefaultUtility.shared.saveProfileImageURL(url: imageURL as! NSURL)
//        }
       
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreatePrivateRoomVC: CreatePrivateRoomDelegate {
    
    func didCreateRoom() {
        DispatchQueue.main.async {
            self.navigateToHomeScreen()
        }
    }
    
    
}
