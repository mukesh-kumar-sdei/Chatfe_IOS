//
//  DrinkLabelCollectionViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 25/05/22.
//

import UIKit
import Kingfisher

class DrinkLabelCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DrinkLabelCollectionViewCell"
    var imageUrl = ""
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    func setupImage(imageUrl: String) {
        let imageURL = URL(string: imageUrl)
        self.drinkImageView.kf.setImage(with: imageURL)
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                UIView.animate(withDuration: 0.3) {
                    self.containerView.backgroundColor = AppColor.appGrayColor
//                    self.containerView.borderColor = UIColor(named: "TintColor")
//                    self.containerView.borderWidth = 2
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.containerView.backgroundColor = .clear
                    self.containerView.borderColor = AppColor.appGrayColor
                    self.containerView.borderWidth = 1
                }
            }
        }
    }
    
}
