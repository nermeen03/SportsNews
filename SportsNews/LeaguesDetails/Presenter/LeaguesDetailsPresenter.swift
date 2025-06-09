//
//  LeaguesDetailsPresenter.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import Foundation
import UIKit
protocol LeaguesDetailsPresenterProtocol{
    func getDataFromNetwork(sportName: SportType, leagueId: Int)
    func calcDate(sportType: SportType) -> (String, String, String)
    func saveLeagueToLocal(league:LeagueModel, sportName : SportType)
    func deleteLeagueFromLocal(league:LeagueModel)
    func checkFav(leagueID:Int)->Bool
}

class LeaguesDetailsPresenter : LeaguesDetailsPresenterProtocol{
    let leaguesView: LeaguesDetailsProtocol
    let network : NetworkServices
    let local : LocalDataSource
    init(leaguesView: LeaguesDetailsProtocol) {
        self.leaguesView = leaguesView
        network = NetworkServices()
        local = LocalDataSource.shared
    }
    
    func getDataFromNetwork(sportName: SportType, leagueId: Int){
        
        let network = NetworkServices()
        
        let (past, today, future) = calcDate(sportType: sportName)
        
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
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
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
    func saveLeagueToLocal(league:LeagueModel, sportName : SportType) {
        self.local.saveLeague(league: league, sportType: sportName,sportName: league.leagueName)
        self.getLeagueNameTranslated(league: league, sportName: sportName)
    }
    
    func deleteLeagueFromLocal(league:LeagueModel) {
        local.deleteLeague(leagueId: league.leagueKey)
    }
    
    func getLeagueNameTranslated(league:LeagueModel,sportName:SportType) {
        var savedLeague = league
        if isEnglish() || sportName != .football{
            network.translateText(text: savedLeague.leagueName,sourceLang: "en",targetLang: "ar"){[weak self] result in
//                print(result)
                self?.local.updateLeagueArabicName(leagueId: league.leagueKey, name: result)
        }
        }else{
            network.translateText(text: savedLeague.leagueName,sourceLang: "ar",targetLang: "en"){[weak self] result in
//                print(result)
                savedLeague.leagueName = result
                self?.local.updateLeagueEnglishName(leagueId: league.leagueKey, name: result)
            }
            
        }
    }
    func checkFav(leagueID:Int)->Bool{
        return local.checkLeagueByID(leagueID: leagueID)
    }
}
