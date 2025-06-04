//
//  Nav.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 02/06/2025.
//

import Foundation
import UIKit

func createScreens(){
    let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
    let favStoryboard = UIStoryboard(name: "Fav", bundle: nil)

    guard let homeVC = homeStoryboard.instantiateInitialViewController(),
          let favVC = favStoryboard.instantiateInitialViewController() else {
        print("Error: Couldn't instantiate view controllers")
        return
    }

    homeVC.tabBarItem = UITabBarItem(title: "Home".localized, image: UIImage(systemName: "house.fill"), tag: 0)
    favVC.tabBarItem = UITabBarItem(title: "Favorite".localized, image: UIImage(systemName: "heart.fill"), tag: 1)

    let tabBarController = UITabBarController()
    tabBarController.viewControllers = [homeVC, favVC]

    if let sceneDelegate = UIApplication.shared.connectedScenes
        .first?.delegate as? SceneDelegate {
        sceneDelegate.window?.rootViewController = tabBarController
        sceneDelegate.window?.makeKeyAndVisible()
    }
}
