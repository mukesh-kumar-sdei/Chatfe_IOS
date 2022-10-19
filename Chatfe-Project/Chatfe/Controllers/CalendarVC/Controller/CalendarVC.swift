//
//  CalendarVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 28/05/22.
//

import UIKit


class CalendarVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var txtMonths: UITextField!
    @IBOutlet weak var lblBadge: UILabel!
    
    lazy var homePageViewModel: HomePageViewModel = {
        let obj = HomePageViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    // MARK: - ==== VARIABLEs ====
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    private let pickerView = MonthPickerView()
    var matchedIndex = 0
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.lblBadge.layer.masksToBounds = true
        self.lblBadge.cornerRadius = 8.5
//        self.lblBadge.isHidden = true
//        self.txtMonths.delegate = self
        self.txtMonths.isMultipleTouchEnabled = false
        self.txtMonths.setupRightImage(image: Images.downArrow)
        self.setupMonthsPickerView()
        self.setupClosure()
        NotificationCenter.default.addObserver(self, selector: #selector(changedAppleCalendarMonth(_:)), name: Notification.Name.APPLE_CALENDAR_MONTH_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationCount(_:)), name: Notification.Name.PUSH_NOTIFICATION_COUNT, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationCount(_:)), name: Notification.Name("HOME_NOTIFICATION_TAPPED"), object: nil)
    }
    
    @objc func updateNotificationCount(_ notification: Notification) {
        if let count = notification.object as? Int {
            DispatchQueue.main.async {
                if count == 0 {
                    self.lblBadge.backgroundColor = .clear
                    self.lblBadge.text = ""
                }else{
                    self.lblBadge.backgroundColor = .red
                    self.lblBadge.text = "\(count)"
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.homePageViewModel.getJoinedRooms()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func setupClosure() {
        homePageViewModel.reloadMenuClosure1 = {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name.CALENDAR_RELOAD, object: nil)
            }
        }
    }
    
    func setupMonthsPickerView() {
        self.txtMonths.text = Date().currentMonth
        self.txtMonths.tintColor = .clear
        self.txtMonths.inputView = pickerView
        self.txtMonths.inputAccessoryView = pickerView.toolbar
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.toolbarDelegate = self
        pickerView.backgroundColor = AppColor.accentColor
        pickerView.setValue(UIColor.white, forKey: "textColor")
        pickerView.toolbar?.backgroundColor = AppColor.accentColor
        guard let matchedIndex = months.firstIndex(of: Date().currentMonth) else { return }
        self.matchedIndex = matchedIndex
        pickerView.selectRow(matchedIndex, inComponent: 0, animated: false)
        pickerView.reloadAllComponents()
    }
    
    /// HANDLE TEXTFIELD MONTH UPDATE ON SWIPE OF CALENDAR
    @objc func changedAppleCalendarMonth(_ notification: Notification) {
        DispatchQueue.main.async {
            if let row = notification.object as? Int {
                self.txtMonths.text = self.months[row-1]
                self.pickerView.selectRow(row-1, inComponent: 0, animated: false)
                self.pickerView.reloadAllComponents()
            }
        }
    }
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func notificationsClicked(_ sender: UIButton) {
        let notificationActivityVC = kHomeStoryboard.instantiateViewController(withIdentifier: NotificationsActivityVC.className) as! NotificationsActivityVC
        self.navigationController?.pushViewController(notificationActivityVC, animated: true)
    }
}


// MARK: - ==== PICKERVIEW DATASOURCE & DELEGATE METHODs ====
extension CalendarVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return months.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return months[row]
    }
    
}


// MARK: - ==== KEYBOARD TOOLBAR HANDLER METHODs ====
extension CalendarVC: ToolbarPickerViewDelegate {

    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.txtMonths.text = self.months[row]
        NotificationCenter.default.post(name: Notification.Name.MonthChanged, object: row - matchedIndex)
        self.txtMonths.resignFirstResponder()
    }

    func didTapCancel() {
        self.txtMonths.resignFirstResponder()
    }
    
}

/*
// MARK: - ==== TEXTFIELD DELEGATE METHOD ====
extension CalendarVC: UITextFieldDelegate {
    // TO DISABLE DOUBLE TAP ON TEXTFIELD
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
*/


