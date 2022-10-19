//
//  EditDrinkTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 26/05/22.
//

import UIKit

class EditDrinkTableViewCell: UITableViewCell {
    
    static let identifier = "EditDrinkTableViewCell"
    var editDrinkDelegate: EditProfileNameDelegate?
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var drinkButton: UIButton!
    
    
    var selectedDrinkId = ""
    var parentVC: BaseViewController!
    var editDrink = false
    var selectedIndexPath: IndexPath?
    
    var drinkArr: [FavouriteDrink]! {
        didSet {
            self.collView.reloadData()
        }
    }
    
    lazy var profilePageViewModel: ProfilePageViewModel = {
        let obj = ProfilePageViewModel(userService: UserService())
        self.parentVC.baseVwModel = obj
        return obj
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerNIBs()
        initialSetup()
    }
    
    func registerNIBs() {
        collView.register(UINib(nibName: DrinkLabelCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DrinkLabelCollectionViewCell.identifier)
    }
    
    func initialSetup() {
        collView.delegate = self
        collView.dataSource = self
        if editDrink == false {
            self.editBtn.isHidden = false
            self.saveBtn.isHidden = true
            self.collView.isHidden = true
        } else {
            self.editBtn.isHidden = true
            self.saveBtn.isHidden = false
            self.saveBtn.setTitleColor(.white, for: .normal)
            self.collView.isHidden = false
        }
    }
    
    func setupClosure() {
        profilePageViewModel.reloadListViewClosure = { [weak self] in
            if self?.profilePageViewModel.updateProfileResponse?.status == "SUCCESS" {
                DispatchQueue.main.async {
//                    self?.parentVC.showBaseAlert(self?.profilePageViewModel.updateProfileResponse?.data ?? "")
                    self?.editDrinkDelegate?.setDrink(to: false)
                }
            }  else if self?.profilePageViewModel.updateProfileErrorResponse?.status == "ERROR" {
                DispatchQueue.main.async {
                    self?.parentVC.showBaseAlert(self?.profilePageViewModel.updateProfileErrorResponse?.message ?? "")
                    self?.editDrinkDelegate?.setDrink(to: false)
                }
            }
        }
    }
    
    func showDrinkImage(image: String?) {
        if let strImageUrl = image {
            let imageURL = URL(string: strImageUrl)
            self.drinkImage.kf.setImage(with: imageURL)
        }
//        let drinkURL = URL(string: image)
//        self.drinkImageView.kf.setImage(with: drinkURL)
    }
    
    @IBAction func drinkBtnTapped(_ sender: UIButton) {
        if editDrink != false {
            self.editDrink.toggle()
            self.editBtn.isHidden = false
            self.saveBtn.isHidden = true
            self.collView.isHidden = true
        } else {
            self.editDrink.toggle()
            self.editBtn.isHidden = true
            self.saveBtn.isHidden = false
            self.saveBtn.setTitleColor(.white, for: .normal)
            self.collView.isHidden = false
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        if editDrink == false {
            self.editDrink.toggle()
            self.editBtn.isHidden = true
            self.saveBtn.isHidden = false
            self.collView.isHidden = false
        } else {
            if UserDefaultUtility.shared.getSelectedDrink() == "" {
                self.parentVC.showBaseAlert("Please choose your favorite drink.")
            } else {
                self.editDrink.toggle()
                self.editBtn.isHidden = false
                self.saveBtn.isHidden = true
                self.collView.isHidden = true
                let params = ["drink": UserDefaultUtility.shared.getSelectedDrink() ?? ""] as [String:Any]
                profilePageViewModel.updateProfile(params: params)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension EditDrinkTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        debugPrint("No of drinks are ", drinkArr.count)
        return drinkArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrinkLabelCollectionViewCell.identifier, for: indexPath) as! DrinkLabelCollectionViewCell
//        debugPrint("Nmae of the drink is ", drinkArr[indexPath.row].drinkName)
        if let url = drinkArr[indexPath.row].image {
//            debugPrint("The url is ", url)
            cell.imageUrl = url
            cell.setupImage(imageUrl: url)
        }
        
        cell.drinkLabel.text = drinkArr[indexPath.row].drinkName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        debugPrint("The selected Index = ", selectedIndexPath)
        if selectedDrinkId == drinkArr[indexPath.row]._id {
            cell.isSelected = true
            UserDefaultUtility.shared.saveSelectedDrink(id: selectedDrinkId)
        } else {
            cell.isSelected = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
           
            if let id = drinkArr[indexPath.row]._id {
               // self.selectedDrinkId = ""
                self.selectedDrinkId = id
                UserDefaultUtility.shared.saveSelectedDrink(id: selectedDrinkId)
            }
            // Deselect the previously selected cell...
            for cell in collectionView.visibleCells as [UICollectionViewCell] {
                cell.isSelected = false
            }
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
               // self.selectedDrinkId = ""
                UserDefaultUtility.shared.saveSelectedDrink(id: "")
                return false
            }
        }
        return true
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrinkLabelCollectionViewCell.identifier, for: indexPath) as? DrinkLabelCollectionViewCell
        let width = cell?.drinkLabel.frame.size.width ?? 0.0
        return CGSize(width: width, height: 40.0)
    }*/
    
    
}
