//
//  NetworkReachability.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import Alamofire

final class NetworkReachability {
    static let shared = NetworkReachability()
    private let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    
    private init() {}
    
    deinit {
        debugPrint("DEINIT \(String(describing: self))")
    }
    
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
                debugPrint("Unknown network state")
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
