//
//  SplashScreenViewController.swift
//  SportsNews
//
//  Created by mac on 02/06/2025.
//

import UIKit
import Lottie

class SplashScreenViewController: UIViewController {

    private var animationView: LottieAnimationView?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Initialize with your Lottie file name (without extension)
            animationView = LottieAnimationView(name: "splash")
            
            guard let animationView = animationView else { return }
            
            animationView.frame = view.bounds
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.animationSpeed = 1.0
            
            view.addSubview(animationView)
            
            animationView.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { 
                guard let window = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first?.windows
                    .first else { return }
                
                let hasSeen = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
                if hasSeen {
                    createScreens()
                }else{
                    let onboardingVC = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "nav")
                    window.rootViewController = onboardingVC
                    window.makeKeyAndVisible()
                }
            }
        }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
