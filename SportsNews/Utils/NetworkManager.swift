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
    private let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
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
                    self.onDisconnected?()
                } else if path.status == .satisfied && previousStatus != .satisfied {
                    self.onConnected?()
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func isConnectedToInternet() -> Bool {
        return currentStatus == .satisfied
    }

    func checkInternetConnection(completion: @escaping (Bool) -> Void) {
        let oneTimeMonitor = NWPathMonitor()
        let oneTimeQueue = DispatchQueue(label: "OneTimeInternetCheck")
        oneTimeMonitor.pathUpdateHandler = { path in
            completion(path.status == .satisfied)
            oneTimeMonitor.cancel()
        }
        oneTimeMonitor.start(queue: oneTimeQueue)
    }
    
    deinit {
        monitor.cancel()
    }
}
