//
//  Persistence.swift
//  WavesMusicApp
//
//  Created by Mukesh Kumar on 17/01/22.
//  Copyright © 2022 Surjeet Singh. All rights reserved.
//

import Foundation
import AuthenticationServices

class Persistence {
    
    private static let kAccessToken = "access_token"

    
    // MARK: - Codable Property List Persistence Wrapper
    private static func cache<T>(_ toCache: T?, forKey: String) where T: Encodable {
        guard let toCache = toCache else {
            return UserDefaults.standard.set(nil, forKey: forKey)
        }

        let encoder = PropertyListEncoder()
        let encoded = try? encoder.encode(toCache)

        UserDefaults.standard.set(encoded, forKey: forKey)
    }

    private static func cached<T>(forKey: String) -> T? where T: Decodable {
        let decoder = PropertyListDecoder()

        guard let encoded = UserDefaults.standard.data(forKey: forKey) else {
            return nil
        }

        let decoded = try? decoder.decode(T.self, from: encoded)

        return decoded
    }

    


    // MARK: - Signed In User Persistence
/*    static func cacheUser(_ user: LoginModel?) {
        cache(user, forKey: kUser)
    }

    static func cachedUser() -> LoginModel? {
        return cached(forKey: kUser)
    }

    static func clearCachedUser() {
        UserDefaults.standard.removeObject(forKey: kUser)
    }
*/
    static func cacheJoinedRooms(_ data: [RoomJoinedData]?) {
        cache(data, forKey: "USER_JOINED_ROOMS")
    }
    
    static func cachedJoinedRooms() -> [RoomJoinedData]? {
        return cached(forKey: "USER_JOINED_ROOMS")
    }
    
    
    // SAVE & GET ONGOING EVENT
    static func cacheOngoingRoom(_ data: RoomJoinedData?) {
        cache(data, forKey: "ONGING_ROOMS")
    }
    
    static func cachedOngoingRoom() -> RoomJoinedData? {
        return cached(forKey: "ONGING_ROOMS")
    }
    
    static func removeOngoingRoom() {
        UserDefaults.standard.removeObject(forKey: "ONGING_ROOMS")
    }
}
