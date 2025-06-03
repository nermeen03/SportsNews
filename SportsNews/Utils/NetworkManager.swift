//
//  NetworkManager.swift
//  SportsNews
//
//  Created by mac on 03/06/2025.
//
import Network

class NetworkMonitor {
    
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    private var currentStatus: NWPath.Status = .requiresConnection

    var onConnected: (() -> Void)?
    var onDisconnected: (() -> Void)?

    private init() {
        currentStatus = monitor.currentPath.status
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            let previousStatus = self.currentStatus
            self.currentStatus = path.status

            DispatchQueue.main.async {
                if path.status != .satisfied && previousStatus == .satisfied {
                    self.onConnected?()
                } else if path.status == .satisfied && previousStatus != .satisfied {
                    self.onDisconnected?()
                }
            }
        }
        monitor.start(queue: queue)
    }

    func isConnectedToInternet() -> Bool {
        return currentStatus == .satisfied
    }

    deinit {
        monitor.cancel()
    }
}
//class NetworkManager {
//    static func isInternetAvailable(completion: @escaping (Bool) -> Void) {
//        let monitor = NWPathMonitor()
//        let queue = DispatchQueue(label: "InternetConnectionMonitor")
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                completion(true)
//            } else {
//                completion(false)
//            }
//            monitor.cancel()
//        }
//        monitor.start(queue: queue)
//    }
//}
