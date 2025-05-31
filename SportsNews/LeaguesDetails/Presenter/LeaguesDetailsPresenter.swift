//
//  LeaguesDetailsPresenter.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import Foundation

class LeaguesDetailsPresenter {
    let leaguesView: LeaguesDetailsProtocol
    
    init(leaguesView: LeaguesDetailsProtocol) {
        self.leaguesView = leaguesView
    }
    
    func getDataFromNetwork(sportName: SportType, leagueId: Int){
        
        let network = NetworkServices()
        
        let (past, today, future) = calcDate()
        
//        network.getTeamsAndPlayers(sportName: sportName, leagueId: leagueId) { data in
//
//        }
        
        network.getFixtures(sportName: sportName, leagueKey: leagueId, fromData: past, toData: today) { data in
            self.leaguesView.renderPastFixtureToView(fixtureList: data)
        }
        
        network.getFixtures(sportName: sportName, leagueKey: leagueId, fromData: today, toData: future) { data in
            self.leaguesView.renderUpcomingFixtureToView(fixtureList: data)
        }
        
    }
    
    func calcDate() -> (String, String, String){
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let today = formatter.string(from: todayDate)
        print(today)
        
        let calendar = Calendar.current
        
        if let futureDate = calendar.date(byAdding: .day, value: 40, to: todayDate), let pastDate = calendar.date(byAdding: .day, value: -40, to: todayDate) {
            let future = formatter.string(from: futureDate)
            let past = formatter.string(from: pastDate)
            return(past, today, future)
        }
        return(today,today,today)
    }
    
}
