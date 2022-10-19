//
//  FriendsTableViewCell.swift
//  Chatfe
//
//  Created by Piyush Mohan on 12/05/22.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    static let identifier = "FriendsTableViewCell"
    
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblNoFriends: UILabel!
    
    var parentVC: BaseViewController!
    var isUsersFriends = false
    var friendsArr: [ProfileData]? {
        didSet {
            DispatchQueue.main.async {
                if self.friendsArr?.count == 0 {
                    self.lblNoFriends.isHidden = false
                } else {
                    self.lblNoFriends.isHidden = true
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    var usersFriends: [FriendsProfileData]? {
        didSet {
            DispatchQueue.main.async {
                if self.usersFriends?.count == 0 {
                    self.lblNoFriends.isHidden = false
                } else {
                    self.lblNoFriends.isHidden = true
                }
                self.collectionView.reloadData()
            }
        }
    }
    
//    let names = ["Harry", "Jim", "Boris"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblNoFriends.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.allowsSelection = true
        collectionView.register(UINib(nibName: "FriendsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendsCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension FriendsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isUsersFriends {
            return usersFriends?.count ?? 0 > 3 ? 3 : (usersFriends?.count ?? 0)
        } else {
            return friendsArr?.count ?? 0 > 3 ? 3 : (friendsArr?.count ?? 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCollectionViewCell", for: indexPath) as! FriendsCollectionViewCell
        
        if isUsersFriends {
            let friend = usersFriends?[indexPath.row]
            cell.friendsNameLbl.text = "\(friend?.fname ?? "") \(friend?.lname ?? "")"
            if let imageURL = URL(string: friend?.profileImg?.image ?? "") {
                cell.friendsImageView.kf.setImage(with: imageURL)
            }
        } else {
            let friend = friendsArr?[indexPath.row]
            cell.friendsNameLbl.text = "\(friend?.fname ?? "") \(friend?.lname ?? "")"
            if let imageURL = URL(string: friend?.profileImg?.image ?? "") {
                cell.friendsImageView.kf.setImage(with: imageURL)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let friendsProfileVC = kHomeStoryboard.instantiateViewController(withIdentifier: FriendsProfileVC.className) as! FriendsProfileVC
        friendsProfileVC.userId = friendsArr?[indexPath.row]._id ?? usersFriends?[indexPath.row]._id ?? ""
//            friendsProfileVC.isFromMyProfile = true
        self.parentVC.navigationController?.pushViewController(friendsProfileVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width / 3)
        return CGSize(width: width, height: 130.0)
    }
}


