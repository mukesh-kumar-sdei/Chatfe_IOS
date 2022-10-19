//
//  RoomNameTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 10/05/22.
//

import UIKit
import DropDown

class RoomNameTableViewCell: UITableViewCell {
    
    static let identifier = "RoomNameTableViewCell"

    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var suggestionTableView: UITableView!
    
    var parentVC: BaseViewController!
    var viewModel: CreatePublicRoomViewModel!
    var isPrivateRoom = false
    var suggestionTitleArr = [String]()
    var suggestionsList: [SearchGetMovieData]?
    var suggestionsDropDown = DropDown()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roomNameTextField.delegate = self
        roomNameTextField.autocorrectionType = .no
        self.roomNameTextField.attributedPlaceholder = NSAttributedString(string: self.roomNameTextField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor("#383D44")])
        self.roomNameTextField.tintColor = UIColor.white
    }
    
    func setupDropDownView() {
        
        // APPEARANCE
        DropDown.appearance().textColor = UIColor.white
        DropDown.appearance().selectedTextColor = AppColor.appBlueColor
        DropDown.appearance().textFont = UIFont(name: AppFont.ProximaNovaRegular, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        DropDown.appearance().backgroundColor = UIColor.darkGray // AppColor.accentColor // UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.gray
        DropDown.appearance().cellHeight = 40.0
        

//        if UserDefaultUtility.shared.ca
        self.suggestionsDropDown.anchorView = self.roomNameTextField
        suggestionsDropDown.bottomOffset = CGPoint(x: 0, y: roomNameTextField.bounds.height)
        suggestionsDropDown.width = roomNameTextField.bounds.width - 10
        suggestionsDropDown.direction = .bottom
        self.suggestionsDropDown.dataSource = self.suggestionTitleArr
        self.suggestionsDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            roomNameTextField.text = item
            roomNameTextField.resignFirstResponder()
            let posterImage = self.suggestionsList?[index].poster
            NotificationCenter.default.post(name: Notification.Name.IMDB_POSTER_IMAGE, object: posterImage)
            UserDefaultUtility.shared.saveRoomName(name: roomNameTextField.text ?? "")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupClosure() {
        self.viewModel.reloadMenuClosure1 = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.suggestionsList = self.viewModel.suggestionsList ?? []
                self.suggestionTitleArr = self.suggestionsList?.compactMap({$0.title}) ?? []
                if self.suggestionsList?.count ?? 0 > 0 {
                    self.setupDropDownView()
//                    self.roomNameTextField.resignFirstResponder()
                    self.suggestionsDropDown.show()
                }
            }
        }
    }
}

extension RoomNameTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaultUtility.shared.saveRoomName(name: textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.roomNameTextField {
            if let categoryTitle = UserDefaultUtility.shared.getCategoryName(), categoryTitle == EventCategory.Movies {
                if self.roomNameTextField.text?.count ?? 0 >= 3 {
                    /// BELOW LINE PROVIDES COMPLETE TYPED STRING
                    let completeString = ((self.roomNameTextField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
                    self.viewModel.getMovieSuggestions(searchText: completeString)

                    return true
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == roomNameTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
