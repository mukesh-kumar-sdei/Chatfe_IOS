//
//  MainTabBarController.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 27/05/22.
//

import UIKit
import Kingfisher

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        DispatchQueue.main.async {
            if let strImage = UserDefaultUtility.shared.getProfileImageURL(), strImage != "" {
                self.addSubviewToLastTabItem(strImage, isSelected: false)
            } else {
                if let fullname = UserDefaultUtility.shared.getFullName() {
                    self.addNameSubviewToLastTabItem(fullname, isSelected: false)
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 5 {
            if let strImage = UserDefaultUtility.shared.getProfileImageURL(), strImage != "" {
                self.addSubviewToLastTabItem(strImage, isSelected: true)
            } else {
                if let fullname = UserDefaultUtility.shared.getFullName() {
                    self.addNameSubviewToLastTabItem(fullname, isSelected: true)
                }
            }
        } else {
            if let strImage = UserDefaultUtility.shared.getProfileImageURL(), strImage != "" {
                self.addSubviewToLastTabItem(strImage, isSelected: false)
            } else {
                if let fullname = UserDefaultUtility.shared.getFullName() {
                    self.addNameSubviewToLastTabItem(fullname, isSelected: false)
                }
            }
        }
    }
    
    
}

extension UITabBarController {
    
    func addSubviewToLastTabItem(_ strImage: String, isSelected: Bool) {
        
        if let lastTabBarButton = self.tabBar.subviews.last, let tabItemImageView = lastTabBarButton.subviews.first {
            if let accountTabBarItem = self.tabBar.items?.last {
                accountTabBarItem.selectedImage = nil
                accountTabBarItem.image = nil
            }
            let imgView = UIImageView()
//            imgView.frame = tabItemImageView.frame
//            imgView.frame.size.height = 35.0
//            imgView.frame.size.width = 35.0
//            imgView.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            imgView.frame = CGRect(x: 15, y: 6, width: 35.0, height: 35.0)
//            imgView.frame = CGRect(x: tabItemImageView.bounds.midX, y: tabItemImageView.frame.midY, width: 35.0, height: 35.0)
//            imgView.center = tabItemImageView.center
            imgView.layer.cornerRadius = imgView.frame.height/2 // tabItemImageView.frame.height/2
            imgView.layer.masksToBounds = true
            if isSelected {
                imgView.layer.borderWidth = 2.0
                imgView.layer.borderColor = AppColor.appBlueColor.cgColor
            } else {
                imgView.layer.borderWidth = 0.0
                imgView.layer.borderColor = UIColor.clear.cgColor
            }
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
//            imgView.image = image
            let imageURL = URL(string: strImage)
            imgView.kf.setImage(with: imageURL)
            self.tabBar.subviews.last?.addSubview(imgView)
        }
    }
    
    func addNameSubviewToLastTabItem(_ fullname: String, isSelected: Bool) {
        
        if let lastTabBarButton = self.tabBar.subviews.last, let tabItemImageView = lastTabBarButton.subviews.first {
            if let accountTabBarItem = self.tabBar.items?.last {
                accountTabBarItem.selectedImage = nil
                accountTabBarItem.image = nil
            }
            let imgView = UIImageView()
//            imgView.frame = tabItemImageView.frame
//            imgView.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            imgView.frame = CGRect(x: 15, y: 6, width: 35.0, height: 35.0)
//            imgView.center = tabItemImageView.center
            imgView.layer.cornerRadius = imgView.frame.height/2 // tabItemImageView.frame.height/2
            imgView.layer.masksToBounds = true
            if isSelected {
                imgView.layer.borderWidth = 2.0
                imgView.layer.borderColor = AppColor.appBlueColor.cgColor
            } else {
                imgView.layer.borderWidth = 0.0
                imgView.layer.borderColor = UIColor.clear.cgColor
            }
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
//            imgView.image = image
            
            let attributedFont = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                  NSAttributedString.Key.font: UIFont(name: AppFont.ProximaNovaBold, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)]
            imgView.setImage(string: fullname, circular: true, textAttributes: attributedFont)
            
            self.tabBar.subviews.last?.addSubview(imgView)
        }
    }

}


extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        /*if viewController is SearchViewController {
            viewController.viewDidLoad()
        }*/
    }
}
