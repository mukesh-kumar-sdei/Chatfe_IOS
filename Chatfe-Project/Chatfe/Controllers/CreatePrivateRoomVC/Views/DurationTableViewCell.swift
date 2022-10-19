//
//  DurationTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 10/05/22.
//

import UIKit
import DropDown

class DurationTableViewCell: UITableViewCell {
    
    static let identifier = "DurationTableViewCell"

    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var dropDownList = ["30 mins", "1 hour", "1.5 hours", "2 hours", "2.5 hours", "3 hours", "3.5 hours", "4 hours", "4.5 hours", "5 hours", "5.5 hours", "6 hours"]
    var dropDownListDouble =  [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0]
    var durationDropDown = DropDown()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
//        setupTap()
        NotificationCenter.default.addObserver(self, selector: #selector(editRoomInitials(_:)), name: Notification.Name.EditRoomDurationDefault, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(limitDurationTaping(_:)), name: Notification.Name.SelectedRoomClass, object: nil)
    }
    
    @objc func editRoomInitials(_ notification: Notification) {
        DispatchQueue.main.async {
            if let duration = notification.object as? Double {
                if let index = self.dropDownListDouble.firstIndex(where: {$0 == duration}) {
                    self.durationTextField.text = self.dropDownList[index]
                    UserDefaultUtility.shared.saveDuration(duration: self.dropDownListDouble[index])
                }
            }
        }
    }
    
    @objc func limitDurationTaping(_ notification: Notification) {
        DispatchQueue.main.async {
            if let selectedRoomClass = notification.object as? String {
                UserDefaultUtility.shared.saveDuration(duration: 0.0)
                if selectedRoomClass.localizedCaseInsensitiveContains("Chat") {
                    self.durationTextField.text = self.dropDownList.first
                    UserDefaultUtility.shared.saveDuration(duration: ((self.durationTextField.text! as NSString).doubleValue)/60)
                    self.durationTextField.isUserInteractionEnabled = false
                } else {
                    UserDefaultUtility.shared.saveDuration(duration: 0.0)
                    self.setupTap()
                    self.durationTextField.text = "Select"
                    self.durationTextField.isUserInteractionEnabled = true
                    self.durationDropDown.anchorView = self.durationTextField
                    self.durationDropDown.dataSource = self.dropDownList
                    self.durationDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                        if item.contains("min") {
                            durationTextField.text = item
                            UserDefaultUtility.shared.saveDuration(duration: ((durationTextField.text! as NSString).doubleValue)/60)
                        } else {
                            durationTextField.text = item
                            UserDefaultUtility.shared.saveDuration(duration: (durationTextField.text! as NSString).doubleValue)
                        }
                    }
                }
            }
        }
    }
    
    func setupView() {
        
        DispatchQueue.main.async {
            if UserDefaultUtility.shared.getRoomClass() == "Chat" {
                self.durationTextField.text = self.dropDownList.first
                UserDefaultUtility.shared.saveDuration(duration: ((self.durationTextField.text! as NSString).doubleValue)/60)
                self.durationTextField.isUserInteractionEnabled = false
            } else {
                self.setupTap()
                self.durationTextField.text = "Select"
                self.durationTextField.isUserInteractionEnabled = true
                self.durationDropDown.anchorView = self.durationTextField
                self.durationDropDown.dataSource = self.dropDownList
                self.durationDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    if item.contains("min") {
                        durationTextField.text = item
                        UserDefaultUtility.shared.saveDuration(duration: ((durationTextField.text! as NSString).doubleValue)/60)
                    } else {
                        durationTextField.text = item
                        UserDefaultUtility.shared.saveDuration(duration: (durationTextField.text! as NSString).doubleValue)
                    }
                }
            }
        }
        
        self.descriptionTextField.attributedPlaceholder = NSAttributedString(string: "Optional", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.descriptionTextField.tintColor = UIColor.white
        descriptionTextField.delegate = self
    }
    
    func setupTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDuration))
        self.durationTextField.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapDuration() {
        debugPrint("Tapped")
        durationDropDown.show()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DurationTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaultUtility.shared.saveAbout(about: descriptionTextField.text ?? "")
    }
}
