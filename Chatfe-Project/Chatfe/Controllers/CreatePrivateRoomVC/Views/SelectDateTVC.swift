//
//  DateTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 10/05/22.
//

import UIKit

class SelectDateTVC: UITableViewCell {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var uiDatePicker: UIDatePicker!
    @IBOutlet weak var addDateBtn: UIButton!
    @IBOutlet weak var txtDate: UITextField!
    
    var datePicker = UIDatePicker()
    var toolbar = UIToolbar()
    var parentVC : BaseViewController!
    
    
    // MARK: - ==== CELL LIFECYCLE ====
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // INITIALLY SHOWING TODAY's DATE
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let strDate = dateFormatter.string(from: Date())
        txtDate.text = strDate
        
        dateFormatter.dateFormat = DateFormats.yyyyMMdd
        let strDate1 = dateFormatter.string(from: Date())
        UserDefaultUtility.shared.saveDate(date: strDate1)
        
        addCustomDatePicker()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func addCustomDatePicker() {
        // CUSTOM DATE PICKER
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Date()
        picker.maximumDate = Calendar.current.date(byAdding: .month, value: 6, to: Date())
        picker.preferredDatePickerStyle = .inline
        
        // Big enough frame
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350)
        let pickerWrapperView = UIView(frame: rect)
        pickerWrapperView.addSubview(picker)

        // Adding constraints
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.leadingAnchor.constraint(equalTo: pickerWrapperView.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: pickerWrapperView.trailingAnchor).isActive = true
        picker.topAnchor.constraint(equalTo: pickerWrapperView.topAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: pickerWrapperView.bottomAnchor).isActive = true

        // Using wrapper view instead of picker
        txtDate.tintColor = .clear
        txtDate.inputView = pickerWrapperView
        
        txtDate.keyboardToolbar.isHidden = true
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    @objc func dateChanged(_ sender: Any) {
        if let picker = sender as? UIDatePicker {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let strDate = dateFormatter.string(from: picker.date)
            self.txtDate.text = strDate
            self.txtDate.resignFirstResponder()
            
            dateFormatter.dateFormat = DateFormats.yyyyMMdd
            let strDate1 = dateFormatter.string(from: picker.date)
            UserDefaultUtility.shared.saveDate(date: strDate1)
        }
    }
    
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func addDateBtnTapped(_ sender: UIButton) {
        // NOTHING TO DO
    }
    
}


extension UIDatePicker {

   func setDate(from string: String, format: String, animated: Bool = true) {
      let formater = DateFormatter()
      formater.dateFormat = format
      let date = formater.date(from: string) ?? Date()
      setDate(date, animated: animated)
   }
}
