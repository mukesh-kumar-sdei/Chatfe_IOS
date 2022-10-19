//
//  FilterViewController.swift
//  Chatfe
//
//  Created by Piyush Mohan on 13/05/22.
//

import UIKit

protocol SortByDelegate: AnyObject {
    func didSort(selectedSort: String)
}

protocol SelectCategoryDelegate: AnyObject {
//    func didSelectCategory(selected: String)
        func didSelectCategory(selected: CategoriesData)
}

protocol StartTimeDelegate: AnyObject {
    func didStartTime(time: String)
}

protocol SelectDateDelegate: AnyObject {
    func didSelectDate(date: String)
}


class FilterViewController: BaseViewController {
    
    @IBOutlet weak var filterTableView: UITableView!
    
    
    lazy var filterViewModel: FilterViewModel = {
        let obj = FilterViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var homeDelegate: RefreshRoomsDelegate?
    var filterCatDelegate: SelectedFilterDelegate?

    var categoriesArr: [CategoriesData] = []
    var selectedCat: CategoriesData?
    var selectedCategoryId = ""
    var selectedSortBy = ""
    var startTime = ""
    var selectedDate = ""
    var selectedIndexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterTableView.delegate = self
        filterTableView.dataSource = self
        registerCells()
        setupClosure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func registerCells() {
        filterTableView.register(UINib(nibName: CategoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.identifier)
        filterTableView.register(UINib(nibName: AddDateTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AddDateTableViewCell.identifier)
        filterTableView.register(UINib(nibName: StartTimeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: StartTimeTableViewCell.identifier)
        filterTableView.register(UINib(nibName: SortByTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SortByTableViewCell.identifier)
    }
    
    func setupClosure() {
        filterViewModel.reloadListViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.selectedDate = ""
                self?.startTime = ""
                self?.navigationController?.popViewController(animated: true)
                if let data = self?.filterViewModel.roomResponse?.data {
                    self?.homeDelegate?.refreshRooms(roomData: data)
                }
            }
        }
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyBtnTapped(_ sender: UIButton) {
        ///CASE 1: WHEN ONLY DATE IS SELECTED
        if startTime == "" && selectedDate != "" {
            self.selectedDate = "\(selectedDate)T00:00:00.000Z"
        }
        ///CASE 2: WHEN ONLY TIME IS SELECTED
        else if startTime != "" && selectedDate == "" {
            // CONSIDERING TODAY's DATE
            let currentDate = currentTimeStamp()
//            let extractedDate = currentDate.extractDate()
            let extractedDate = currentDate.extractDate(outputFormat: DateFormats.yyyyMMdd)
            let eventDateTime = "\(extractedDate) \(startTime)"
            let eventDate = eventDateTime.localToServerTime()
            self.selectedDate = eventDate
        }
        ///CASE 3: WHEN BOTH IS SELECTED
        else if startTime != "" && selectedDate != "" {
            let eventDateTime = "\(selectedDate) \(startTime)"
            let eventDate = eventDateTime.localToServerTime()
            self.selectedDate = eventDate
        }
        
        let params = ["categoryId"          : selectedCategoryId,
                      "startDate"           : (startTime == "" && selectedDate != "") ? selectedDate : "" ,
                      "startTime"           : startTime != "" ? selectedDate : "",
//                      "date"                : selectedDate,
                      "sort_by"             : selectedSortBy,
                      "isFreeOnMyCalendar"  : UserDefaultUtility.shared.getFreeMyCalendar()
                    ] as [String : Any]
        filterViewModel.getFilteredRooms(params: params)
        self.filterCatDelegate?.setSelectedCategory(cat: selectedCat)
    }

}

// MARK: - ==== TABLEVIEW DATESOURCE & DELEGATE ====
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as? CategoryTableViewCell else {
                return UITableViewCell()
            }
            cell.categories = categoriesArr
            cell.filterDelegate = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddDateTableViewCell.identifier) as? AddDateTableViewCell else {
                return UITableViewCell()
            }
            cell.filterDelegate = self
            cell.parentVC = self
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StartTimeTableViewCell.identifier) as? StartTimeTableViewCell else {
                return UITableViewCell()
            }
           // cell.collectionView.frame.size.height = 100
            cell.filterDelegate = self
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SortByTableViewCell.identifier) as? SortByTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 150
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
//            return 150
            return 115
        case 1:
            return UITableView.automaticDimension
        case 2:
//            return 200
            return 125
        case 3:
//            return 200
//            return 125
            return 145
        default:
            return UITableView.automaticDimension
        }
    }
    
}


extension FilterViewController: SortByDelegate {
    
    func didSort(selectedSort: String) {
        self.selectedSortBy = selectedSort
        debugPrint("Selected Sort is \(self.selectedSortBy)")
    }
}

extension FilterViewController: SelectCategoryDelegate {
    
    func didSelectCategory(selected: CategoriesData) {
        if let id = selected._id {
            self.selectedCategoryId = id
        }
        self.selectedCat = selected
        debugPrint("SelCat = \(self.selectedCategoryId)")
    }
}

/*
extension FilterViewController: SelectCategoryDelegate {
    func didSelectCategory(selected: String) {
        self.selectedCategoryId = selected
        debugPrint("SelCat = \(self.selectedCategoryId)")
    }
}
*/
extension FilterViewController: StartTimeDelegate {
    func didStartTime(time: String) {
        self.startTime = time
    }
}

extension FilterViewController: SelectDateDelegate {
    func didSelectDate(date: String) {
        self.selectedDate = date
    }
    
}
