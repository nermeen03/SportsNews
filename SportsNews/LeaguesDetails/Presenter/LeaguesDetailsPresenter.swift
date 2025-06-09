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
    func saveLeagueToLocal(league:LeagueModel, sportName : SportType, secondName: String)
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
    func saveLeagueToLocal(league:LeagueModel, sportName : SportType, secondName: String) {
        
        
        if isEnglish(){
            self.local.saveLeague(league: league, sportType: sportName,sportName: secondName)
            self.getLeagueNameTranslated(league: league, sportName: sportName)
        }else{
            var league = league
            let arabicName = league.leagueName
            league.leagueName = secondName
            self.local.saveLeague(league: league, sportType: sportName,sportName: arabicName)
        }
    }
    
    func deleteLeagueFromLocal(league:LeagueModel) {
        local.deleteLeague(leagueId: league.leagueKey)
    }
    
    func getLeagueNameTranslated(league:LeagueModel,sportName:SportType) {
        if sportName != .football{
            network.translateText(text: league.leagueName,sourceLang: "en",targetLang: "ar"){[weak self] result in
                self?.local.updateLeagueArabicName(leagueId: league.leagueKey, name: result)
            }
        }else{
            network.getAllSportLeagues(sportName: sportName, lang: true, completion: { [weak self] leagues in
                let league = leagues.filter({$0.leagueKey == league.leagueKey})[0]
                self?.local.updateLeagueArabicName(leagueId: league.leagueKey, name: league.leagueName)
            })
        }
    }
    func checkFav(leagueID:Int)->Bool{
        return local.checkLeagueByID(leagueID: leagueID)
    }
    
    
}
