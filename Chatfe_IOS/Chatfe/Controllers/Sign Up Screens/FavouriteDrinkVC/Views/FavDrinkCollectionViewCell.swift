//
//  FavDrinkCollectionViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 02/05/22.
//

import UIKit

class FavDrinkCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var drinkImageView: UIImageView!
    
    var selectedCell = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        drinkImageView.clipsToBounds = true
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                UIView.animate(withDuration: 0.3) {
                    self.containerView.borderColor = UIColor(named: "TintColor")
                    self.containerView.borderWidth = 2
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.containerView.borderColor = .white
                    self.containerView.borderWidth = 0
                }
            }
        }
    }

}
