//
//  LeaguesPresenter.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import Foundation

class LeaguesPresenter{
    
    let leaguesView: LeaguesProtocol
    
    init(leaguesView: LeaguesProtocol) {
        self.leaguesView = leaguesView
    }
    
    func getLeaguesFromNetwork(sportName : SportType){
        let network = NetworkServices()
        network.getAllSportLeagues(sportName: sportName) { data in
            self.leaguesView.showLeagues(leagues: data)
            print(data)
        }
    }
    
}
