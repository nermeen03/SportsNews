//
//  OnBoardingViewController.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 02/06/2025.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var firstScreen: UIImageView?
    @IBOutlet weak var secondScreen: UIImageView?
    @IBOutlet weak var thirdScreen: UIImageView?
    @IBOutlet weak var forthScreen: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        enableTap(on: firstScreen, action: #selector(firstTapped))
        enableTap(on: secondScreen, action: #selector(secondTapped))
        enableTap(on: thirdScreen, action: #selector(thirdTapped))
        enableTap(on: forthScreen, action: #selector(forthTapped))
    }

    private func enableTap(on imageView: UIImageView?, action: Selector) {
        imageView?.isUserInteractionEnabled = true
        imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
    }

    @objc func firstTapped() {
        navigateTo(screenId: "second")
    }

    @objc func secondTapped() {
        navigateTo(screenId: "third")
    }

    @objc func thirdTapped() {
        navigateTo(screenId: "forth")
    }

    @objc func forthTapped() {
        navigateTo(screenId: "fifth")
    }

    private func navigateTo(screenId: String) {
        if let nextVC = storyboard?.instantiateViewController(identifier: screenId) {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func fifthScreen(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        UserDefaults.standard.synchronize()
        
        createScreens()

    }
    
}
