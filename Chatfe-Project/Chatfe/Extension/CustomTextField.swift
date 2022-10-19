//
//  CustomTextField.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 17/05/22.
//

import Foundation
import UIKit


class CustomTextField: UITextField {
    
    @IBInspectable var maxLength: Int = 30
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
        setUpTextfield()
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTextfield()
    }
    
    func setUpTextfield(){
        self.borderStyle = .none
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : AppColor.textFieldPlaceholderColor])
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: [NSAttributedString.Key.font : UIFont(name: AppFont.ProximaNovaMedium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .medium)])
        self.backgroundColor = AppColor.textFieldBackgroundColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        self.addPaddingToLeft(padding: 15)
        self.addPaddingToRight(padding: 10)
        self.rightView?.isHidden = true
    }
    
    func addPaddingToLeft(padding: CGFloat) {
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: 0, width: Int(padding), height: Int(padding))
        view.contentMode = .left
        self.leftView = view
        self.leftView?.frame.size = CGSize(width: view.frame.size.width + padding, height: view.frame.size.height)
        self.leftViewMode = .always
    }
    
    func addPaddingToRight(padding: CGFloat) {
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: 0, width: Int(padding), height: Int(padding))
        view.contentMode = .right
        self.rightView = view
        self.rightView?.frame.size = CGSize(width: view.frame.size.width + padding, height: view.frame.size.height)
        self.rightViewMode = .always
    }
}


extension CustomTextField: UITextFieldDelegate {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10))
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += 15
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x += 15
        return textRect
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < maxLength
    }
}
