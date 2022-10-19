//
//  SortByTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 13/05/22.
//

import UIKit

class SortByTableViewCell: UITableViewCell {
    
    static let identifier = "SortByTableViewCell"
    
    @IBOutlet weak var sortCollectionView: UICollectionView!
    
    
    let sortBy = ["Alphabetical(A-Z)", "Earliest to Latest", "Latest to Earliest", "Popularity"]
    var selectedSortStyle = ""
    weak var delegate: SortByDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sortCollectionView.delegate = self
        sortCollectionView.dataSource = self
        sortCollectionView.register(UINib(nibName: FiltersCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: FiltersCollectionViewCell.className)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SortByTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortBy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersCollectionViewCell.className, for: indexPath) as! FiltersCollectionViewCell
        cell.filterLbl.text = sortBy[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            self.selectedSortStyle = sortBy[indexPath.row]
            delegate?.didSort(selectedSort: self.selectedSortStyle)
            debugPrint(selectedSortStyle)
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            }
        }
        return true
    }
    
}
