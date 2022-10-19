//
//  UIButton+Extension.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 08/07/22.
//

import Foundation
import UIKit


extension UIButton {
    
    func addRightIcon(image: UIImage?, status: Bool) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        if status {
            addSubview(imageView)

            let length = CGFloat(15)
            titleEdgeInsets.right += length

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 10),
                imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
                imageView.widthAnchor.constraint(equalToConstant: length),
                imageView.heightAnchor.constraint(equalToConstant: 10)
            ])
        } else {
            imageView.removeFromSuperview()
        }
    }
    
}
