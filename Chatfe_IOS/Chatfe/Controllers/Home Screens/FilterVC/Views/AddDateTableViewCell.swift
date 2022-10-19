//
//  AddDateTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 13/05/22.
//

import UIKit

class AddDateTableViewCell: UITableViewCell {
    
    static let identifier = "AddDateTableViewCell"
    
    @IBOutlet weak var addDateBtn: UIButton!
    @IBOutlet weak var uiDatePicker: UIDatePicker!
    @IBOutlet weak var btnCheckbox: UIButton!
    @IBOutlet weak var lblFreeCalendar: UILabel!
    
    weak var filterDelegate: SelectDateDelegate?
    var parentVC: BaseViewController!
    var datePicker = UIDatePicker()
    var toolbar = UIToolbar()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnCheckbox.setImage(Images.checkBoxEmpty, for: .normal)
        UserDefaultUtility.shared.saveFreeMyCalendar(false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func addDateBtnTapped(_ sender: UIButton) {
        self.uiDatePicker.isHidden.toggle()
        self.uiDatePicker.datePickerMode = .date
        self.uiDatePicker.backgroundColor = .white
        self.uiDatePicker.minimumDate = Date()
        self.uiDatePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 6, to: Date())
        self.uiDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .allEvents)
    }
    
    @IBAction func checkboxBtnTapped(_ sender: UIButton) {
        if sender.currentImage == Images.checkBoxEmpty {
            self.btnCheckbox.setImage(Images.checkBoxFilled, for: .normal)
            self.lblFreeCalendar.textColor = UIColor.white
            UserDefaultUtility.shared.saveFreeMyCalendar(true)
        } else {
            self.btnCheckbox.setImage(Images.checkBoxEmpty, for: .normal)
            self.lblFreeCalendar.textColor = AppColor.appGrayColor
            UserDefaultUtility.shared.saveFreeMyCalendar(false)
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        
        if let date = sender?.date {
            /// SAVING & SHOWING DATE
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormats.MMddyyyy // "MM-dd-yyyy"
            let strDate = dateFormatter.string(from: date)
            self.addDateBtn.setTitle(strDate, for: .normal)
            UserDefaultUtility.shared.saveDate(date: self.addDateBtn.title(for: .normal) ?? "")
            
            /// SENDING DATE TO API
            dateFormatter.dateFormat = DateFormats.yyyyMMdd // "yyyy-MM-dd"
            let strDate1 = dateFormatter.string(from: date)
            self.filterDelegate?.didSelectDate(date: strDate1)
            
            parentVC.presentedViewController?.dismiss(animated: true)
            self.uiDatePicker.isHidden.toggle()
        }
    }
}


