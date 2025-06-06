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
    func filterLocalArray(searchText: String)
}
class FavPresenter: FavPresenterProtocol{
    let favView: FavViewProtocol
    let local : LocalDataSourceProtocol
    private var localArr:[FavLeagueModel]?
    private var displayedArray:[FavLeagueModel]?
    
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
        displayedArray = localArr
        favView.showLeagues()
    }
    
    func deleteLeagueFromLocal(league: LeagueModel) {
        local.deleteLeague(leagueId: league.leagueKey)
        localArr?.removeAll(where: {$0.league.leagueKey == league.leagueKey})
        displayedArray = localArr
    }
    func getLocalArray() -> [FavLeagueModel]? {
        return self.displayedArray
    }
    
    func filterLocalArray(searchText: String) {
        displayedArray = searchText.isEmpty ? self.localArr : self.localArr?.filter({$0.league.leagueName.lowercased().contains(searchText.lowercased())})
        favView.showLeagues()
    }
}
