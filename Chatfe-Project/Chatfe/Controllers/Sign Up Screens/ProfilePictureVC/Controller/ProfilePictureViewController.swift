//
//  ProfilePictureViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit

class ProfilePictureViewController: BaseViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var takePictureBtn: UIButton!
    @IBOutlet weak var visibleAll: UIButton!
    @IBOutlet weak var visibleFriends: UIButton!
    
    lazy var profilePictureViewModel: ProfilePictureViewModel = {
       let obj = ProfilePictureViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var imageUploaded = false
//    var privacy = "Friends"
    var privacy = ""
    
    var name = ""
    var fileName = ""
    var selectedImage: UIImage!
    var imageURL = ""
    
    private lazy var imagePicker: ImagePicker = {
       let imagePicker = ImagePicker()
        return imagePicker
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.visibleAll.setImage(Images.radioButtonEmpty, for: .normal)
        self.visibleFriends.setImage(Images.radioButtonEmpty, for: .normal)
        setupView()
        setupClosure()
    }
    
    func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        self.profileImage.addGestureRecognizer(tapGesture)
    }
    
    func setupClosure() {
        profilePictureViewModel.redirectControllerClosure = { [weak self] in
            DispatchQueue.main.async {
                let responseStatus = self?.profilePictureViewModel.imageUploadResponse?.status
                if  responseStatus == APIKeys.success {
                    UserDefaultUtility.shared.saveProfileImageURL(strURL: self?.profilePictureViewModel.imageUploadResponse?.files?.first ?? "")
                    UIAlertController.showAlert((responseStatus, "Profile Picture Uploaded Successfully"), sender: self, actions: AlertAction.Okk) { action in
                        let nextVC = kMainStoryboard.instantiateViewController(withIdentifier: NotificationsViewController.className) as! NotificationsViewController
                        self?.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
        }
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func visibleAllBtnTapped(_ sender: UIButton) {
        self.visibleAll.setImage(Images.radioButtonFilled, for: .normal)
        self.visibleFriends.setImage(Images.radioButtonEmpty, for: .normal)
        self.privacy = "All"
    }
    
    @IBAction func visibleFriendsBtnTapped(_ sender: Any) {
        self.visibleFriends.setImage(Images.radioButtonFilled, for: .normal)
        self.visibleAll.setImage(Images.radioButtonEmpty, for: .normal)
        self.privacy = "Friends"
    }
    
    @IBAction func TakePictureBtnTapped(_ sender: UIButton) {
        if imageUploaded == false {
            self.showBaseAlert("Please select profile Image to continue.")
        } else if privacy == "" {
            self.showBaseAlert("Please select privacy option to continue.")
        } else {
            UserDefaultUtility.shared.saveProfileImageVisibility(visibleTo: privacy)
            uploadImage()
        }
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
    
    func uploadImage() {
        let imageData = selectedImage.jpegData(compressionQuality: 0.8)! as NSData
        let file = File(name: name, fileName: fileName, data: imageData as Data)
        profilePictureViewModel.uploadProfilePic(params: [:], files: [file])
        if let url = profilePictureViewModel.imageUploadResponse?.files?.first {
            self.imageURL = url
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
    
    @objc func photoButtonTapped(_ sender: UIButton) {
        imagePicker.photoGalleryAccessRequest()
    }
    
    @objc func cameraButtonTapped(_ sender: UIButton) {
        imagePicker.cameraAccessRequest()
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
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
    
}


// MARK: ImagePickerDelegate

extension ProfilePictureViewController: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        profileImage.image = image
        imagePicker.dismiss()
        imageUploaded = true
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

extension ProfilePictureViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImage.image = pickedImage
        selectedImage = pickedImage
        imageUploaded = true
        self.dismiss(animated: true, completion: nil)
        
        self.name = UUID().uuidString
        self.fileName = "\(name).jpg"
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
