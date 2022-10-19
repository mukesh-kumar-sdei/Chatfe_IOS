//
//  BlockListVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 26/07/22.
//

import UIKit

class BlockListVC: BaseViewController {

    // MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var blockUserTableView: UITableView!
    @IBOutlet weak var lblNotFound: UILabel!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    
    lazy var viewModel: BlockListVM = {
        let obj = BlockListVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var blockListArr = [GetBlockListData]()
    var filteredBlockListArr = [GetBlockListData]()
    var isSearchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblNotFound.isHidden = true
        userSearchBar.delegate = self
        searchBarHeight.constant = 0.0
        blockUserTableView.dataSource = self
        blockUserTableView.delegate = self
        registerNIBs()
//        self.viewModel.getblockUserList()
        setupClosure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.getblockUserList()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - ==== CUSTOM METHODs ====
    func registerNIBs() {
        blockUserTableView.register(UINib(nibName: BlockListCell.className, bundle: nil), forCellReuseIdentifier: BlockListCell.className)
    }
    
    func setupClosure() {
        // GET BLOCK LIST RESPONSE
        viewModel.redirectControllerClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                // GET MODEL DATA
                self.blockListArr = self.viewModel.getBlockListResp?.data ?? []
                if self.blockListArr.count > 0 {
                    self.lblNotFound.text = ""
                    self.lblNotFound.isHidden = true
                } else {
                    self.lblNotFound.text = "No Blocked User"
                    self.lblNotFound.isHidden = false
                }
                self.blockUserTableView.reloadData()
            }
        }
        
        // UNBLOCK USER RESPONSE
        viewModel.reloadListViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
//                self.blockUserTableView.reloadData()
                if self.viewModel.unblockUserResp?.status == APIKeys.success {
                    self.viewModel.getblockUserList()
                }
            }
        }
    }
    
    // MARK: - ==== IBACTIONs ====
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}


// MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension BlockListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return blockListArr.count
        return (filteredBlockListArr.count > 0 && isSearchActive) ? filteredBlockListArr.count : blockListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BlockListCell.className, for: indexPath) as! BlockListCell
        cell.selectionStyle = .none

//        let userList = blockListArr[indexPath.row].blockUser
        let userList = (filteredBlockListArr.count > 0 && isSearchActive) ? filteredBlockListArr[indexPath.row].blockUser : blockListArr[indexPath.row].blockUser
        cell.lblUserName.text = "\(userList?.fname ?? "") \(userList?.lname ?? "")"
        if let imageUrl = URL(string: userList?.profileImg?.image ?? "") {
            cell.userImage.kf.setImage(with: imageUrl)
        }
        
        cell.btnUnblock.tag = indexPath.row
        cell.btnUnblock.addTarget(self, action: #selector(unblockButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userList = (filteredBlockListArr.count > 0 && isSearchActive) ? filteredBlockListArr[indexPath.row].blockUser : blockListArr[indexPath.row].blockUser
        let userProfileVC = kHomeStoryboard.instantiateViewController(withIdentifier: FriendsProfileVC.className) as! FriendsProfileVC
        userProfileVC.userId = userList?._id ?? ""
        userProfileVC.isFromMyProfile = true
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
   
    @objc func unblockButtonTapped(_ sender: UIButton) {
        let id = self.blockListArr[sender.tag].blockUser?._id ?? ""
        self.viewModel.unblockUser(id: id)
    }
}


// MARK: - ==== SEARCHBAR DELEGATE METHODs ====
extension BlockListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            clearSearchedData()
        } else {
            self.lblNotFound.text = ""
            self.lblNotFound.isHidden = true
            self.searchData(searchText: searchText)
        }
    }
    
    func searchData(searchText: String) {
        /// SEARCH DATA
        self.filteredBlockListArr = self.blockListArr.filter({($0.blockUser?.fname?.localizedCaseInsensitiveContains(searchText) ?? false) || ($0.blockUser?.lname?.localizedCaseInsensitiveContains(searchText) ?? false)})
        DispatchQueue.main.async {
            self.isSearchActive = self.filteredBlockListArr.count > 0 ? true : false
            self.blockUserTableView.reloadData()
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
            self.filteredBlockListArr.removeAll()
            self.blockUserTableView.reloadData()
        }
    }
}
