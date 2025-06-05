//
//  ViewControllerExtension.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 05/06/2025.
//

import UIKit
import Connectivity

private var connectivityKey: UInt8 = 0
private var isConnectedKey: UInt8 = 0

extension UIViewController {
    
    private var connectivity: Connectivity? {
        get {
            return objc_getAssociatedObject(self, &connectivityKey) as? Connectivity
        }
        set {
            objc_setAssociatedObject(self, &connectivityKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var isConnected: Bool {
            get {
                return (objc_getAssociatedObject(self, &isConnectedKey) as? Bool) ?? true
            }
            set {
                objc_setAssociatedObject(self, &isConnectedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }

    func setupConnectivity() {
        if connectivity == nil {
            connectivity = Connectivity()
            connectivity?.startNotifier()

            connectivity?.whenConnected = { [weak self] connectivity in
                DispatchQueue.main.async {
                    self?.handleConnectivityChange(isConnected: true)
                }
            }

            connectivity?.whenDisconnected = { [weak self] connectivity in
                DispatchQueue.main.async {
                    self?.handleConnectivityChange(isConnected: false)
                }
            }

        }
    }
    
    func handleConnectivityChange(isConnected: Bool) {
        if self.isConnected != isConnected {
            self.isConnected = isConnected

            let message = isConnected ? "Internet connected" : "No internet connection"
            print(message)

            if isConnected {
                showAlert(title: "Internet!", message: "You're connected to the internet", view: self)
            } else {
                showAlert(title: "No Internet!", message: "Please check your connection", view: self)
            }
        }
    }

    
    func stopConnectivity() {
        connectivity?.stopNotifier()
        connectivity = nil
    }
}
