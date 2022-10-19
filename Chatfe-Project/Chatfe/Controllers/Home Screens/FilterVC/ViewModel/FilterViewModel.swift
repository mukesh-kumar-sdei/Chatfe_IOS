//
//  FilterViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 18/05/22.
//

import Foundation

class FilterViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    var roomResponse: RoomsResponse?
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func getFilteredRooms(params:[String: Any]) {
        self.isLoading = true
        userService.getFilteredRooms(params) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? RoomsResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.status
                    return
                }
                self.roomResponse = model
                self.reloadListViewClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(_):
                break
            }
        }
    }
}
