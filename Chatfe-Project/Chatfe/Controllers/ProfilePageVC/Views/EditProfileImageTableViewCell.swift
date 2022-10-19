//
//  EditProfileImageTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 26/05/22.
//

import UIKit
import Kingfisher

class EditProfileImageTableViewCell: UITableViewCell {
    
    static let identifier = "EditProfileImageTableViewCell"
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var editAboutTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    
    lazy var profilePageViewModel: ProfilePageViewModel = {
        let obj = ProfilePageViewModel(userService: UserService())
        self.parentVC.baseVwModel = obj
        return obj
    }()
    
    var editNameDelegate: EditProfileNameDelegate?
    var imageUrl = UserDefaultUtility.shared.getProfileImageURL()
    var imageUploaded = false
    var parentVC: BaseViewController!
    var editName = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.lblUsername.text = UserDefaultUtility.shared.getLoginType() == Constants.AppName ? UserDefaultUtility.shared.getUsername() ? ""
        
        self.editNameTextField.borderColor = AppColor.appBlueColor
        self.editNameTextField.borderWidth = 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        self.profileImageView.addGestureRecognizer(tapGesture)
        /*
        self.editAboutTextField.borderColor = AppColor.appBlueColor
        self.editAboutTextField.borderWidth = 2
        self.editAboutTextField.attributedPlaceholder = NSAttributedString(string: self.editAboutTextField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor("#383D44")])
         */
        
        self.aboutTextView.borderColor = AppColor.appBlueColor
        self.aboutTextView.borderWidth = 2
        self.editNameTextField.font = UIFont(name: AppFont.ProximaNovaMedium, size: 16.0)
     
        if editName == false {
            self.editButton.isHidden = false
            self.saveBtn.isHidden = true
            self.editNameTextField.backgroundColor = .clear
            self.editNameTextField.textAlignment = .center
            self.editNameTextField.borderWidth = 0
            self.editNameTextField.clipsToBounds = true
            self.editNameTextField.isUserInteractionEnabled = false
            self.editNameTextField.font = UIFont(name: AppFont.ProximaNovaBold, size: 28.0)
            /*
            self.editAboutTextField.backgroundColor = .clear
            self.editAboutTextField.borderWidth = 0
            self.editAboutTextField.textAlignment = .center
            self.editAboutTextField.clipsToBounds = true
            self.editAboutTextField.isUserInteractionEnabled = false
            */
            self.aboutTextView.backgroundColor = .clear
            self.aboutTextView.borderWidth = 0
            self.aboutTextView.textAlignment = .center
            self.aboutTextView.clipsToBounds = true
            self.aboutTextView.isUserInteractionEnabled = false
            
        } else {
            self.editButton.isHidden = true
            self.saveBtn.isHidden = false
            
            self.editNameTextField.tintColor = .white
            self.editNameTextField.backgroundColor = .black
            self.editNameTextField.borderWidth = 2
            self.editNameTextField.borderColor = AppColor.appBlueColor
            self.editNameTextField.borderStyle = .roundedRect
            self.editNameTextField.isUserInteractionEnabled = true
            self.editNameTextField.font = UIFont(name: AppFont.ProximaNovaMedium, size: 14.0)
            /*
            self.editAboutTextField.tintColor = .white
            self.editAboutTextField.cornerRadius = self.editAboutTextField.frame.size.height / 2
            self.editAboutTextField.borderColor = AppColor.appBlueColor
            self.editAboutTextField.backgroundColor = .black
            self.editAboutTextField.borderWidth = 2
            self.editAboutTextField.borderStyle = .roundedRect
            self.editAboutTextField.textAlignment = .left
            self.editAboutTextField.clipsToBounds = true
            self.editAboutTextField.isUserInteractionEnabled = true
            */
            self.aboutTextView.tintColor = .white
            self.aboutTextView.cornerRadius = self.aboutTextView.frame.height / 2
            self.aboutTextView.backgroundColor = .black
            self.aboutTextView.borderWidth = 2
            self.aboutTextView.textAlignment = .left
            self.aboutTextView.clipsToBounds = true
            self.aboutTextView.isUserInteractionEnabled = true
        }
       // setupClosure()
    }
    
    func setupProfileImage() {
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            self.profileImageView.kf.setImage(with: url)
        } else {
            if let fullname = UserDefaultUtility.shared.getFullName() {
                let attributedFont = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                      NSAttributedString.Key.font: UIFont(name: AppFont.ProximaNovaBold, size: 40.0) ?? UIFont.systemFont(ofSize: 40.0)]
                self.profileImageView.setImage(string: fullname, circular: true, textAttributes: attributedFont)
            }
        }
    }
    
    @objc func tapped(_ gesture: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.parentVC.present(alert, animated: true, completion: nil)
    }

    
    private lazy var imagePicker: ImagePicker = {
       let imagePicker = ImagePicker()
        return imagePicker
    }()
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        
        if editName == false {
            self.editName.toggle()

            self.editButton.isHidden = true
            self.saveBtn.isHidden = false
//            self.profileImageView.isUserInteractionEnabled = true
        
            self.editNameTextField.tintColor = .white
            self.editNameTextField.backgroundColor = .black
            self.editNameTextField.borderWidth = 2
            self.editNameTextField.borderColor = AppColor.appBlueColor
            self.editNameTextField.borderStyle = .roundedRect
            self.editNameTextField.textAlignment = .left
            self.editNameTextField.isUserInteractionEnabled = true
            self.editNameTextField.font = UIFont(name: AppFont.ProximaNovaMedium, size: 14.0)
//            self.editNameTextField.delegate = self
            /*
            self.editAboutTextField.tintColor = .white
            self.editAboutTextField.backgroundColor = .black
            self.editAboutTextField.cornerRadius = self.editAboutTextField.frame.size.height / 2
            self.editAboutTextField.borderWidth = 2
            self.editAboutTextField.borderStyle = .roundedRect
            self.editAboutTextField.textAlignment = .left
            self.editAboutTextField.clipsToBounds = true
            self.editAboutTextField.isUserInteractionEnabled = true
            */
            self.aboutTextView.tintColor = .white
            self.aboutTextView.cornerRadius = self.aboutTextView.frame.height / 2
            self.aboutTextView.backgroundColor = .black
            self.aboutTextView.borderWidth = 2
            self.aboutTextView.textAlignment = .left
            self.aboutTextView.clipsToBounds = true
            self.aboutTextView.isUserInteractionEnabled = true
        } else {
            self.editButton.isHidden = false
            self.saveBtn.isHidden = true
            self.editName.toggle()

            self.editNameTextField.backgroundColor = .clear
            self.editNameTextField.textAlignment = .center
            self.editNameTextField.borderWidth = 0
            self.editNameTextField.isUserInteractionEnabled = false
            self.editNameTextField.font = UIFont(name: AppFont.ProximaNovaBold, size: 28.0)
            /*
            self.editAboutTextField.backgroundColor = .clear
            self.editAboutTextField.borderWidth = 0
            self.editAboutTextField.textAlignment = .center
            self.editAboutTextField.clipsToBounds = true
            self.editAboutTextField.isUserInteractionEnabled = false
            */
            self.aboutTextView.backgroundColor = .clear
            self.aboutTextView.borderWidth = 0
            self.aboutTextView.textAlignment = .center
            self.aboutTextView.clipsToBounds = true
            self.aboutTextView.isUserInteractionEnabled = false
            
            guard let name = editNameTextField.text else {
                return
            }
//            UserDefaultUtility.shared.saveUsername(name: name)
//            debugPrint("name is \(name)")
            let fullNameArr = name.components(separatedBy: " ")
            debugPrint(fullNameArr)
            let fname = fullNameArr[0]
//            debugPrint("The First Name is ", fname)
           
            var lname = ""
            
            if name.contains(" ") {
//                 debugPrint("The Last Name is ", fullNameArr[1])
                lname = fullNameArr[1]
            } else {
                lname = ""
            }
            
    //        if !fullNameArr[1].isEmpty {
    //            lname = fullNameArr[1]
    //        } else {
    //            lname = ""
    //        }
            let params = [APIKeys.fname         : fname,
                          APIKeys.lname         : lname,
                          APIKeys.aboutYourself : aboutTextView.text ?? "", // editAboutTextField.text ?? "",
                          APIKeys.profileImg    : [APIKeys.image: UserDefaultUtility.shared.getProfileImageURL()]
                        ] as [String: Any]
          //  let lname = editNameTextField.text?.after(first: "_")
            if editNameTextField.text == "" {
                self.parentVC.showBaseAlert(AlertMessage.pleaseEnterYourName)
            } else {
                profilePageViewModel.updateProfile(params: params)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupClosure() {
        profilePageViewModel.reloadListViewClosure = { [weak self] in
            if self?.profilePageViewModel.updateProfileResponse?.status == APIKeys.success {
                DispatchQueue.main.async {
//                    self?.parentVC.showBaseAlert(self?.profilePageViewModel.updateProfileResponse?.data ?? "")
                    self?.editNameDelegate?.setEdit(to: false)
//                    let parent1 = self?.parentVC as! ProfileVC
//                    parent1.profileTableView.reloadData()
                }
            } else if self?.profilePageViewModel.updateProfileErrorResponse?.status == APIKeys.error {
                DispatchQueue.main.async {
                    self?.parentVC.showBaseAlert(self?.profilePageViewModel.updateProfileErrorResponse?.message ?? "")
                    self?.editNameDelegate?.setEdit(to: false)
                }
            }
        }
        
        profilePageViewModel.redirectControllerClosure = { [weak self] in
            DispatchQueue.main.async {
                if self?.profilePageViewModel.imageUploadResponse?.status == APIKeys.success {
                    if let strImage = self?.profilePageViewModel.imageUploadResponse?.files?.first {
                        if let imageURL = NSURL(string: strImage) {
                            UserDefaultUtility.shared.saveProfileImageURL(url: imageURL)
                            if !(self?.editName ?? false) {
                                let params = [APIKeys.profileImg: [APIKeys.image: UserDefaultUtility.shared.getProfileImageURL()]]
                                self?.profilePageViewModel.updateProfile(params: params)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.parentVC.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.parentVC.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.parentVC.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have permission to access gallery", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.parentVC.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func photoButtonTapped(_ sender: UIButton) {
        imagePicker.photoGalleryAccessRequest()
    }
    
    @objc func cameraButtonTapped(_ sender: UIButton) {
        imagePicker.cameraAccessRequest()
    }
    
}

// MARK: ImagePickerDelegate

extension EditProfileImageTableViewCell: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        profileImageView.image = image
        imagePicker.dismiss()
        imageUploaded = true
    }
    
    func cancelButtonDidClick(on imageView: ImagePicker) {
        imagePicker.dismiss()
    }
    
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool, to sourceType: UIImagePickerController.SourceType) {
        if grantedAccess {
            imagePicker.present(parent: self.parentVC, sourceType: sourceType)
        }
    }
    
}

// MARK: UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension EditProfileImageTableViewCell: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImageView.image = tempImage
        imageUploaded = true
        self.parentVC.dismiss(animated: true, completion: nil)
        
        if let imageURL = (info[UIImagePickerController.InfoKey.imageURL]) {
            UserDefaultUtility.shared.saveProfileImageURL(url: imageURL as! NSURL)
        }
        
        if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let name = UUID().uuidString
            let fileName = "\(name).jpg"
            self.uploadImage(name: name, fileName: fileName, selectedImage: tempImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.parentVC.dismiss(animated: true, completion: nil)
    }
        
    func uploadImage(name: String, fileName: String, selectedImage: UIImage) {
        let imageData = selectedImage.jpegData(compressionQuality: 0.8)! as NSData
        let file = File(name: name, fileName: fileName, data: imageData as Data)
        profilePageViewModel.uploadProfilePic(params: [:], files: [file])
    }
}

/*
extension EditProfileImageTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == editNameTextField {
            self.editNameTextField.text = textField.text
            self.editNameDelegate?.setEdit(to: false)
            self.editNameDelegate?.setName(name: self.editNameTextField.text ?? "")
        }
    }
}
*/
