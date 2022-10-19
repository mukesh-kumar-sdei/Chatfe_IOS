//
//  UserService.swift
//  Chatfe
//
//  Created by Piyush Mohan on 04/04/22.
//

import Foundation


protocol UserServiceProtocol {
    func getAllDrinks(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func sendOTP(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func sendEmail(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func verifyPhone(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func verfiyEmail(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func registerUser(_ params: KeyValue, fileData:[File]?, completion: @escaping (Result<Any>) -> Void)
    func loginByGoogle(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void)
    func loginByFacebook(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void)
    func loginByApple(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void)
    func login(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void)
    
    func getAllRooms(_ params: KeyValue?, completion: @escaping(Result<Any>) -> Void)
    func getJoinedRooms(completion: @escaping (Result<Any>) -> Void)
    func addRoom(_ params: KeyValue?, completion: @escaping(Result<Any>) -> Void)
    func getRoom(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void)
    func deleteRoom(roomId: String, completion: @escaping (Result<Any>) -> Void)
    func updateRoom(params: [String: Any], completion: @escaping (Result<Any>) -> Void)
    func getCategories(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void)
    func uploadImage(_ params: KeyValue, files: [File], completion: @escaping(Result<Any>) -> Void)
    func getProfile(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void)
    func logout(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void)
    func deleteAccount(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void)
    func getFilteredRooms(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void)
    func resetPassword(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void)
    func updateProfile(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void)
    func joinRoom(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void)
    func unJoinRoom(_ id: String, completion: @escaping (Result<Any>) -> Void)
    func forgotPasswordPhoneSendOTP(phoneNumber: String, completion: @escaping (Result<Any>) -> Void)
    func forgotPasswordEmailSendOTP(emailId: String, completion: @escaping (Result<Any>) -> Void)
    func verifyForgotPasswordOTPAPI(email: String, phone: String, otp: String, completion: @escaping (Result<Any>) -> Void)
    func checkUsernameAPI(username: String, completion: @escaping (Result<Any>) -> Void)
    func checkPhoneAndEmailAPI(phone: String, email: String, completion: @escaping (Result<Any>) -> Void)
    func userCreatedRoomsAPI(userId: String, completion: @escaping (Result<Any>) -> Void)
    func usersListWithRoomDetailsAPI(roomId: String, completion: @escaping (Result<Any>) -> Void)
    func friendUserProfile(userId: String, completion: @escaping (Result<Any>) -> Void)
    
    func sendFriendRequestAPI(senderId: String, receiverId: String, completion: @escaping (Result<Any>) -> Void)
    func getAllFriendRequestsAPI(completion: @escaping (Result<Any>) -> Void)
    func acceptFriendRequestAPI(userId: String, senderId: String, receiverId: String, completion: @escaping (Result<Any>) -> Void)
    func rejectFriendRequestAPI(userId: String, senderId: String, receiverId: String, completion: @escaping (Result<Any>) -> Void)
    func getFriendsList(completion: @escaping (Result<Any>) -> Void)
    func unfriendAPI(userId: String, friendID: String, completion: @escaping (Result<Any>) -> Void)
    
    func getMovieSuggestions(searchText: String, completion: @escaping (Result<Any>) -> Void)
    func getAllNotificationsAPI(completion: @escaping (Result<Any>) -> Void)
    func searchRoomAPI(classRoom: String, searchText: String, page: Int, limit: Int, completion: @escaping (Result<Any>) -> Void)
    func searchPeopleAPI(searchText: String, completion: @escaping (Result<Any>) -> Void)
    func getRecentSearchAPI(completion: @escaping (Result<Any>) -> Void)
    func addRecentSearchAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void)
    func deleteRecentSearchAPI(id: String, completion: @escaping (Result<Any>) -> Void)
    func recentConnectionDetailsAPI(userID: String, recentUserID: String, completion: @escaping (Result<Any>) -> Void)
    
    func getBlockListAPI(completion: @escaping (Result<Any>) -> Void)
    func userBlockAPI(Id: String, completion: @escaping (Result<Any>) -> Void)
    func unblockUserAPI(Id: String, completion: @escaping (Result<Any>) -> Void)
    
    func getVisibilityAPI(completion: @escaping (Result<Any>) -> Void)
    func updateVisibilityAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void)
    func matchPreferenceAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void)
    func getMatchPreferenceAPI(completion: @escaping (Result<Any>) -> Void)
    
    func getRoomChannelID(completion: @escaping (Result<Any>) -> Void)
    func getRoomMembers(channelID: String, completion: @escaping (Result<Any>) -> Void)
    func voteToRemoveAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void)
    func cancelVoteToRemoveAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void)
    func eventChatMemberProfileAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void)
    func getActivityAPI(completion: @escaping (Result<Any>) -> Void)
    func updateActivityAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void)
}

public class UserService: APIService, UserServiceProtocol {
    
    func getAllDrinks(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.GET, ApiEndpoints.getAllDrinks, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: FavouriteDrinkResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let drinkData = data {
                    completion(.success(drinkData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    

    func sendOTP(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.sendOTP, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let otpData = data {
                    completion(.success(otpData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func sendEmail(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.sendEmail, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let otpData = data {
                    completion(.success(otpData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
 
    
    func verifyPhone(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.verifyPhone, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: EnterCodeResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let otpData = data {
                    completion(.success(otpData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func verfiyEmail(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.verifyEmail, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: EnterCodeResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let otpData = data {
                    completion(.success(otpData))
                }
            case .error(let message):
                completion(.error(message))
                debugPrint(message)
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    

    
    func registerUser(_ params: KeyValue, fileData: [File]?, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.register, false)
        super.startService(config: serviceConfig, parameters: params, files: fileData, modelType: RegisterResponseModel.self) { (result) in
            switch result {
            case .success(let data):
                if let registerData = data {
                    completion(.success(registerData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func loginByGoogle(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.loginByGoogle, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: GoogleLoginResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let registerData = data {
                    completion(.success(registerData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func loginByFacebook(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.loginByFacebook, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: FacebookLoginResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let registerData = data {
                    completion(.success(registerData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func loginByApple(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.loginByApple, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: AppleLoginResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let registerData = data {
                    completion(.success(registerData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func login(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.login, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: LoginResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let loginData = data {
                    completion(.success(loginData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getAllRooms(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.getAllRooms, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: RoomsResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let roomData = data {
                    completion(.success(roomData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getJoinedRooms(completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.GET, ApiEndpoints.getJoinedRooms, true)
        super.startService(config: serviceConfig, parameters: [:], files: nil, modelType: RoomJoinedModel.self) { (result) in
            switch result {
            case .success(let data):
                if let roomData = data {
                    completion(.success(roomData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func addRoom(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.addRoom, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: AddRoomResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let roomData = data {
                    completion(.success(roomData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getRoom(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.getRoom, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: EventDataResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let roomData = data {
                    completion(.success(roomData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func deleteRoom(roomId: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["_id": roomId]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.deleteRoom, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let roomData = data {
                    completion(.success(roomData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func updateRoom(params: [String: Any], completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.PUT, ApiEndpoints.updateRoom, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let roomData = data {
                    completion(.success(roomData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getCategories(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.GET, ApiEndpoints.getCategories, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: CategoriesResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let categoryData = data {
                    completion(.success(categoryData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func uploadImage(_ params: KeyValue,files: [File], completion: @escaping(Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.uploadImage, false)
        super.startService(config: serviceConfig, parameters: params, files: files, modelType: ImageUploadResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let imagesData = data {
                    completion(.success(imagesData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getProfile(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.GET, ApiEndpoints.getProfile, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: GetProfileResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let profileData = data {
                    completion(.success(profileData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func logout(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.logout, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: LogoutResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let logoutData = data {
                    completion(.success(logoutData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func deleteAccount(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.DELETE, ApiEndpoints.deleteAccount, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: deleteAccountResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let deleteAccountData = data {
                    completion(.success(deleteAccountData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getFilteredRooms(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.getAllRooms, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: RoomsResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let roomData = data {
                    completion(.success(roomData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func resetPassword(_ params: KeyValue, completion: @escaping(Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.resetPassword, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: ResetPasswordResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resetData = data {
                    completion(.success(resetData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func updateProfile(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.PUT, ApiEndpoints.updateProfile, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: UpdateProfileResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let updateProfileData = data {
                    completion(.success(updateProfileData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func joinRoom(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.joinRoom, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: JoinRoomResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let joinRoomData = data {
                    completion(.success(joinRoomData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func unJoinRoom(_ id: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["_id": id]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.unjoinRoom, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let joinRoomData = data {
                    completion(.success(joinRoomData))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func forgotPasswordPhoneSendOTP(phoneNumber: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["phone": phoneNumber]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.frgtPswrdPhoneOTP, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func forgotPasswordEmailSendOTP(emailId: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["email": emailId]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.frgtPswrdEmailOTP, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func verifyForgotPasswordOTPAPI(email: String, phone: String, otp: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["email": email, "phone": phone, "otp": otp]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.verifyFgtPswrdOTP, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func checkUsernameAPI(username: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["username": username]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.checkUsername, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func checkPhoneAndEmailAPI(phone: String, email: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["phone": phone, "email": email]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.checkPhoneEmail, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    
    func userCreatedRoomsAPI(userId: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["createdBy": userId]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.userCreatedRooms, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: RoomsResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func usersListWithRoomDetailsAPI(roomId: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["_id": roomId]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.userListWithRoom, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: EventDetailsUserListModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func friendUserProfile(userId: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["_id": userId]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.friendUserProfile, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: FriendsProfileModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }

    }
    
    func sendFriendRequestAPI(senderId: String, receiverId: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["senderId": senderId, "receiverId": receiverId]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.sendFriendRequest, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func unfriendAPI(userId: String, friendID: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["userId": userId, "friendId": friendID]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.unfriend, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
        
    }
    
    func getAllFriendRequestsAPI(completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.GET, ApiEndpoints.getAllFriendsRequests, true)
        super.startService(config: serviceConfig, parameters: [:], files: nil, modelType: GetAllFriendRequestModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func acceptFriendRequestAPI(userId: String, senderId: String, receiverId: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["_id": userId, "senderId": senderId, "receiverId": receiverId]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.acceptFriendRequest, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func rejectFriendRequestAPI(userId: String, senderId: String, receiverId: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["_id": userId, "senderId": senderId, "receiverId": receiverId]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.rejectFriendRequest, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getFriendsList(completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.GET, ApiEndpoints.getFriendsList, true)
        super.startService(config: serviceConfig, parameters: [:], files: nil, modelType: AllFriendsListModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getMovieSuggestions(searchText: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["search": searchText]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.getMovie, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: GetMovieModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getAllNotificationsAPI(completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.GET, ApiEndpoints.getAllnotifications, true)
        super.startService(config: serviceConfig, parameters: [:], files: nil, modelType: AllNotificationsModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func searchRoomAPI(classRoom: String, searchText: String, page: Int, limit: Int, completion: @escaping (Result<Any>) -> Void) {
        let params = ["roomClass": classRoom, "q": searchText, "page": page, "pageSize": limit] as [String: Any]
        let queryParams = self.buildParams(parameters: params)
        let serviceConfig: Service.config = (.GET, ApiEndpoints.searchRoom + "?" + queryParams, true)
        super.startService(config: serviceConfig, parameters: [:], files: nil, modelType: SearchRoomModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func searchPeopleAPI(searchText: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["q": searchText]
        let queryParams = self.buildParams(parameters: params)
        let serviceConfig: Service.config = (.GET, ApiEndpoints.searchPeople + "?" + queryParams, true)
        super.startService(config: serviceConfig, parameters: [:], files: nil, modelType: SearchUserModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getRecentSearchAPI(completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.GET, ApiEndpoints.recentSearch, true)
        super.startService(config: serviceConfig, parameters: [:], files: nil, modelType: GetRecentSearchModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func addRecentSearchAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.recentSearch, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: AddRecentSearchModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func deleteRecentSearchAPI(id: String, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.DELETE, ApiEndpoints.recentSearch + "/" + id, true)
        super.startService(config: serviceConfig, parameters: [:], files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func recentConnectionDetailsAPI(userID: String, recentUserID: String, completion: @escaping (Result<Any>) -> Void) {
        let params = ["userId": userID, "recentUserId": recentUserID]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.recentConnectionDetails, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: RecentConnectionDetailModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getBlockListAPI(completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.GET, ApiEndpoints.userBlock, true)
        super.startService(config: serviceConfig, parameters: [:], files: nil, modelType: GetBlockListModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func userBlockAPI(Id: String, completion: @escaping (Result<Any>) -> Void) {
        let params = [APIKeys.userId: Id]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.userBlock, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func unblockUserAPI(Id: String, completion: @escaping (Result<Any>) -> Void) {
        let params = [APIKeys.userId: Id]
        let serviceConfig: Service.config = (.PUT, ApiEndpoints.userUnblock, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getVisibilityAPI(completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.GET, ApiEndpoints.getVisibility, true)
        super.startService(config: serviceConfig, parameters: [:], files: nil, modelType: VisibilityModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func updateVisibilityAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.PUT, ApiEndpoints.updateVisibility, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func matchPreferenceAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.userPrefrences, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: MatchPrefModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getMatchPreferenceAPI(completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.GET, ApiEndpoints.userPrefrences, true)
        super.startService(config: serviceConfig, parameters: [:], files: nil, modelType: MatchPrefModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getRoomMembers(channelID: String, completion: @escaping (Result<Any>) -> Void) {
        let params = [APIKeys.channelID: channelID]
        let serviceConfig: Service.config = (.POST, ApiEndpoints.getEventParticipant, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: ParticipantsModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getRoomChannelID(completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.GET, ApiEndpoints.getEventChannelID, true)
        super.startService(config: serviceConfig, parameters: [:], files: nil, modelType: ChannelIdModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func voteToRemoveAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.roomVoteToRemove, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func cancelVoteToRemoveAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.cancelVoteToRemove, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: SendOTPResponse.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func eventChatMemberProfileAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, ApiEndpoints.eventChatUserProfile, true)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: GCUserProfileModel.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func getActivityAPI(completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.GET, ApiEndpoints.getActivity, true)
        super.startService(config: serviceConfig, parameters: [:], files: nil, modelType: ActivityModal.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
    func updateActivityAPI(params: [String: Any], completion: @escaping (Result<Any>) -> Void) {
        let param  = ["activity":params]
        let serviceConfig: Service.config = (.PUT, ApiEndpoints.updateActivity, true)
        super.startService(config: serviceConfig, parameters: param, files: nil, modelType: ActivityModal.self) { (result) in
            switch result {
            case .success(let data):
                if let resp = data {
                    completion(.success(resp))
                }
            case .error(let message):
                completion(.error(message))
            case .customError(let errorModel):
                completion(.customError(errorModel))
            }
        }
    }
    
}
