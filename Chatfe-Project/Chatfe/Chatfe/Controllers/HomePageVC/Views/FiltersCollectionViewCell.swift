//
//  FiltersCollectionViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 02/05/22.
//

import UIKit
protocol FilterCellDelegate: class {
    func didSelectCell(selectedFilter: CategoriesData)
}

class FiltersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collView: UIView!
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var filterArr: [CategoriesData] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var selectedCell = false
    weak var delegate: FilterCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedAction))
//        self.collView.addGestureRecognizer(tapGesture)
        
        
    }
    
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                UIView.animate(withDuration: 0.3) {
//                    self.collView.backgroundColor = UIColor(named: "TintColor")
                    self.collView.backgroundColor = UIColor(named: "SelectedMenuBGColor")
                    self.filterLbl.textColor = AppColor.appBlueColor
//                    self.collView.cornerRadius = 30
                    self.collView.cornerRadius = 20
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.collView.backgroundColor = UIColor(named: "AccentColor")
                    self.filterLbl.textColor = UIColor.white
//                    self.collView.cornerRadius = 30
                    self.collView.cornerRadius = 20
                }
            }
        }
    }
    
    @objc func tappedAction() {
//        if selectedCell {
//            selectedCell.toggle()
//        } else {
//            self.collView.backgroundColor = .red
//            self.filterLbl.textColor = .white
//        }
        if self.isSelected {
            self.isSelected = false
        } else {
            self.isSelected = true
        }
        
    }
    
//    override func prepareForReuse() {
//        if selectedCell {
//            debugPrint("True")
//            self.collView.backgroundColor = .red
//        } else {
//            debugPrint("False")
//            self.collView.backgroundColor = .clear
//        }
        
//        self.isSelected = false
        
//    }

}

extension FiltersCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("Cell Selected")
        let selectedFilter = self.filterArr[indexPath.row]
        self.delegate?.didSelectCell(selectedFilter: selectedFilter)
    }
}
