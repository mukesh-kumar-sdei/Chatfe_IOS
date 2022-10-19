//
//  MyAlert.swift
//  Chatfe
//
//  Created by Piyush Mohan on 04/05/22.
//

import Foundation
import UIKit

class MyAlert {
    struct AlertConstants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        return alert
    }()
    
    func showAlert(with title: String, message: String, on viewController: UIViewController) {
        guard let targetView = viewController.view else {
            return
        }
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        let myView = ChooseRoomTypeView.instanceFromNib()
        targetView.addSubview(myView)
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = AlertConstants.backgroundAlphaTo
        })
    }
    
    func dismissAlert() {
        
    }
}
