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
        let network = NetworkServices()
        
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let today = formatter.string(from: todayDate)
        print(today)
        
        let calendar = Calendar.current
        
        guard let futureDate = calendar.date(byAdding: .day, value: 20, to: todayDate) else{return}
        let future = formatter.string(from: futureDate)
        print(future)

        guard let pastDate = calendar.date(byAdding: .day, value: -20, to: todayDate) else{return}
        let past = formatter.string(from: pastDate)
        print(past)
        
        // football, basketball, cricket, tennis
        
        network.getAllSportLeagues(sportName: "cricket")
        network.getFixtures(sportName: "cricket", leagueKey: 96, fromData: past, toData: today)
        network.getFixtures(sportName: "cricket", leagueKey: 96, fromData: today, toData: future)
        network.getTeamsAndPlayers(sportName: "cricket", leagueId: 96)
    }

    @IBAction func ToFav(_ sender: Any) {
        let story = UIStoryboard.init(name: "Fav", bundle: nil)
        let fav = story.instantiateViewController(identifier: "Fav")
        navigationController?.present(fav, animated: true, completion: nil)
    }
    
}

