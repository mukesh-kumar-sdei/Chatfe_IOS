//
//  AllFriendsVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 22/06/22.
//

import UIKit

class AllFriendsVC: UIViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    @IBOutlet weak var lblNotFound: UILabel!

    // MARK: - ==== VARIABLEs ====
    var filteredFriendsArr = [ProfileData]()
    var friendsArr = [ProfileData]()
    
    var profileData = [FriendsProfileData]()
    var filteredProfileData = [FriendsProfileData]()
    
    var isSearchActive = false
    var isFriendsUserList = false
    
    
    // MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

//        hideKeyboardWhenTappedAround()
        friendsSearchBar.delegate = self
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        friendsCollectionView.register(UINib(nibName: FriendsCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: FriendsCollectionViewCell.className)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}


// MARK: - ==== COLLECTIONVIEW DATASOURCE & DELEGATE METHODs ====
extension AllFriendsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return friendsArr.count
        if isFriendsUserList {
            return (filteredProfileData.count > 0 && isSearchActive) ? filteredProfileData.count : profileData.count
        }
        return (filteredFriendsArr.count > 0 && isSearchActive) ? filteredFriendsArr.count : friendsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsCollectionViewCell.className, for: indexPath) as! FriendsCollectionViewCell
//        let friend = friendsArr[indexPath.row]
        if isFriendsUserList {
            let friend = (filteredProfileData.count > 0 && isSearchActive) ? filteredProfileData[indexPath.row] : profileData[indexPath.row]
            cell.friendsNameLbl.text = "\(friend.fname ?? "") \(friend.lname ?? "")"
            if let imageURL = URL(string: friend.profileImg?.image ?? "") {
                cell.friendsImageView.kf.setImage(with: imageURL)
            }
        } else {
            let friend = (filteredFriendsArr.count > 0 && isSearchActive) ? filteredFriendsArr[indexPath.row] : friendsArr[indexPath.row]
            cell.friendsNameLbl.text = "\(friend.fname ?? "") \(friend.lname ?? "")"
            if let imageURL = URL(string: friend.profileImg?.image ?? "") {
                cell.friendsImageView.kf.setImage(with: imageURL)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isFriendsUserList {
            let friend = (filteredFriendsArr.count > 0 && isSearchActive) ? filteredFriendsArr[indexPath.row] : friendsArr[indexPath.row]
            let friendsProfileVC = kHomeStoryboard.instantiateViewController(withIdentifier: FriendsProfileVC.className) as! FriendsProfileVC
            friendsProfileVC.userId = friend._id ?? ""
            friendsProfileVC.isFromMyProfile = true
            self.navigationController?.pushViewController(friendsProfileVC, animated: true)
        }
    }
    
    // FLOW LAYOUT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10
        return CGSize(width: width, height: 130.0)
//        return CGSize(width: 130.0, height: 130.0)
    }
    

}



// MARK: - ==== SEARCHBAR DELEGATE METHODs ====
extension AllFriendsVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
//            self.lblNotFound.text = "No Friends Found"
//            self.lblNotFound.isHidden = false
            clearSearchedData()
        } else {
            self.lblNotFound.text = ""
            self.lblNotFound.isHidden = true
            self.searchData(searchText: searchText)
        }
    }
    
    func searchData(searchText: String) {
        /// SEARCH DATA
        self.filteredFriendsArr = self.friendsArr.filter({($0.fname?.localizedCaseInsensitiveContains(searchText) ?? false) || ($0.lname?.localizedCaseInsensitiveContains(searchText) ?? false)})
        DispatchQueue.main.async {
            self.isSearchActive = self.filteredFriendsArr.count > 0 ? true : false
            self.friendsCollectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.clearSearchedData()
        searchBar.resignFirstResponder()
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.clearSearchedData()
        if let searchText = searchBar.text, searchText.count > 1 {
            self.searchData(searchText: searchText)
        }
        searchBar.resignFirstResponder()
    }
    
    func clearSearchedData() {
        DispatchQueue.main.async {
            self.isSearchActive = false
            self.filteredFriendsArr.removeAll()
            self.friendsCollectionView.reloadData()
        }
    }
}
