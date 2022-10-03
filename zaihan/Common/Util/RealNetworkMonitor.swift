//
//  RealNetworkMonitor.swift
//  zaihan
//
//  Created by MYONHYUP LIM on 2022/09/04.
//

import Foundation
import Network
import Alamofire

final class RealNetworkMonitor{
    static let shared = RealNetworkMonitor()
    
    let networkReachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    func startMornitoring() {
        networkReachabilityManager?.startListening(onUpdatePerforming: { status in
            switch status {
                case .notReachable:
                    print("The network is not reachable")
                case .unknown :
                    print("It is unknown whether the network is reachable")
                case .reachable(.ethernetOrWiFi):
                    print("The network is reachable over the WiFi connection")
                case .reachable(.cellular):
                    print("The network is reachable over the cellular connection")
            }
        })
    }
    
    func stopListening() {
        networkReachabilityManager?.stopListening()
    }
    
    func isConnected() -> Bool {
        return networkReachabilityManager?.isReachable ?? false
    }
    
}
