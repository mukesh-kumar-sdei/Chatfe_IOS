//
//  PickerViewBottomVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 11/10/22.
//

import UIKit

protocol CustomPickerViewDelegate : AnyObject {
    func didSelectPickerValue(row: Int)
}

class PickerViewBottomVC: UIViewController {

    public weak var pickerDelegate: CustomPickerViewDelegate?
    
    @IBOutlet weak var customPickerView: UIPickerView!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    var matchPref = [MatchPrefOptions.Match_More, MatchPrefOptions.Match_Less, MatchPrefOptions.Match_Never]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configPickerView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configPickerView() {
        self.customPickerView.dataSource = self
        self.customPickerView.delegate = self

        customPickerView.backgroundColor = AppColor.accentColor
        customPickerView.setValue(UIColor.white, forKey: "textColor")

    }
    
    @IBAction func btnDoneAction(_ sender: UIBarButtonItem) {
        let row = self.customPickerView.selectedRow(inComponent: 0)
        self.customPickerView.selectRow(row, inComponent: 0, animated: false)
        pickerDelegate?.didSelectPickerValue(row: row)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnCancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - ==== PICKERVIEW DATASOURCE & DELEGATE METHODs ====
extension PickerViewBottomVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return matchPref.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return matchPref[row]
    }
    
}
