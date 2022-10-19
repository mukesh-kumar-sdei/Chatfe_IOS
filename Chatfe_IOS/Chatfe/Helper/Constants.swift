//
//  Constants.swift
//  Chatfe
//
//  Created by Piyush Mohan on 04/04/22.
//

import Foundation
import UIKit

let kAppName                =   "Chatfé"

let kMainStoryboard         =   UIStoryboard(name: "Main", bundle: nil)
let kHomeStoryboard         =   UIStoryboard(name: "Home", bundle: nil)
let kHomeViewStoryboard     =   UIStoryboard(name: "HomeViews", bundle: nil)
let kChatStoryboard         =   UIStoryboard(name: "Chat", bundle: nil)

enum Config {
    // Copy Base Url here
    // DEV -
    // PROD -
    
    static let baseURL      =   "http://54.190.192.105:6167/api/v1/"
    static let socketURL    =   "http://54.190.192.105:6172"
}

struct GoogleSignInKey {
    static let clientID     =   "1042646389750-o5np5bibm88t453d8lam3chn9g34uc7m.apps.googleusercontent.com"
}

struct GoogleAdsKeys {
    static let googleAdsUnitID      =   "ca-app-pub-3940256099942544/4411468910" // "ca-app-pub-9500693697632345/6561581215"
}

typealias KeyValue = [String:Any]

enum SocketEnum: String {
    case emailVerified = "emailConfirmed"
    case none
}

enum EventType: String {
    case Public    =   "Public"
    case Private   =   "Private"
}

enum FriendRequestStatus: String {
    case Pending = "Pending"                    /// SENDER GET THIS WHEN RECEIVER NOT ACCEPTED FRIEND REQUEST YET
    case Confirmed = "Confirmed"                /// SENDER & RECEIVER BOTH GET THIS WHEN RECEIVER ACCEPTED AND BOTH ARE FRIENDS NOW
    case PendingToAccept = "PendingTOAccept"    /// RECEIVER GET THIS WHEN RECEIVER GOT FRIEND REQUEST
    case Empty = ""
}

/// enum: ["MatchMore", "MatchLess", "MatchNever", "NoInformation"]
struct MatchPrefType {
    static let MatchMore        =   "MatchMore"
    static let MatchLess        =   "MatchLess"
    static let MatchNever       =   "MatchNever"
    static let NoInformation    =   "NoInformation"
}

struct MatchPrefOptions {
    static let Match_More        =   "Match More"
    static let Match_Less        =   "Match Less"
    static let Match_Never       =   "Match Never"
}

struct ChatReaction {
    static let emoji = ["😀", "😜", "🤔", "👋", "👏", "👍"]
}

struct GroupChat {
    static let memberColor = ["49C6D8", "7F49D8", "D88549", "499CD8", "D549D8", "D84949", "6ED849", "D8C949"]
}

var isIphoneXorBigger: Bool {
    return (UIScreen.main.nativeBounds.height > 2208 || UIScreen.main.nativeBounds.height == 1792)
}

struct Constants {
    static let AppName              =   "Chatfe"
    static let ErrorAlertTitle      =   "Error"
    static let OkAlertTitle         =   "OK"
    static let CancelAlerTitle      =   "Cancel"
    static let EditRoomTitle        =   "Edit Room"
    static let DeleteRoomTitle      =   "Delete Room"
    static let UpdateEvent          =   "Update Event"
    
    static let chat                 =   "Chat"
    static let Room                 =   " Room"
    static let chatRoom             =   "Chat Room"
    static let watch                =   "Watch"
    static let watchParty           =   "Watch Party"
    static let people               =   "People"
    static let user                 =   "User"
    static let unauthorized         =   "unauthorized"
    
    static let Yes                  =   "Yes"
    static let No                   =   "No"
    static let other                =   "Other"
    static let Male                 =   "Male"
    static let Female               =   "Female"
    static let TransFemale          =   "Transgender Female"
    static let TransMale            =   "Transgender Male"
    static let GenderVariant        =   "Gender Variant"
    static let NotListed            =   "Not Listed"
    static let PreferNotToAnswer    =   "Prefer Not to Answer"
    
    static let joinedUsersTitle     =   "Joined Users"
    static let friendRequestsTitle  =   "Friend Requests"
    static let hasSentFriendRequest =   " has sent you a friend request. "
    static let invitesTitle         =   "Invites"
    static let invitedPrivateRoom   =   " invited you to a private room. "
    static let Typing               =   "Typing..."
    
    static let Selected             =   " Selected"
    static let Block                =   "Block"
    static let Unblock              =   "Unblock"
    
    static let room                 =   "room"
    static let friendRequest        =   "friendRequest"
}

public struct EventCategory {
    static let Movies               =   "Movies"
}

public struct AppFont {
    static let ProximaNovaRegular   =   "Proxima Nova Regular"
    static let ProximaNovaMedium    =   "Proxima Nova Medium"
    static let ProximaNovaBold      =   "Proxima Nova Bold"
}

public struct AppColor {
    static let textFieldPlaceholderColor    =   UIColor("#BFBFBF")
    static let textFieldBackgroundColor     =   UIColor("#FCFCFC")
    static let appBlueColor                 =   UIColor("#3999CF")
    static let selectedMenuBGColor          =   UIColor(named: "SelectedMenuBGColor")
    static let accentColor                  =   UIColor(named: "AccentColor")
    static let searchMagnifyColor           =   UIColor("#4F5863")
    static let appGrayColor                 =   UIColor("#5B636F")
}

public struct Images {
    static let radioButtonEmpty             =   UIImage(named: "optionLogoBlank")
    static let radioButtonFilled            =   UIImage(named: "optionLogoFill")
    static let chatRoomIcon                 =   UIImage(named: "message")
    static let watchPartyIcon               =   UIImage(named: "watchparty_icon")
    static let circleTick                   =   UIImage(named: "circleTicked")
    static let circleAdd                    =   UIImage(named: "addCircle")
    static let downArrow                    =   UIImage(named: "down")
    static let personAdd                    =   UIImage(named: "person-add")
    static let personChecked                =   UIImage(named: "person-check")
    static let checkBoxEmpty                =   UIImage(named: "checkbox-empty")
    static let checkBoxFilled               =   UIImage(named: "checkbox-filled")
    static let ellipsedEmpty                =   UIImage(named: "Ellipse_Empty")
    static let ellipsedFilled               =   UIImage(named: "Ellipse_Filled")
    static let cross                        =   UIImage(named: "x")
    static let greenDot                     =   UIImage(named: "Ellipse_Dot")
    static let redDot                       =   UIImage(named: "Ellipse_red_dot")
    
    static let matchMoreBW                  =   UIImage(named: "thumbs-up")
    static let matchLessBW                  =   UIImage(named: "thumbs-down")
    static let matchNeverBW                 =   UIImage(named: "ban-circle")
    static let matchMore                    =   UIImage(named: "thumbs-up-color")
    static let matchLess                    =   UIImage(named: "thumbs-down-color")
    static let matchNever                   =   UIImage(named: "stop-icon-color")
}

struct AlertMessage {
    static let invalidURL                   =   "Invalid server url"
    static let lostInternet                 =   "It seems you are offline. Please check your Internet Connection."
    static let sessionExpired               =   "Session Expired!"
    static let searchChatRoom               =   "Search for a chat room"
    static let chooseCategoryForSearch      =   "Please choose Category for its search."
    
    static let pleaseEnterYourName          =   "Please Enter Your Name"
    static let chooseCategory               =   "Please Choose a Category"
    static let enterRoomName                =   "Please Enter Room Name"
    static let chooseDate                   =   "Please Choose a Date"
    static let chooseStartTime              =   "Please Choose Start Time"
    static let selectDuration               =   "Please Select Duration"
    static let uploadImage                  =   "Please Upload an Image"
    static let inviteFriends                =   "Please invite friends for this room."
    
    static let noDataFound                  =   "No Data Found"
    static let noRecentSearch               =   "No Recent Search"
    
    static let noNotificationsReceived      =   "No Notifications Received"
    
    static let warning                      =   "Warning"
    static let youDontHaveCamera            =   "You don't have camera"
    static let youHaveNotGalleryAccess      =   "You don't have permission to access gallery"
    
    static let selectImageToUpload          =   "Please select an image to upload!"
    static let triedBlockUserInvite         =   "You tried to invite blocked user, kindly Unblock it to invite for this room."
    static let noFriendsinyourlist          =   "No Friends in your List"
    static let NoConversationyet            =   "No Conversation yet"
}

extension Notification.Name {
    static let MonthChanged                 =   Notification.Name("MONTH_CHANGED")
    static let SelectedRoomClass            =   Notification.Name("SELECTED_ROOM_CLASS")
    static let EditRoomDurationDefault      =   Notification.Name("EDIT_ROOM_DURATION_DEFAULT")
    static let EditRoomClassDefault         =   Notification.Name("EDIT_ROOM_CLASS_DEFAULT")
    static let IMDB_POSTER_IMAGE            =   Notification.Name("IMDB_POSTER_IMAGE")
    static let SOCKET_RECEIVE_MESSAGE       =   Notification.Name("SOCKET_RECEIVE_MESSAGE")
    static let SOCKET_USER_TYPING           =   Notification.Name("SOCKET_USER_TYPING")
    static let APPLE_CALENDAR_MONTH_CHANGED =   Notification.Name("APPLE_CALENDAR_MONTH_CHANGED")
    static let CALENDAR_RELOAD              =   Notification.Name("CALENDAR_RELOAD")
    static let DeepLinkNotification         =   Notification.Name("DeepLinkNotification")
    static let PUSH_NOTIFICATION_COUNT      =   Notification.Name("PUSH_NOTIFICATION_COUNT")
    static let JOINED_ROOMS_RESPONSE        =   Notification.Name("JOINED_ROOMS_RESPONSE")
    static let UNREAD_GROUP_MESSAGE_COUNT   =   Notification.Name("UNREAD_GROUP_MESSAGE_COUNT")
    static let ROOM_NOTIFICATION_TAPPED     =   Notification.Name("ROOM_NOTIFICATION_TAPPED")
    static let FRIEND_NOTIFICATION_TAPPED   =   Notification.Name("FRIEND_NOTIFICATION_TAPPED")
    static let GC_UNREAD_MESSAGE_COUNT      =   Notification.Name("GC_UNREAD_MESSAGE_COUNT")
    static let LISTEN_ONLINE_USERS          =   Notification.Name("LISTEN_ONLINE_USERS")
    static let SOCKET_RECONNECTED           =   Notification.Name("SOCKET_RECONNECTED")
}

struct ApiEndpoints {
    
    static let sendOTP                  =   "authentication/send/otp"
    static let sendEmail                =   "authentication/send/email"
    static let verifyPhone              =   "authentication/verify/phone"
    static let verifyEmail              =   "authentication/verify/email"
    static let register                 =   "authentication/register"
    static let loginByFacebook          =   "authentication/login/by/facebook"
    static let loginByGoogle            =   "authentication/login/by/google"
    static let loginByApple             =   "authentication/login/by/apple"
    static let login                    =   "authentication/login"
    static let logout                   =   "authentication/logout"
    static let deleteAccount            =   "authentication/delete"
    static let resetPassword            =   "authentication/reset/password"
    static let frgtPswrdPhoneOTP        =   "authentication/send/phone/otp/forget/password"
    static let frgtPswrdEmailOTP        =   "authentication/send/mail/otp/forget/password"
    static let verifyFgtPswrdOTP        =   "authentication/forget/password/verify/otp"
    static let checkUsername            =   "authentication/check/username"
    static let checkPhoneEmail          =   "authentication/check/email/and/phone"
    
    static let getAllRooms              =   "room/getAll"
    static let userCreatedRooms         =   "room/get/rooms/created/by/user"
    static let getJoinedRooms           =   "room/get/rooms/joined/by/user"
    static let addRoom                  =   "room/add"
    static let getRoom                  =   "room/get"
    static let joinRoom                 =   "room/join"
    static let unjoinRoom               =   "room/cancle/room/joining"
    static let deleteRoom               =   "room/delete"
    static let updateRoom               =   "room/update"
    static let userListWithRoom         =   "room/get/user/list/with/room/details"
    static let friendUserProfile        =   "friends/get/user/profile"
    
    static let getCategories            =   "category/getAll"
    static let getAllDrinks             =   "drink/getAll"
    
    static let uploadImage              =   "upload"
    static let getProfile               =   "authentication/get/profile"
    static let updateProfile            =   "authentication/update/profile"
    
    static let sendFriendRequest        =   "friends/send/friend/request"
    static let getAllFriendsRequests    =   "friends/getAll/friend/requests"
    static let acceptFriendRequest      =   "friends/accept/friend/request"
    static let rejectFriendRequest      =   "friends/reject/friend/request"
    static let getFriendsList           =   "friends/getAll/friend/list"
    static let unfriend                 =   "friends/unfriend"
    
    static let getMovie                 =   "movie/get"
    static let getAllnotifications      =   "notification/getAll/notifications"

    static let searchRoom               =   "search/room"
    static let searchPeople             =   "search/user"
    static let recentSearch             =   "recent/search"
    static let recentConnectionDetails  =   "authentication/get/recent/suggestion/user/data"
    
    static let userBlock                =   "user/block"
    static let userUnblock              =   "user/unblock"
    
    static let getVisibility            =   "authentication/get/user/privacy"
    static let updateVisibility         =   "authentication/update/user/privacy"
    static let userPrefrences           =   "user/prefrences"
    
    static let getEventParticipant      =   "room/get/event/participant"
    static let getEventChannelID        =   "room/get/current/chat/event"
    static let roomVoteToRemove         =   "room/vote/to/remove"
    static let cancelVoteToRemove       =   "room/cancle/vote/to/remove"
    static let eventChatUserProfile     =   "room/event/user/profile"
    
    static let communityRulesURL        =   "content/get/slug/community-rule"
    static let privacySecurityURL       =   "content/get/slug/privacy-content"
    static let helpSupportFAQsURL       =   "content/get/slug/help-n-support"
    
    static let getActivity              =   "authentication/get/activity"
    static let updateActivity           =   "authentication/update/activity"
}


struct APIKeys {
    
    static let success              =   "SUCCESS"
    static let error                =   "ERROR"
    
    static let _id                  =   "_id"
    static let categoryId           =   "categoryId"
    static let isFreeOnMyCalendar   =   "isFreeOnMyCalendar"
    static let roomId               =   "roomId"
    static let userId               =   "userId"
    
    static let fname                =   "fname"
    static let lname                =   "lname"
    static let aboutYourself        =   "aboutYourself"
    static let roomName             =   "roomName"
//    static let date                 =   "date"
    static let startTime            =   "startTime"
    static let startDate            =   "startDate"
    static let endDate              =   "endDate"
    static let duration             =   "duration"
    static let about                =   "about"
    static let roomType             =   "roomType"
    static let profileImg           =   "profileImg"
    static let image                =   "image"
    static let roomClass            =   "roomClass"
    static let friendsArr           =   "friendsArr"
    static let mails                =   "mails"
    
    /// SOCKET PARAM KEYs
    static let senderId             =   "senderId"
    static let receiverId           =   "receiverId"
    static let chatHeadID           =   "chatHeadId"
    static let messageId            =   "messageId"
    static let message              =   "message"
    static let messageType          =   "messageType"
    static let readers              =   "readers"
    static let isTyping             =   "isTyping"
    static let reaction             =   "reaction"
    
    static let channelID            =   "channelId"
    
    static let type                 =   "type"
    static let id                   =   "id"
}


public struct DateFormats {
    
    static let MMddyyyy             =   "MM-dd-yyyy"
    static let yyyyMMdd             =   "yyyy-MM-dd"
    static let yyMMddTHHmmss        =   "yyyy-MM-dd'T'HH:mm:ss"
    static let yyyyMMddhhmma        =   "yyyy-MM-ddhh:mma"
    static let yyyyMMddTHHmmssSSSZ  =   "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let hhmm_a               =   "hh:mm a"
    static let hhmma                =   "hh:mma"
}
