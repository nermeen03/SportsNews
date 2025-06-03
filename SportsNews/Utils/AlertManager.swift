//
//  AlertManager.swift
//  SportsNews
//
//  Created by mac on 03/06/2025.
//
import UIKit
func showAlert(title: String, message: String, view: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    view.present(alert, animated: true)
}
