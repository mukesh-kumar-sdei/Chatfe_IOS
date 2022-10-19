//
//  SearchViewModel.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 23/06/22.
//

import Foundation


class SearchViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    // MARK: - INSTANCES
    var searchRoomModel: SearchRoomModel? {
        didSet {
            self.reloadListViewClosure?()
        }
    }
    
    var searchUserResponse: SearchUserModel? {
        didSet {
            self.redirectControllerClosure?()
        }
    }
    
    var recentSearchResponse: GetRecentSearchModel? {
        didSet {
            self.redirectControllerClosure1?()
        }
    }
    
    var deleteRecentSearch: SendOTPResponse? {
        didSet { self.reloadMenuClosure?() }
    }
    
    // MARK: - API METHODS
    func searchRoom(roomClass: String, searchText: String, page: Int, limit: Int) {
        self.isLoading = true
        userService.searchRoomAPI(classRoom: roomClass, searchText: searchText, page: page, limit: limit) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SearchRoomModel {
                        if model.status == APIKeys.success {
                            self.searchRoomModel = model
                        } else {
                            self.errorMessage = model.message
                        }
                    }
                case .error(let message):
                    self.errorMessage = message
                case .customError(let errorModel):
                    self.errorMessage = errorModel.message
                }
            }
        }
    }
    
    func searchPeople(searchText: String) {
        self.isLoading = true
        userService.searchPeopleAPI(searchText: searchText) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SearchUserModel {
                        if model.status == APIKeys.success {
                            self.searchUserResponse = model
                        } else {
                            self.errorMessage = model.message
                        }
                    }
                case .error(let message):
                    self.errorMessage = message
                case .customError(let errorModel):
                    self.errorMessage = errorModel.message
                }
            }
        }
    }
    
    func getRecentSearch() {
        self.isLoading = true
        userService.getRecentSearchAPI { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? GetRecentSearchModel {
                        if model.status == APIKeys.success {
                            self.recentSearchResponse = model
                        } else {
                            self.errorMessage = model.message
                        }
                    }
                case .error(let message):
                    self.errorMessage = message
                case .customError(let errorModel):
                    self.errorMessage = errorModel.message
                }
            }
        }
    }
    
    func deleteRecentSearch(id: String) {
        self.isLoading = true
        userService.deleteRecentSearchAPI(id: id) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let model = data as? SendOTPResponse {
                        if model.status == APIKeys.success {
                            self.deleteRecentSearch = model
                        } else {
                            self.errorMessage = model.message
                        }
                    }
                case .error(let message):
                    self.errorMessage = message
                case .customError(let errorModel):
                    self.errorMessage = errorModel.message
                }
            }
        }
    }
}
