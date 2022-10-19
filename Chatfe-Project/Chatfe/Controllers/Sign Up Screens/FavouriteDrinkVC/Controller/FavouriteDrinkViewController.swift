//
//  FavouriteDrinkViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 22/04/22.
//

import UIKit
import Kingfisher

class FavouriteDrinkViewController: BaseViewController {
    var drinkArr: [FavouriteDrink] = []
   // var drinks: [String] = ["🥛", "🍼", 🫖, ☕️, 🍵, 🧃, 🥤, 🧋, 🍶, 🍺, 🍻, 🥂, 🍷, 🥃, 🍸, 🍹, 🧉, 🍾]
    var selectedDrinkId = ""
    
    lazy var favouriteDrinkViewModel: FavouriteDrinkViewModel = {
      let obj = FavouriteDrinkViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func selectDrinkBtnTapped(_ sender: UIButton) {
        if selectedDrinkId == "" {
            UIAlertController.showAlert(("ERROR", "Please select your favourite drink to continue."), sender: self, actions: AlertAction.Okk){ (action) in
                
            }
        } else {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "ProfilePictureViewController") as! ProfilePictureViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    @IBOutlet weak var favDrinkCollectionView: UICollectionView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        favDrinkCollectionView.delegate = self
        favDrinkCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        favDrinkCollectionView.register(UINib(nibName: "FavDrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FavDrinkCollectionViewCell")
        setupView()
        self.reloadListViewClosure()
    }
    
    func setupView() {
        favouriteDrinkViewModel.getAllDrinks()
    }
    
    func reloadListViewClosure() {
        favouriteDrinkViewModel.reloadListViewClosure = { [weak self] in
            if let favDrinks = self?.favouriteDrinkViewModel.favouriteDrinkResponse?.data {
                self?.drinkArr = favDrinks
            }
            DispatchQueue.main.async {
                self?.favDrinkCollectionView.reloadData()
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FavouriteDrinkViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinkArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavDrinkCollectionViewCell", for: indexPath) as! FavDrinkCollectionViewCell
        if let imageUrl = URL(string: drinkArr[indexPath.row].image ?? "") {
            cell.drinkImageView.kf.setImage(with: imageUrl)
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavDrinkCollectionViewCell", for: indexPath) as! FavDrinkCollectionViewCell
//        cell.drinkImageView.borderColor = UIColor(named: "TintColor")
//        cell.drinkImageView.borderWidth = 2
//        let selectedItem = drinkArr[indexPath.row]
//        UserDefaultUtility.shared.saveSelectedDrink(id: selectedItem._id ?? "")
//    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if let id = drinkArr[indexPath.row]._id {
                selectedDrinkId = id
                UserDefaultUtility.shared.saveSelectedDrink(id: selectedDrinkId)
            }
            if selectedItems.contains(indexPath) {
                
                collectionView.deselectItem(at: indexPath, animated: true)
                UserDefaultUtility.shared.saveSelectedDrink(id: "")
                return false
            }
        }
        return true
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
//        return collectionView.contentSize
//    }
    
    
}


