//
//  BaseViewModel.swift
//  Chatfe
//
//  Created by Piyush Mohan on 21/04/22.
//

import Foundation

enum AlertType {
    case normal
    case warning
    case error
    case success
    case custom
}

enum CustomAlerts {
    case email
    case username
    case password
    case confirmPass
    case passMismatch
    case phoneNumberError
    case none
    case serverError
    case invalidReferralCode
}

class BaseViewModel: NSObject {
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?(.success)
        }
    }
    var errorMessage: String? {
        didSet {
            self.showAlertClosure?(.error)
        }
    }
    var isSuccess: Bool? {
        didSet {
            if isSuccess ?? false {
                self.redirectControllerClosure?()
            }
        }
    }
    var isMenuDataSuccess: Bool? {
        didSet {
            if isMenuDataSuccess ?? false {
                self.redirectControllerClosure?()
            }
        }
    }
    var isFailed: Bool? {
        didSet {
            self.showAlertClosure?(.error)
        }
    }
    var isValidationFailed: CustomAlerts = .none {
        didSet {
            self.updateUI?(isValidationFailed)
        }
    }
    var serverValidations: String? {
        didSet {
            self.serverErrorMessages?(self.serverValidations)
        }
    }
    var validServerMessage: String? {
        didSet {
            self.validUIClosures?(self.validServerMessage)
        }
    }
    var requestedAPI: String? {
        didSet {
            self.proceedClosure?(self.requestedAPI ?? "")
        }
    }
    
    var showAlertClosure: ((_ type: AlertType) -> Void)?
    var updateLoadingStatus: (() -> Void)?
    var reloadListViewClosure: (() -> Void)?
    var reloadListViewClosure1: (() -> Void)?
    var redirectControllerClosure: (() -> Void)?
    var redirectControllerClosure1: (() -> Void)?
    var updateUI: ((_ type: CustomAlerts) -> ())?
    var serverErrorMessages: ((_ message: String?) -> Void)?
    var validUIClosures: ((_ message: String?) -> Void)?
    var redirectClosure: ((_ type: String) -> ())?
    var reloadMenuClosure: (() -> Void)?
    var reloadMenuClosure1: (() -> Void)?
    var proceedClosure: ((_ message: String) -> Void)?
}
