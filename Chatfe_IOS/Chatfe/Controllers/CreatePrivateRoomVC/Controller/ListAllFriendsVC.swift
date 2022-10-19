//
//  ListAllFriendsVC.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 16/06/22.
//
/*
import UIKit

class ListAllFriendsVC: BaseViewController {

    //MARK: - ==== IBOUTLETs ====
    @IBOutlet weak var friendsTableView: UITableView!
    
    lazy var viewModel: CreatePublicRoomViewModel = {
        let obj = CreatePublicRoomViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var friendsList = [SenderIdData]()
    
    //MARK: - ==== VC LIFECYCLE ====
    override func viewDidLoad() {
        super.viewDidLoad()

        self.friendsTableView.dataSource = self
        self.friendsTableView.delegate = self
        self.friendsTableView.register(UINib(nibName: EventUserListTVC.className, bundle: nil), forCellReuseIdentifier: EventUserListTVC.className)
        self.viewModel.getAllFriendsList()
        setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK: - ==== CUSTOM METHODs ====
    func setupClosure() {
        viewModel.reloadMenuClosure  = { [weak self] in
            DispatchQueue.main.async {
                self?.friendsList = self?.viewModel.friendsList?.data ?? []
                self?.friendsTableView.reloadData()
            }
        }
    }

    //MARK: - ==== IBACTIONs ====
    @IBAction func dismissBtnTapped(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

}


//MARK: - ==== TABLEVIEW DATASOURCE & DELEGATE METHODs ====
extension ListAllFriendsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
//        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*switch section {
        case 0:
            let rows = friendsList.count > 0 ? 1 : 0
            return rows
        case 1:
            return self.friendsList.count
        default:
            return 1
        }*/
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.className, for: indexPath) as! HeaderCell
            cell.lblHeaderName.text = "Joined Users"
            return cell
        case 1:*/
        let cell = tableView.dequeueReusableCell(withIdentifier: EventUserListTVC.className, for: indexPath) as! EventUserListTVC
        cell.selectionStyle = .none
        let friend = friendsList[indexPath.row]
        cell.lblFriendName.text = "\(friend.fname ?? "") \(friend.lname ?? "")"
        cell.lblPhoneNumber.text = friend.phone ?? friend.email
        if let imageUrl = URL(string: friend.profileImg?.image ?? "") {
            cell.friendImage.kf.setImage(with: imageUrl)
        }
        return cell
        /*default:
            return UITableViewCell()
        }*/
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*switch indexPath.section {
        case 1:
            let friendsProfileVC = kHomeStoryboard.instantiateViewController(withIdentifier: FriendsProfileVC.className) as! FriendsProfileVC
//            friendsProfileVC.profileData = self.friendsArr[indexPath.row]
            friendsProfileVC.userId = self.friendsList[indexPath.row]._id ?? ""
            self.navigationController?.pushViewController(friendsProfileVC, animated: true)
        default:
            return
        }*/
    }
    
    
}
*/
