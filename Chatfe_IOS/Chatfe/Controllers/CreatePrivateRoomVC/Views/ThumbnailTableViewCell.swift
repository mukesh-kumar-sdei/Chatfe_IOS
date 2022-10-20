//
//  ThumbnailTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 10/05/22.
//

import UIKit

class ThumbnailTableViewCell: UITableViewCell {
    
    static let identifier = "ThumbnailTableViewCell"
    
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var btnUpdateEvent: UIButton!
    
    var viewModel: CreatePublicRoomViewModel!
    var selectedImage: UIImage!
    var delegate: PublicRoomDelegate?
    var createPrivateRoomDelegate: CreatePrivateRoomDelegate?
    var parentVC: BaseViewController!
    var publicRoomDelegate: PublicCreateRoomDelegate?
    
    var name = ""
    var fileName = ""
    var imageUrl = ""
    var roomType = "Public"
//    var isEditRoom = false
    let pasteBoard = UIPasteboard.general
    
    
    private lazy var imagePicker: ImagePicker = {
       let imagePicker = ImagePicker()
        return imagePicker
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        roomImageView.addGestureRecognizer(tapGesture)
        
       // setupClosure()
        NotificationCenter.default.addObserver(self, selector: #selector(posterImageIMDB(_:)), name: Notification.Name.IMDB_POSTER_IMAGE, object: nil)
    }
    
    @objc func posterImageIMDB(_ notification: Notification) {
        DispatchQueue.main.async {
            if let posterImg = notification.object as? String {
                if let posterImgURL = URL(string: posterImg) {
                    self.selectedImage = posterImg.stringToImage()
                    self.roomImageView.kf.setImage(with: posterImgURL)
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupClosure() {
        /// UPLOAD IMAGE RESPONSE
        self.viewModel.reloadListViewClosure = {
            self.imageUrl = self.viewModel.imageUploadResponse?.files?.first ?? ""
            self.hitCreateEventAPI()
        }
        
        /// ADD ROOM RESPONSE
        self.viewModel.redirectControllerClosure = { [weak self] in

            /// ADDING EVENT TO APPLE CALENDAR
            /*if let model = self?.viewModel.addRoomResponse?.data {
                let startDate = model.startDate?.serverToLocalFormattedTime().getFormattedDate() ?? Date()
                let endDate = model.endDate?.serverToLocalFormattedTime().getFormattedDate() ?? Date()
                self?.parentVC.addEventToAppleCalendar(title: model.roomName ?? "", description: model.about, startDate: startDate, endDate: endDate, completion: nil)
            }*/
            
            if self?.roomType == "Public" {
                self?.publicRoomDelegate?.didCreateRoom()
            } else {
                UserDefaultUtility.shared.removeInvitedFriendNames()
                UserDefaultUtility.shared.removeInvitedFriendsIDs()
                self?.createPrivateRoomDelegate?.didCreateRoom()
            }
            
        }
    }
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func uploadBtnTapped(_ sender: UIButton) {
        if selectedImage == nil {
            let configAlert: AlertUI = (kAppName, "Please select an image to upload!")
            UIAlertController.showAlert(configAlert)
            
        } else {
            let imageData = selectedImage.jpegData(compressionQuality: 0.8)! as NSData
            let file = File(name: name, fileName: fileName, data: imageData as Data)
            viewModel.uploadImage(params: [:], files:[file])
            if let url = viewModel.imageUploadResponse?.files?.first {
                debugPrint("The Room Image URL is ", url)
                self.imageUrl = url
            }
        }
       // uploadImage(paramName: "Window", fileName: "Window.png", image: selectedImage)
    }
    
    
    @IBAction func createChatBtnTapped(_ sender: UIButton) {
        if sender.currentTitle == "Create Chat" {
            
            self.hitUploadImageAPI()

        }
    }
    
    @objc func imageTapped() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        if pasteBoard.hasImages {
            alert.addAction(UIAlertAction(title: "Paste Image", style: .default, handler: { _ in
                if self.pasteBoard.hasImages {
                    self.roomImageView.image = self.pasteBoard.image
                    self.selectedImage = self.pasteBoard.image
                }
            }))
        }
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        parentVC.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            parentVC.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            parentVC.present(alert, animated: true, completion: nil)
           // self.inputViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            parentVC.present(imagePicker, animated: true, completion: nil)
            //self.inputViewController?.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have permission to access gallery", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            parentVC.present(alert, animated: true, completion: nil)
           // self.inputViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
}

// MARK: ImagePickerDelegate

extension ThumbnailTableViewCell: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        roomImageView.image = image
        selectedImage = image
        imagePicker.dismiss()
    }
    func cancelButtonDidClick(on imageView: ImagePicker) {
        //self.inputViewController?.dismiss(animated: true, completion: nil)
         imagePicker.dismiss()
    }
    
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool, to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else {
            return
        }
        imagePicker.present(parent: inputViewController!, sourceType: sourceType)
    }
}

extension ThumbnailTableViewCell: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        roomImageView.image = tempImage
        self.selectedImage = tempImage
        parentVC.dismiss(animated: true, completion: nil)
        self.inputViewController?.dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       parentVC.dismiss(animated: true, completion: nil)
       //dismiss(animated: true, completion: nil)
    }
}


extension ThumbnailTableViewCell {
    
    func hitUploadImageAPI() {
        if selectedImage == nil {
            let configAlert: AlertUI = (kAppName, AlertMessage.selectImageToUpload)
            UIAlertController.showAlert(configAlert)
        } else {
            self.name = UUID().uuidString
            self.fileName = "\(name).jpg"
            let imageData = selectedImage.jpegData(compressionQuality: 0.8)! as NSData
            let file = File(name: name, fileName: fileName, data: imageData as Data)
            viewModel.uploadImage(params: [:], files:[file])
            /*if let url = viewModel.imageUploadResponse?.files?.first {
                self.imageUrl = url
            }*/
        }
    }
    
    func hitCreateEventAPI() {
        DispatchQueue.main.async {
            var params:[String:Any] = [:]
            let privateKey = EventType.Private.rawValue
            
            if UserDefaultUtility.shared.getCategoryId() == "" {
                self.parentVC.showBaseAlert("Please Choose a Category")
            } else if UserDefaultUtility.shared.getRoomName() == "" {
                self.parentVC.showBaseAlert("Please Enter Room Name")
            } else if UserDefaultUtility.shared.getDate() == "" {
                self.parentVC.showBaseAlert("Please Choose a Date")
            } else if UserDefaultUtility.shared.getStartTime() == "" {
                self.parentVC.showBaseAlert("Please Choose Start Time")
            } else if UserDefaultUtility.shared.getDuration() == 0.0 {
                self.parentVC.showBaseAlert("Please Select Duration")
            } else if self.imageUrl == "" {
                self.parentVC.showBaseAlert("Please Upload an Image")
            } else if (UserDefaultUtility.shared.getInviteFriendsIDs() == nil) && (UserDefaultUtility.shared.getInvitedFriendsEmail() == nil || UserDefaultUtility.shared.getInvitedFriendsEmail() == "") && self.roomType == privateKey {
                self.parentVC.showBaseAlert("Please invite friends for this room.")
            } else {
                let eventDateTime = "\(UserDefaultUtility.shared.getDate()) \(UserDefaultUtility.shared.getStartTime())"
                let eventDate = eventDateTime.localToServerTime()
                params = ["categoryId"  : UserDefaultUtility.shared.getCategoryId(),
                          "roomName"    : UserDefaultUtility.shared.getRoomName(),
    //                          "date"        : UserDefaultUtility.shared.getDate(),
    //                          "startTime"   : UserDefaultUtility.shared.getStartTime(),
                          "startDate"   : eventDate,
                          "duration"    : UserDefaultUtility.shared.getDuration(),
                          "about"       : UserDefaultUtility.shared.getAbout() ?? "",
                          "roomType"    : self.roomType,
                          "image"       : self.imageUrl,
                          "roomClass"   : UserDefaultUtility.shared.getRoomClass() ?? "",
                          "friendsArr"  : self.roomType == privateKey ? (UserDefaultUtility.shared.getInviteFriendsIDs() ?? []) : "",
                          "mails"       : self.roomType == privateKey ? (UserDefaultUtility.shared.getInvitedFriendsEmail() ?? "") : ""
                ]
                self.viewModel.addRoom(params: params)
            }
        }
    }
}
