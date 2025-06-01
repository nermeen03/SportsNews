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
}
class LeaguesPresenter: LeaguesPresenterProtocol{
    
    let leaguesView: LeaguesProtocol
    let network = NetworkServices()
    let local = LocalDataSource.shared
    var localArr:[LeagueModel]?
    init(leaguesView: LeaguesProtocol) {
        self.leaguesView = leaguesView
    }
    
    func getLeaguesFromNetwork(sportName : SportType){
        getLeaguesFromLocal(sportName: sportName)
        network.getAllSportLeagues(sportName: sportName) { data in
            var updatedData = data
            
            for i in 0..<updatedData.count {
                if self.localArr?.contains(where: { $0.leagueKey == updatedData[i].leagueKey }) ?? false {
                    updatedData[i].isFav = true
                }
            }
            
            self.leaguesView.showLeagues(leagues: updatedData)
        }
    }
    func getLeaguesFromLocal(sportName: SportType) {
        localArr = local.getLeaguesBySport(sportType: sportName)
    }
    
    func saveLeagueToLocal(league: any LeagueModel, sportName : SportType) {
        local.saveLeague(league: league, sportType: sportName)
    }
    
    func deleteLeagueFromLocal(league: any LeagueModel) {
        local.deleteLeague(league: league)
    }
    
    
}
