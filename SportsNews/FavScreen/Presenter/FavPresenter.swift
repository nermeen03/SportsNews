//
//  FavPresenter.swift
//  SportsNews
//
//  Created by mac on 27/05/2025.
//
protocol FavPresenterProtocol{
    func getLeaguesFromLocal()
    func filterLocalArray(searchText: String)
    func getleaguesCount()-> Int
    func deleteLeagueFromLocal(league: FavLeagueModel)
    func getleaguesBySportDict() -> [SportType : [FavLeagueModel]]
    var sortedSports: [SportType] { get }
}
class FavPresenter: FavPresenterProtocol{
    private var leaguesBySport: [SportType : [FavLeagueModel]] = [:]
    var sortedSports: [SportType] = []
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
        splitLocalArrayBySport()
        favView.showLeagues()
    }
    func isEmpty()->Bool{
        return leaguesBySport.isEmpty
    }
    
    func deleteLeagueFromLocal(league: FavLeagueModel) {
        local.deleteLeague(leagueId: league.league.leagueKey)
        localArr?.removeAll(where: {$0.league.leagueKey == league.league.leagueKey})
        displayedArray = localArr
        splitLocalArrayBySport()
    }
    
    func splitLocalArrayBySport() {
        guard let localArr = displayedArray else{
            return
        }
        leaguesBySport = Dictionary(grouping: localArr, by: {$0.sportType})
        sortedSports = leaguesBySport.keys.sorted { $0.rawValue < $1.rawValue }
    }
    
    func getleaguesBySportDict() -> [SportType : [FavLeagueModel]] {
        return self.leaguesBySport
    }
    
    func filterLocalArray(searchText: String) {
        if searchText.isEmpty {
                displayedArray = localArr
            } else {
                displayedArray = localArr?.filter {
                    $0.league.leagueName.lowercased().contains(searchText.lowercased())
                }
            }
        splitLocalArrayBySport()
        favView.showLeagues()
    }
    func getleaguesCount() -> Int {
        return sortedSports.count
    }
}
