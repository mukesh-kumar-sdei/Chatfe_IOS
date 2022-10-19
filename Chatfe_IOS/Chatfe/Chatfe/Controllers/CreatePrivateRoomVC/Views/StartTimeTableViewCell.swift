//
//  StartTimeTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 10/05/22.
//

import UIKit

class StartTimeTableViewCell: UITableViewCell {
    
    static let identifier = "StartTimeTableViewCell"
    let timeArr = ["12 AM", "1 AM", "2 AM" , "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
    weak var delegate: TimeSelectDelegate?
    weak var publicDelegate: PublicTimeSelectDelegate?
    weak var filterDelegate: StartTimeDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        // Initialization code
    }

    func registerCell() {
        self.collectionView.register(UINib(nibName: "FiltersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FiltersCollectionViewCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
       // self.addSubview(collectionView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension StartTimeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiltersCollectionViewCell", for: indexPath) as! FiltersCollectionViewCell
        cell.filterLbl.text = timeArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FiltersCollectionViewCell
        cell.collView.layer.cornerRadius = 20
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            delegate?.didSelectTime(time: timeArr[indexPath.row])
            publicDelegate?.didSelectPublicTime(time: timeArr[indexPath.row])
            filterDelegate?.didStartTime(time: timeArr[indexPath.row])
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            }
        }
        return true
    }
    
    
}
