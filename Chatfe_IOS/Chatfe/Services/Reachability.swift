//
//  Reachability.swift
//  Chatfe
//
//  Created by Piyush Mohan on 05/04/22.
//

import Foundation
import SystemConfiguration

let reachabilityStatusChangedNotification = "ReachabilityStatusChangedNotification"

enum ReachabilityType: CustomStringConvertible {
    case wwan
    case wifi
    var description: String {
        switch self {
        case .wwan:
            return "WWAN"
        case .wifi:
            return "WiFi"
    }
}
    
}

enum ReachabilityStatus: CustomStringConvertible {
    case offline
    case online(ReachabilityType)
    case unknown
    var description: String {
        switch self {
        case .offline:
            return "Offline"
        case .online(let type):
            return "Online (\(type))"
        case .unknown:
            return "Unknown"
        }
    }
}

public class Reachability {
    func connectionStatus() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, { $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
        }) else {
            return .unknown
        }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .unknown
        }
        return ReachabilityStatus(reachabilityFlags: flags)
    }
    
    func monitorReachabilityChanges() {
        let host = "www.google.com"
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        let reachability = SCNetworkReachabilityCreateWithName(nil, host)!
        SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
            let status = ReachabilityStatus(reachabilityFlags: flags)
            NotificationCenter.default.post(name: Notification.Name(rawValue: reachabilityStatusChangedNotification), object: nil, userInfo: ["Status": status.description])
        }, &context)
        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), RunLoop.Mode.common as CFString)
    }
}

public func isInternetReachable() -> Bool {
    let status = Reachability().connectionStatus()
    switch status {
    case .unknown, .offline:
        return false
    case .online(.wwan):
        return true
    case .online(.wifi):
        return true
    }
}

extension ReachabilityStatus {
    init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .online(.wwan)
            } else {
                self = .online(.wifi)
            }
        }  else {
            self = .offline
        }
    }
}



