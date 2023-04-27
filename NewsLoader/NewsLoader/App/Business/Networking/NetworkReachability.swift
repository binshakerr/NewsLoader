//
//  NetworkReachability.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import Alamofire

class NetworkReachability {
    static let shared = NetworkReachability()
    let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    
    func startNetworkMonitoring() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                NotificationCenter.default.post(name: .connectivityStatusChanged, object: nil, userInfo: ["status": false])
            case .reachable(.cellular):
                NotificationCenter.default.post(name: .connectivityStatusChanged, object: nil, userInfo: ["status": true])
            case .reachable(.ethernetOrWiFi):
                NotificationCenter.default.post(name: .connectivityStatusChanged, object: nil, userInfo: ["status": true])
            case .unknown:
                print("Unknown network state")
            }
        }
    }
    
    var status: NetworkReachabilityManager.NetworkReachabilityStatus {
        return reachabilityManager?.status ?? .notReachable
    }
}

extension Notification.Name {
    static let connectivityStatusChanged = Notification.Name("connectivityStatusChanged")
}
