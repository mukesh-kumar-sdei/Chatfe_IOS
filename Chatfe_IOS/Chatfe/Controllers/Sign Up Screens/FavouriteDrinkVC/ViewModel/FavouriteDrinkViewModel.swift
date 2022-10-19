//
//  FavouriteDrinkViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 02/05/22.
//

import Foundation

class FavouriteDrinkViewModel: BaseViewModel {
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    var favouriteDrinkResponse: FavouriteDrinkResponse?
    
    func getAllDrinks() {
        self.isLoading = true
        userService.getAllDrinks([:]) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? FavouriteDrinkResponse else {
                    return
                }
                if model.status != "SUCCESS" {
                    self.isSuccess = false
                    self.errorMessage = model.status
                    return
                }
                self.favouriteDrinkResponse = model
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
