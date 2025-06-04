//
//  LeaguesPresenter.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import Foundation

protocol LeaguesPresenterProtocol{
    func getLeaguesFromNetwork(sportName : SportType)
    func getLeaguesFromLocal(sportName : SportType)
    func saveLeagueToLocal(league:LeagueModel, sportName : SportType)
    func deleteLeagueFromLocal(league:LeagueModel)
    func getLeagues() -> [LeagueModel]
    func checkFav(sportName : SportType, leagueList: [LeagueModel])
}
class LeaguesPresenter: LeaguesPresenterProtocol{
    
    let leaguesView: LeaguesProtocol
    let network = NetworkServices()
    let local = LocalDataSource.shared
    var localArr:[LeagueModel]?
    var remoteArr:[LeagueModel]!
    init(leaguesView: LeaguesProtocol) {
        self.leaguesView = leaguesView
        remoteArr = []
    }
    
    func getLeaguesFromNetwork(sportName : SportType){
        network.getAllSportLeagues(sportName: sportName,lang: !isEnglish()) {[weak self] data in
            self?.checkFav(sportName: sportName, leagueList: data)
        }
    }
    func getLeaguesFromLocal(sportName: SportType) {
        localArr = local.getLeaguesBySport(sportType: sportName)
    }
    
    func saveLeagueToLocal(league: any LeagueModel, sportName : SportType) {
        if let index = remoteArr.firstIndex(where: { $0.leagueKey == league.leagueKey }) {
            remoteArr[index] = league
        }
        
        self.getLeagueNameTranslated(league: league, sportName: sportName)
    }
    
    func deleteLeagueFromLocal(league: any LeagueModel) {
        if let index = remoteArr.firstIndex(where: { $0.leagueKey == league.leagueKey }) {
            remoteArr[index] = league
        }
        local.deleteLeague(league: league)
    }
    func getLeagues() -> [LeagueModel] {
        return remoteArr ?? []
    }
    
    func checkFav(sportName : SportType, leagueList: [LeagueModel]){
        var updatedData = leagueList
        getLeaguesFromLocal(sportName: sportName)
        for i in 0..<updatedData.count {
            if self.localArr?.contains(where: { $0.leagueKey == updatedData[i].leagueKey }) ?? false {
                    updatedData[i].isFav = true
            }else{
                if (updatedData[i].isFav == true){
                    updatedData[i].isFav = false
                }
            }
        }
        self.remoteArr = updatedData
        self.leaguesView.showLeagues()
    }
    
    func getLeagueNameTranslated(league:LeagueModel,sportName:SportType) {
        var savedLeague = league
        if isEnglish() || sportName != .football{
            network.translate(text: savedLeague.leagueName,sourceLang: "en",targetLang: "ar"){[weak self] result in
                print(result)
            self?.local.saveLeague(league: league, sportType: sportName,sportName: result)
        }
        }else{
            network.translate(text: savedLeague.leagueName,sourceLang: "ar",targetLang: "en"){[weak self] result in
                print(result)
                savedLeague.leagueName = result
                self?.local.saveLeague(league: savedLeague, sportType: sportName,sportName: league.leagueName)
            }
            
        }
    }
    
}
