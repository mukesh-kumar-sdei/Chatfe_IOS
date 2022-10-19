//
//  UITextField+Extension.swift
//  Chatfe
//
//  Created by Piyush Mohan on 04/04/22.
//

import Foundation
import UIKit

extension UITextField {
    
    //MARK:- Set Image on the right of text fields
    func setupRightImage(image: UIImage?) {
        let imageView = UIImageView(frame: CGRect(x: 8, y: 2, width: 15, height: 10))
        imageView.image = image
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 10))
        imageContainerView.addSubview(imageView)
        rightView = imageContainerView
        rightViewMode = .always
    }
}
