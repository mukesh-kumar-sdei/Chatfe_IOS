//
//  UserDefaultUtility.swift
//  Chatfe
//
//  Created by Piyush Mohan on 04/04/22.
//

import Foundation

struct UserDefaultUtility {
    
    static let shared = UserDefaultUtility()
    
    func saveAppleInfo(_ info: AppleInfoModel) {
        UserDefaults.standard.set(info.userid, forKey: "userId")
        UserDefaults.standard.set(info.firstName, forKey: "firstname")
        UserDefaults.standard.set(info.lastName, forKey: "lastname")
        UserDefaults.standard.set(info.email, forKey: "email")
    }
    
    func saveDeviceToken(token: String) {
        UserDefaults.standard.set(token, forKey: "device_token")
    }
    
    func getDeviceToken() -> String {
        return UserDefaults.standard.value(forKey: "device_token") as! String
    }
    
    func saveUserId(userId: String) {
        UserDefaults.standard.set(userId, forKey: "userId")
    }
    
    func getUserId() -> String? {
        return UserDefaults.standard.value(forKey: "userId") as! String?
    }
    
    func saveLoginType(type: String) {
        UserDefaults.standard.set(type, forKey: "LOGIN_TYPE")
    }
    
    func getLoginType() -> String {
        return UserDefaults.standard.value(forKey: "LOGIN_TYPE") as! String
    }
    
    func saveUsername(name: String) {
        UserDefaults.standard.set(name, forKey: "username")
    }
    
    func getUsername() -> String? {
        return UserDefaults.standard.value(forKey: "username") as! String?
    }
    
    func savePassword(pass: String) {
        UserDefaults.standard.set(pass, forKey: "password")
    }
    
    func getPassword() -> String {
        return UserDefaults.standard.value(forKey: "password") as! String
    }
    
    func saveFirstName(name: String) {
        UserDefaults.standard.set(name, forKey: "firstname")
    }
    
    func getFirstName() -> String {
        return UserDefaults.standard.value(forKey: "firstname") as! String
    }
    
    func saveLastName(name: String) {
        UserDefaults.standard.set(name, forKey: "lastname")
    }
    
    func getLastName() -> String {
        return UserDefaults.standard.value(forKey: "lastname") as! String
    }
    
    func saveFullName(name: String?) {
        UserDefaults.standard.set(name, forKey: "fullname")
    }
    
    func getFullName() -> String? {
        return UserDefaults.standard.value(forKey: "fullname") as? String
    }
    
    func removeFullName() {
        UserDefaults.standard.removeObject(forKey: "fullname")
    }
    
    func saveEmail(email: String) {
        UserDefaults.standard.set(email, forKey: "email")
    }
    
    func getEmail() -> String? {
        return UserDefaults.standard.value(forKey: "email") as! String?
    }
    
    func savePhoneNumber(phone: String) {
        UserDefaults.standard.set(phone, forKey: "phone")
    }
    
    func getPhoneNumber() -> String? {
        return UserDefaults.standard.value(forKey: "phone") as! String?
    }
    
    func saveBirthday(date: String) {
        UserDefaults.standard.set(date, forKey: "birthdate")
    }
    
    func getBirthday() -> String {
        return UserDefaults.standard.value(forKey: "birthdate") as! String
    }
    
    func saveBirthdayVisibility(visibleTo: String) {
        UserDefaults.standard.set(visibleTo, forKey: "birthdayVisibility")
    }
    
    func getBirthdayVisibility() -> String {
        return UserDefaults.standard.value(forKey: "birthdayVisibility") as! String
    }
    
    func saveIdentity(identity: String) {
        UserDefaults.standard.set(identity, forKey: "userIdentity")
    }
    
    
    func saveMobileVerified(verify: Bool) {
        UserDefaults.standard.set(verify, forKey: "mobileVerified")
    }
    
    func getMobileVerified() -> Bool {
        return UserDefaults.standard.value(forKey: "mobileVerified") as? Bool ?? false
    }
    
    func saveEmailVerified(verify: Bool) {
        UserDefaults.standard.set(verify, forKey: "emailVerified")
    }
    
    func getEmailVerified() -> Bool {
        return UserDefaults.standard.value(forKey: "emailVerified") as? Bool ?? false
    }
    
    func getIdentity() -> String? {
        return UserDefaults.standard.value(forKey: "userIdentity") as? String ?? ""
    }
    
    func saveIdentityVisibility(visibleTo: String) {
        UserDefaults.standard.set(visibleTo, forKey: "identityVisibility")
    }
    
    func getIdentityVisiblity() -> String {
        return UserDefaults.standard.value(forKey: "identityVisibility") as! String
    }
    
    func saveDatingInterest(reply: String) {
        UserDefaults.standard.set(reply, forKey: "datingInterest")
    }
    
    func getDatingInterest() -> String {
        return UserDefaults.standard.value(forKey: "datingInterest") as! String
    }
    
    func saveDatingVisibility(visibleTo: String) {
        UserDefaults.standard.set(visibleTo, forKey: "datingVisibility")
    }
    
    func getDatingVisibility() -> String {
        return UserDefaults.standard.value(forKey: "datingVisibility") as! String
    }
    
    func saveHometown(city: String) {
        UserDefaults.standard.set(city, forKey: "hometown")
    }
    
    func getHometown() -> String? {
        return UserDefaults.standard.value(forKey: "hometown") as? String
    }
    
    func saveHometownVisibility(visibleTo: String) {
        UserDefaults.standard.set(visibleTo, forKey: "hometownVisibility")
    }
    
    func getHometownVisibility() -> String {
        return UserDefaults.standard.value(forKey: "hometownVisibility") as! String
    }
    
    func saveProfileImageURL(url: NSURL) {
        let stringUrl = url.absoluteString
        UserDefaults.standard.set(stringUrl, forKey: "profileImage")
    }

    func saveProfileImageURL(strURL: String) {
        UserDefaults.standard.set(strURL, forKey: "profileImage")
    }
    
    func getProfileImageURL() -> String? {
        return UserDefaults.standard.value(forKey: "profileImage") as? String ?? ""
    }
    
    func removeProfileImage() {
        UserDefaults.standard.removeObject(forKey: "profileImage")
    }
    
    func saveProfileImageVisibility(visibleTo: String) {
        UserDefaults.standard.set(visibleTo, forKey: "profileImageVisibility")
    }
    
    func getProfileImageVisibility() -> String {
        return UserDefaults.standard.value(forKey: "profileImageVisibility") as! String
    }
    
    func sendNotifcations(reply: Bool) {
        UserDefaults.standard.set(reply, forKey: "sendNotifications")
    }
    
    func getNotifications() -> Bool {
        return UserDefaults.standard.value(forKey: "sendNotifications") as! Bool
    }
    
    func saveAccessToken(token: String) {
        UserDefaults.standard.set(token, forKey: "accessToken")
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.value(forKey: "accessToken") as? String
    }
    
    func saveSelectedDrink(id: String) {
        UserDefaults.standard.set(id, forKey: "drinkId")
    }
    
    func getSelectedDrink() -> String? {
        return UserDefaults.standard.value(forKey: "drinkId") as? String ?? ""
    }
    
    /*func saveCategoryId(id: String) {
        UserDefaults.standard.set(id, forKey: "categoryId")
    }*/
    
    func getCategoryId() -> String {
        return UserDefaults.standard.value(forKey: "categoryId") as! String
    }
    
    func saveCategoryIdName(id: String, name: String) {
        UserDefaults.standard.set(id, forKey: "categoryId")
        UserDefaults.standard.set(name, forKey: "categoryName")
    }
    
    func getCategoryName() -> String? {
        return UserDefaults.standard.value(forKey: "categoryName") as? String
    }
    
    func saveRoomName(name: String) {
        UserDefaults.standard.set(name, forKey: "roomName")
    }
    
    func getRoomName() -> String {
        return UserDefaults.standard.value(forKey: "roomName") as! String
    }
    
    func saveDate(date: String) {
        UserDefaults.standard.set(date, forKey: "date")
    }
    
    func getDate() -> String {
        return UserDefaults.standard.value(forKey: "date") as! String
    }
    
    func saveStartTime(time: String) {
        UserDefaults.standard.set(time, forKey: "startTime")
    }
    
    func getStartTime() -> String {
       return UserDefaults.standard.value(forKey: "startTime") as! String
    }
    
    func saveDuration(duration: Double) {
        UserDefaults.standard.set(duration, forKey: "duration")
    }
    
    func getDuration() -> Double {
        return UserDefaults.standard.value(forKey: "duration") as! Double
    }
    
    func saveAbout(about: String) {
        UserDefaults.standard.set(about, forKey: "about")
    }
    
    func getAbout() -> String? {
        return UserDefaults.standard.value(forKey: "about") as? String
    }
    
    /*func saveRoomAbout(about: String) {
        UserDefaults.standard.set(about, forKey: "roomAbout")
    }
    
    func getRoomAbout() -> String? {
        UserDefaults.standard.value(forKey: "roomAbout") as? String
    }*/
    
    func saveRoomType(type: String) {
        UserDefaults.standard.set(type, forKey: "roomType")
    }
    
    func getRoomType() -> String {
        return UserDefaults.standard.value(forKey: "roomType") as! String
    }
    
    func saveRoomImageUrl(url: String) {
        UserDefaults.standard.set(url, forKey: "roomImage")
    }
    
    func getRoomImageUrl() -> String {
        UserDefaults.standard.value(forKey: "roomImage") as! String
    }
    
    func saveRoomClass(_ str: String) {
        UserDefaults.standard.set(str, forKey: "roomClass")
    }
    
    func getRoomClass() -> String? {
        UserDefaults.standard.value(forKey: "roomClass") as? String
    }
    
    func saveFreeMyCalendar(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "FreeOnMyCalendar")
    }
    
    func getFreeMyCalendar() -> Bool {
        UserDefaults.standard.bool(forKey: "FreeOnMyCalendar")
    }
    
    /// SAVE INVITED FRIEND IDs
    func saveInviteFriendsIDs(_ list: [String]) {
        UserDefaults.standard.set(list, forKey: "InviteFriendsListIDs")
    }
    
    func getInviteFriendsIDs() -> [String]? {
        UserDefaults.standard.value(forKey: "InviteFriendsListIDs") as? [String]
    }
    
    func removeInvitedFriendsIDs() {
        UserDefaults.standard.removeObject(forKey: "InviteFriendsListIDs")
    }
    /// SAVE INVITED FRIEND NAMES
    func saveInviteFriendNames(names: [String]) {
        UserDefaults.standard.set(names, forKey: "InvitedFriendsNames")
    }
    
    func getInviteFriendNames() -> [String]? {
        UserDefaults.standard.value(forKey: "InvitedFriendsNames") as? [String]
    }
    
    func removeInvitedFriendNames() {
        UserDefaults.standard.removeObject(forKey: "InvitedFriendsNames")
    }
    
    /// SAVING INVITED FRIENDS VIA EMAIL
    func saveInvitedFriendEmail(_ email: String) {
        UserDefaults.standard.set(email, forKey: "InvitedFriendEmail")
    }
    
    func getInvitedFriendsEmail() -> String? {
        UserDefaults.standard.value(forKey: "InvitedFriendEmail") as? String
    }
    
    func removeInvitedFriendsEmail() {
        UserDefaults.standard.removeObject(forKey: "InvitedFriendEmail")
    }
    
    /// SAVING CHANNEL ID
    func saveChannelID(_ id: String) {
        UserDefaults.standard.set(id, forKey: "CHANNEL_ID")
    }
    
    func getChannelID() -> String? {
        UserDefaults.standard.value(forKey: "CHANNEL_ID") as? String
    }
    
    func removeChannelID() {
        UserDefaults.standard.removeObject(forKey: "CHANNEL_ID")
    }
    
    /// SAVING MATCH MAKING
    func saveMatchMakingShown(show: Bool) {
        UserDefaults.standard.set(show, forKey: "MATCH_MAKING_SHOWN")
    }
    
    func getMatchMakingShown() -> Bool? {
        UserDefaults.standard.value(forKey: "MATCH_MAKING_SHOWN") as? Bool
    }
    
    func removeMatchMakingShown() {
        UserDefaults.standard.removeObject(forKey: "MATCH_MAKING_SHOWN")
    }
    
}
