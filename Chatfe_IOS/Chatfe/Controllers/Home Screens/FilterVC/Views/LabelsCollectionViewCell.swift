//
//  LabelsCollectionViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 13/05/22.
//

import UIKit

class LabelsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    static let identifier = "LabelsCollectionViewCell"
    @IBOutlet weak var filterLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setSelectedUI()
            } else {
                setUnselectedUI()
            }
        }
    }
    
    func setSelectedUI() {
        debugPrint("Cell is Selected")
        borderColor = UIColor.systemTeal
        borderWidth = 2
        cornerRadius = 8
        clipsToBounds = true
    }
    
    func setUnselectedUI() {
        borderColor = .clear
    }

}
