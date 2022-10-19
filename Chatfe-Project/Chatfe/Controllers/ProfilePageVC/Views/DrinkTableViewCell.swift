//
//  DrinkTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 12/05/22.
//

import UIKit
import Kingfisher

class DrinkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkLbl: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var collView: UICollectionView!
    
    static let identifier = "DrinkTableViewCell"
    var imageUrl = ""
    var drinksArr: [FavouriteDrink]! {
        didSet {
            self.collView.reloadData()
        }
    }
    var editDrinkDelegate: EditProfileNameDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }
    
    func registerCell() {
        self.collView.register(UINib(nibName: "DrinkLabelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DrinkLabelCollectionViewCell")
    }
    
    func showDrinkImage(image: String?) {
        if let strImageUrl = image {
            let imageURL = URL(string: strImageUrl)
            self.drinkImageView.kf.setImage(with: imageURL)
        }
//        let drinkURL = URL(string: image)
//        self.drinkImageView.kf.setImage(with: drinkURL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editBtnTapped(_ sender: UIButton) {
        debugPrint("Tapped!")
        self.editDrinkDelegate?.setDrink(to: true)
    }
}

extension DrinkTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.drinksArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrinkLabelCollectionViewCell", for: indexPath) as! DrinkLabelCollectionViewCell
        cell.imageUrl = self.drinksArr[indexPath.row].image ?? ""
        cell.drinkLabel.text = self.drinksArr[indexPath.row].drinkName
        return cell
    }
    
    
}
