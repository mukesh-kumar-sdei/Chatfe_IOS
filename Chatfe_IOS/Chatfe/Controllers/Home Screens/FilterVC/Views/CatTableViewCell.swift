//
//  CatTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 13/05/22.
//

import UIKit

class CatTableViewCell: UITableViewCell {
   static let identifier = "CatTableViewCell"
let catArr = ["One", "Two", "Three", "Four"]
    var mLastSelectedIndex = -1
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: LabelsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: LabelsCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CatTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelsCollectionViewCell.identifier, for: indexPath) as! LabelsCollectionViewCell
        cell.filterLbl.text = catArr[indexPath.row]
        if mLastSelectedIndex == indexPath.row {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let customCell = cell as! LabelsCollectionViewCell
        if customCell.isSelected {
            customCell.contentView.backgroundColor = UIColor(named: "TintColor")
        } else {
            customCell.contentView.backgroundColor = UIColor(named: "AccentColor")
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        debugPrint("The Selected Cell is at \(indexPath.row)")
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelsCollectionViewCell.identifier, for: indexPath) as! LabelsCollectionViewCell
//        cell.backView.layer.backgroundColor = UIColor(named: "TintColor")?.cgColor
//        cell.isSelected = true
//        
//        guard mLastSelectedIndex != indexPath.row else {
//            return
//        }
//        let indexpath = IndexPath(row: mLastSelectedIndex, section: 0)
//        collectionView.cellForItem(at: indexpath)?.isSelected = !collectionView.cellForItem(at: indexpath)!.isSelected
//        mLastSelectedIndex = indexPath.row
//    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            }
        }
        return true
    }
    
}
