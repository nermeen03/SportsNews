//
//  FavPresenter.swift
//  SportsNews
//
//  Created by mac on 27/05/2025.
//
protocol FavPresenterProtocol{
    func getLeaguesFromLocal()
    func deleteLeagueFromLocal(league:LeagueModel)
    func getLocalArray()->[FavLeagueModel]
}
class FavPresenter: FavPresenterProtocol{
    let favView: FavViewProtocol
    let local : LocalDataSourceProtocol
    private var localArr:[FavLeagueModel]?
    
    init(favView: FavViewProtocol, local: LocalDataSourceProtocol, localArr: [FavLeagueModel]? = nil) {
        self.favView = favView
        self.local = local
        self.localArr = localArr
    }
    
    func getLeaguesFromLocal() {
        localArr = local.getAllLeagues()
        favView.showLeagues()
    }
    
    func deleteLeagueFromLocal(league: any LeagueModel) {
        local.deleteLeague(league: league)
        localArr?.removeAll(where: {$0.league.leagueKey == league.leagueKey})
    }
    func getLocalArray() -> [FavLeagueModel] {
        return self.localArr ?? []
    }
    
}
