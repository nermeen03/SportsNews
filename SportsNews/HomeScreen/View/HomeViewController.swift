//
//  ViewController.swift
//  SportsNews
//
//  Created by mac on 27/05/2025.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let network = NetworkServices()
//        network.getTeamsAndPlayers()
        network.getAllFootballLeagues()
        network.getFixtures(leagueKey: 152)
    }

    @IBAction func ToFav(_ sender: Any) {
        let story = UIStoryboard.init(name: "Fav", bundle: nil)
        let fav = story.instantiateViewController(identifier: "Fav")
        navigationController?.present(fav, animated: true, completion: nil)
    }
    
}

