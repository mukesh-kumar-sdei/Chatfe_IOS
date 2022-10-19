//
//  DateTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 10/05/22.
//

import UIKit

class DateTableViewCell: UITableViewCell {
    
    static let identifier = "DateTableViewCell"
    
    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var uiDatePicker: UIDatePicker!
    @IBOutlet weak var addDateBtn: UIButton!
    
    // MARK: - ==== VARIABLEs ====
    var datePicker = UIDatePicker()
    var toolbar = UIToolbar()
    var parentVC : BaseViewController!

    
    // MARK: - ==== CELL LIFECYCLE ====
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// SAVING & SHOWING DATE
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.MMddyyyy // "MM-dd-yyyy"
        let strDate = dateFormatter.string(from: Date())
        self.addDateBtn.setTitle(strDate, for: .normal)
        UserDefaultUtility.shared.saveDate(date: self.addDateBtn.title(for: .normal) ?? "")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func addDateBtnTapped(_ sender: UIButton) {
        self.uiDatePicker.isHidden.toggle()
        self.uiDatePicker.datePickerMode = .date
        //self.uiDatePicker.preferredDatePickerStyle = .compact
        self.uiDatePicker.backgroundColor = .white
        self.uiDatePicker.minimumDate = Date()
        self.uiDatePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 6, to: Date())
        self.uiDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    // MARK: - ==== HELPER METHODs ====
    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        
        if let date = sender?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormats.MMddyyyy // "MM-dd-yyyy"
            self.addDateBtn.setTitle(dateFormatter.string(from: date), for: .normal)
            UserDefaultUtility.shared.saveDate(date: self.addDateBtn.title(for: .normal) ?? "")
            /*dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let eventDate = dateFormatter.string(from: date)
            UserDefaultUtility.shared.saveDate(date: eventDate)*/
            parentVC.presentedViewController?.dismiss(animated: true)
            self.uiDatePicker.isHidden.toggle()
        }
    }
    
}


