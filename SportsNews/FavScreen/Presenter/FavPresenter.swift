//
//  FavPresenter.swift
//  SportsNews
//
//  Created by mac on 27/05/2025.
//
protocol FavPresenterProtocol{
    func getLeaguesFromLocal()
    func deleteLeagueFromLocal(league:LeagueModel)
    func getLocalArray()->[FavLeagueModel]?
}
class FavPresenter: FavPresenterProtocol{
    let favView: FavViewProtocol
    let local : LocalDataSourceProtocol
    private var localArr:[FavLeagueModel]?
    
    init(favView: FavViewProtocol, local: LocalDataSourceProtocol) {
        self.favView = favView
        self.local = local
    }
    
    func getLeaguesFromLocal() {
        if isEnglish(){
            localArr = local.getAllLeagues()
        }
        else {
            localArr = local.getAllArabicLeagues()
        }
        favView.showLeagues()
    }
    
    func deleteLeagueFromLocal(league: LeagueModel) {
        local.deleteLeague(leagueId: league.leagueKey)
        localArr?.removeAll(where: {$0.league.leagueKey == league.leagueKey})
    }
    func getLocalArray() -> [FavLeagueModel]? {
        return self.localArr
    }
    
}
