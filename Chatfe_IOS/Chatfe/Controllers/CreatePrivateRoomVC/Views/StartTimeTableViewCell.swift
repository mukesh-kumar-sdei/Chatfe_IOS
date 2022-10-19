//
//  StartTimeTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 10/05/22.
//

import UIKit

class StartTimeTableViewCell: UITableViewCell {
    
    static let identifier = "StartTimeTableViewCell"
    
//    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView: InfiniteCollectionView!
    
    weak var delegate: TimeSelectDelegate?
    weak var publicDelegate: PublicTimeSelectDelegate?
    weak var filterDelegate: StartTimeDelegate?
    var selectedIndexPath = IndexPath()
    var selectedRow: Int?
    var isEditRoom = false
    
    var timeArr = ["12AM", "12:30AM", "1AM", "01:30AM", "2AM", "02:30AM", "3AM", "03:30AM", "4AM", "04:30AM", "5AM", "05:30AM", "6AM", "06:30AM", "7AM", "07:30AM", "8AM", "08:30AM", "9AM", "09:30AM", "10AM", "10:30AM", "11AM", "11:30AM", "12PM", "12:30PM", "1PM", "01:30PM", "2PM", "02:30PM", "3PM", "03:30PM", "4PM", "04:30PM", "5PM", "05:30PM", "6PM", "06:30PM", "7PM", "07:30PM", "8PM", "08:30PM", "9PM", "09:30PM", "10PM", "10:30PM", "11PM", "11:30PM"]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCell()
        
        DispatchQueue.main.async {
            if self.isEditRoom {
                if let row = self.selectedRow {
                    let selectedTime = self.timeArr[row]
                    UserDefaultUtility.shared.saveStartTime(time: selectedTime)
                }
            }
        }
    }

    func registerCell() {
        self.collectionView.register(UINib(nibName: FiltersCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: FiltersCollectionViewCell.className)
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
        self.collectionView.infiniteDataSource = self
        self.collectionView.infiniteDelegate = self
       // self.addSubview(collectionView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
/*
extension StartTimeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return Int.max
        return timeArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersCollectionViewCell.className, for: indexPath) as! FiltersCollectionViewCell
//        cell.filterLbl.text = timeArr[indexPath.row % timeArr.count]
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
    
    /*func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == timeArr.count - 1 { // This is last cell
            self.timeArr.append(contentsOf: timeArr)
            self.collectionView.reloadItems(at: [indexPath])
        } else if indexPath.row == 0 {
            
        }
    }*/
}


extension StartTimeTableViewCell: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.isEditRoom {
            DispatchQueue.main.async {
                self.selectedIndexPath = IndexPath(row: self.selectedRow ?? 0, section: 0)
                collectionView.selectItem(at: self.selectedIndexPath, animated: false, scrollPosition: [])
            }
        }
    }
}
*/

extension StartTimeTableViewCell: InfiniteCollectionViewDelegate, InfiniteCollectionViewDataSource {
    
    func numberOfItems(_ collectionView: UICollectionView) -> Int {
        return timeArr.count
    }
    
    func cellForItemAtIndexPath(_ collectionView: UICollectionView, dequeueIndexPath: IndexPath, usableIndexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersCollectionViewCell.className, for: dequeueIndexPath) as! FiltersCollectionViewCell
        cell.filterLbl.text = timeArr[usableIndexPath.row]

        if usableIndexPath.row == selectedRow && self.isEditRoom {
            cell.collView.backgroundColor = AppColor.selectedMenuBGColor
            cell.filterLbl.textColor = AppColor.appBlueColor
            cell.collView.layer.cornerRadius = 20.0
        } else {
            cell.filterLbl.textColor = UIColor.white
            cell.collView.backgroundColor = AppColor.accentColor
        }
        
        return cell
    }
    
    func didSelectCellAtIndexPath(_ collectionView: UICollectionView, usableIndexPath: IndexPath) {

        if isEditRoom {
            self.selectedRow = usableIndexPath.row
            self.collectionView.reloadData()
        }
        
        self.selectedIndexPath = usableIndexPath
        
        let selectedTime = timeArr[usableIndexPath.row]
        delegate?.didSelectTime(time: selectedTime)
        publicDelegate?.didSelectPublicTime(time: selectedTime)
        filterDelegate?.didStartTime(time: selectedTime)
    }
    

}
