//
//  CreatePublicRoomVC.swift
//  Chatfe
//
//  Created by Piyush Mohan on 11/05/22.
//

import UIKit

protocol PublicRoomDelegate {
    func passToImagePickerController()
    func uploadImage(files: UIImage)
}

protocol PublicCategorySelectDelegate: AnyObject {
    func didSelectPublicCategory(selectedCat: CategoriesData)
}

protocol PublicTimeSelectDelegate: AnyObject {
    func didSelectPublicTime(time: String)
}

protocol PublicCreateRoomDelegate: AnyObject {
    func didCreateRoom()
}

class CreatePublicRoomVC: BaseViewController {
    
    @IBOutlet weak var publicRoomTableView: UITableView!
    
    lazy var createPublicRoomViewModel: CreatePublicRoomViewModel = {
        let obj = CreatePublicRoomViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var categoriesArr: [CategoriesData] = []
    var selectedCategory: CategoriesData!
    var selectedTime = ""
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        return imagePicker
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        publicRoomTableView.delegate = self
        publicRoomTableView.dataSource = self

        registerCell()
        resetDefaults ()
      //  setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    // MARK: - ==== CUSTOM METHODs ====
    func registerCell() {
        publicRoomTableView.register(UINib(nibName: RoomClassTableViewCell.className, bundle: nil), forCellReuseIdentifier: RoomClassTableViewCell.className)
        publicRoomTableView.register(UINib(nibName: CategoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.identifier)
        publicRoomTableView.register(UINib(nibName: RoomNameTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RoomNameTableViewCell.identifier)
//        publicRoomTableView.register(UINib(nibName: DateTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DateTableViewCell.identifier)
        publicRoomTableView.register(UINib(nibName: SelectDateTVC.className, bundle: nil), forCellReuseIdentifier: SelectDateTVC.className)
        publicRoomTableView.register(UINib(nibName: StartTimeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: StartTimeTableViewCell.identifier)
        publicRoomTableView.register(UINib(nibName: DurationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DurationTableViewCell.identifier)
        publicRoomTableView.register(UINib(nibName: ThumbnailTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ThumbnailTableViewCell.identifier)
    }
    
    func setupClosure() {
        createPublicRoomViewModel.redirectControllerClosure = { [weak self] in
            DispatchQueue.main.async {
                let roomResponseStatus = self?.createPublicRoomViewModel.addRoomResponse?.status
                if roomResponseStatus == APIKeys.success {
                    UIAlertController.showAlert((roomResponseStatus, roomResponseStatus), sender: self, actions: AlertAction.Okk) { action in
                      
                    }
                }
              
            }
        }
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
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}


// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension CreatePublicRoomVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return 6
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: RoomClassTableViewCell.className) as! RoomClassTableViewCell
            return cell
//        case 0:
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as? CategoryTableViewCell else {
                return UITableViewCell()
            }
            // Remove first element or ALL category
            if let allIndex = categoriesArr.firstIndex(where: {$0.title == "All"}) {
                self.categoriesArr.remove(at: allIndex)
            }
            cell.categories = categoriesArr
            cell.publicDelegate = self
            return cell
//        case 1:
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoomNameTableViewCell.identifier) as? RoomNameTableViewCell else {
                return UITableViewCell()
            }
            cell.viewModel = self.createPublicRoomViewModel
            cell.setupClosure()
            return cell
//        case 2:
        case 3:
            /*guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.identifier) as? DateTableViewCell else {
                return UITableViewCell()
            }*/
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectDateTVC.className) as! SelectDateTVC
            cell.parentVC = self
            return cell
//        case 3:
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StartTimeTableViewCell.identifier) as? StartTimeTableViewCell else {
                return UITableViewCell()
            }
            cell.publicDelegate = self
            return cell
//        case 4:
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DurationTableViewCell.identifier) as? DurationTableViewCell else {
                return UITableViewCell()
            }
            return cell
//        case 5:
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ThumbnailTableViewCell.identifier) as? ThumbnailTableViewCell else {
                return UITableViewCell()
            }
            cell.parentVC = self
            cell.viewModel = createPublicRoomViewModel
            cell.publicRoomDelegate = self
            cell.roomType = EventType.Public.rawValue
            cell.setupClosure()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 120
//        case 0:
        case 1:
            return 150
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
//        case 0:
        case 1:
            return 150
//        case 1:
        case 2:
            return 120
//        case 2:
        case 3:
            return UITableView.automaticDimension
//        case 3:
        case 4:
//            return 200
            return 150
//        case 4:
        case 5:
            return 300
//        case 5:
        case 6:
            return 400
//            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
    
}

extension CreatePublicRoomVC: PublicRoomDelegate {
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
        self.createPublicRoomViewModel.uploadImage(params: params, files:[file])
    }
    
}

// MARK: ImagePickerDelegate

extension CreatePublicRoomVC: ImagePickerDelegate {
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

extension CreatePublicRoomVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let _ = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
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

extension CreatePublicRoomVC: PublicCategorySelectDelegate {
    
    func didSelectPublicCategory(selectedCat: CategoriesData) {
        self.selectedCategory = selectedCat
//        debugPrint("Sel Cat is \(self.selectedCategory.title)")
        if let id = self.selectedCategory._id, let title = selectedCategory.title {
//            UserDefaultUtility.shared.saveCategoryId(id: id)
            UserDefaultUtility.shared.saveCategoryIdName(id: id, name: title)
        }
    }
}

extension CreatePublicRoomVC: PublicTimeSelectDelegate {
    
    func didSelectPublicTime(time: String) {
        self.selectedTime = time
//        debugPrint("Sel Time is \(self.selectedTime)")
        UserDefaultUtility.shared.saveStartTime(time: selectedTime)
    }
}

extension CreatePublicRoomVC: PublicCreateRoomDelegate {
    
    func didCreateRoom() {
        DispatchQueue.main.async {
            self.navigateToHomeScreen()
        }
    }
}

