//
//  CategoryTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 10/05/22.
//



import UIKit
import SwiftUI

class CategoryTableViewCell: UITableViewCell {
    
    static let identifier = "CategoryTableViewCell"
    
    weak var filterDelegate: SelectCategoryDelegate?
    weak var delegate: CategorySelectDelegate?
    weak var publicDelegate: PublicCategorySelectDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories: [CategoriesData] = []
    var selectedIndexPath: IndexPath?
    var selectedRow: Int?
    var selectedCategoryId = ""
    var selectedCategory = ""
    var isEditRoom = false
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: FiltersCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: FiltersCollectionViewCell.className)
        collectionView.delegate = self
        collectionView.dataSource = self
        
       // setupFlowLayout()
    }
    
    func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        
//        flowLayout.scrollDirection = .horizontal
//        flowLayout.itemSize = CGSize(width: 150, height: collectionView.bounds.height)
//        flowLayout.minimumLineSpacing = 2.0
//        flowLayout.minimumInteritemSpacing = 5.0
//        self.collectionView.frame = self.bounds
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.showsHorizontalScrollIndicator = false
        //self.addSubview(collectionView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        debugPrint("The no of categories are: ", categories.count)
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let row = categories.firstIndex(where: {$0.title == "All"}) {
            if row == 0 && selectedIndexPath == nil {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersCollectionViewCell.className, for: indexPath) as! FiltersCollectionViewCell
        cell.filterLbl.text = categories[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let cell = collectionView.cellForItem(at: indexPath) as! FiltersCollectionViewCell
//        cell.collView.layer.cornerRadius = 30
        cell.collView.layer.cornerRadius = 20
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            
            if let id = categories[indexPath.row]._id {
                selectedCategoryId = id
            }
            if let title = categories[indexPath.row].title {
                selectedCategory = title
            }
            delegate?.didSelect(selectedCat: categories[indexPath.row])
            publicDelegate?.didSelectPublicCategory(selectedCat: categories[indexPath.row])
//            filterDelegate?.didSelectCategory(selected: selectedCategoryId)
            filterDelegate?.didSelectCategory(selected: categories[indexPath.row])
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            }
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if self.isEditRoom {
                let selectedIndexPath = IndexPath(row: self.selectedRow ?? 0, section: 0)
                collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
                if let id = self.categories[selectedIndexPath.row]._id, let title = self.categories[selectedIndexPath.row].title {
//                    UserDefaultUtility.shared.saveCategoryId(id: id)
                    UserDefaultUtility.shared.saveCategoryIdName(id: id, name: title)
                }
            }
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let attributedFont = [NSAttributedString.Key.font : UIFont(name: AppFont.ProximaNovaBold, size: 16.0) ?? UIFont.boldSystemFont(ofSize: 16.0)]
//        let customWidth = ((categories[indexPath.row].title ?? "") as NSString).size(withAttributes: attributedFont).width
//        return CGSize(width: customWidth, height: 40.0)
        
//        return ((categories[indexPath.row].title ?? "") as NSString).size(withAttributes: attributedFont)
//    }
    
}

extension CategoryTableViewCell: FilterCellDelegate {
    func didSelectCell(selectedFilter: CategoriesData) {
//        debugPrint("Selected Category Title is \(selectedFilter.title)")
    }
    
    
}


