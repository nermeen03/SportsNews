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
        
        let (past, today, future) = calcDate(sportType: sportName)
        
//        network.getTeamsAndPlayers(sportName: sportName, leagueId: leagueId) { data in
//
//        }
        
        network.getFixtures(sportName: sportName,lang: !isEnglish(), leagueKey: leagueId, fromData: past, toData: today) { data in
            self.leaguesView.renderPastFixtureToView(fixtureList: data)
        }
        
        network.getFixtures(sportName: sportName,lang: !isEnglish(), leagueKey: leagueId, fromData: today, toData: future) { data in
            self.leaguesView.renderUpcomingFixtureToView(fixtureList: data)
        }
        
        switch sportName {
            case .tennis:
                network.getTeamsAndPlayers(sportName: sportName,lang: !isEnglish(), leagueId: leagueId, responseType: TennisPlayer.self) { players in self.leaguesView.renderPlayersToView(players: players)}
            default :
                network.getTeamsAndPlayers(sportName: sportName,lang: !isEnglish(), leagueId: leagueId, responseType: FootballTeam.self) { teams in self.leaguesView.renderTeamsToView(teams: teams)}
        }
    }
    
    func calcDate(sportType: SportType) -> (String, String, String){
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let today = formatter.string(from: todayDate)
        
        let calendar = Calendar.current
        switch sportType {
        case .tennis:
            if let futureDate = calendar.date(byAdding: .day, value: 40, to: todayDate), let pastDate = calendar.date(byAdding: .day, value: -5*365, to: todayDate) {
                let future = formatter.string(from: futureDate)
                let past = formatter.string(from: pastDate)
                return(past, today, future)
            }
        case .cricket:
            if let futureDate = calendar.date(byAdding: .day, value: 40, to: todayDate), let pastDate = calendar.date(byAdding: .day, value: -5*365, to: todayDate) {
                let future = formatter.string(from: futureDate)
                let past = formatter.string(from: pastDate)
                return(past, today, future)
            }
        default:
            if let futureDate = calendar.date(byAdding: .day, value: 40, to: todayDate), let pastDate = calendar.date(byAdding: .day, value: -40, to: todayDate) {
                let future = formatter.string(from: futureDate)
                let past = formatter.string(from: pastDate)
                return(past, today, future)
            }
        }
        return(today,today,today)
    }
    
}
