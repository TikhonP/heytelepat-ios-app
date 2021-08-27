//
//  Network.swift
//  Speaker
//
//  Created by Тихон on 19.08.2021.
//

import Foundation
import Network
import SystemConfiguration.CaptiveNetwork

final class NetworkMonitor: ObservableObject {
    private let monitor =  NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
    }
}

func currentSSIDs() -> [String] {
    guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
        print("Empty ssids.")
        return []
    }
    return interfaceNames.compactMap { name in
        guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
            return nil
        }
        guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
            return nil
        }
        return ssid
    }
}
