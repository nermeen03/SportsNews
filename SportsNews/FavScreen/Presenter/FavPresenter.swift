//
//  FavPresenter.swift
//  SportsNews
//
//  Created by mac on 27/05/2025.
//
protocol FavPresenterProtocol{
    func getLeaguesFromLocal()
    func deleteLeagueFromLocal(league:FavLeagueModel)
//    func getLocalArray()->[FavLeagueModel]?
    func filterLocalArray(searchText: String)
    var filteredLeaguesBySport: [SportType: [FavLeagueModel]] { get }
    var filteredSortedSports: [SportType] { get }
    func getleaguesBySportCount()-> Int
    func isEmpty()->Bool
}
class FavPresenter: FavPresenterProtocol{
    var filteredLeaguesBySport: [SportType : [FavLeagueModel]] = [:]
    var filteredSortedSports: [SportType] = []
    private var leaguesBySport: [SportType : [FavLeagueModel]] = [:]
    private var sortedSports: [SportType] = []
    let favView: FavViewProtocol
    let local : LocalDataSourceProtocol
    private var localArr:[FavLeagueModel]?
//    private var displayedArray:[FavLeagueModel]?
    
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
        guard let localArr = localArr else{
            return
        }
        leaguesBySport = Dictionary(grouping: localArr, by: { $0.sportType})
        sortedSports = filteredLeaguesBySport.keys.sorted { $0.rawValue < $1.rawValue }
        filteredLeaguesBySport = leaguesBySport
        filteredSortedSports = sortedSports
//        displayedArray = localArr
        favView.showLeagues()
    }
    func isEmpty()->Bool{
        return leaguesBySport.isEmpty
    }
    
    func deleteLeagueFromLocal(league: FavLeagueModel) {
        local.deleteLeague(leagueId: league.league.leagueKey)
        localArr?.removeAll(where: {$0.league.leagueKey == league.league.leagueKey})
        if var leagues = leaguesBySport[league.sportType] {
                leagues.removeAll(where: { $0.league.leagueKey == league.league.leagueKey })
                if leagues.isEmpty {
                    leaguesBySport.removeValue(forKey: league.sportType)
                } else {
                    leaguesBySport[league.sportType] = leagues
                }
            }
        sortedSports = leaguesBySport.keys.sorted { $0.rawValue < $1.rawValue }
        filteredLeaguesBySport = leaguesBySport
        filteredSortedSports = sortedSports
    }
//    func getLocalArray() -> [FavLeagueModel]? {
//        return self.displayedArray
//    }
    
    func filterLocalArray(searchText: String) {
        if searchText.isEmpty {
                filteredLeaguesBySport = self.leaguesBySport
            } else {
                filteredLeaguesBySport = self.leaguesBySport.compactMapValues { leagues in
                    let filteredLeagues = leagues.filter {
                        $0.league.leagueName.lowercased().contains(searchText.lowercased())
                    }
                    return filteredLeagues.isEmpty ? nil : filteredLeagues
                }
            }
        filteredSortedSports = filteredLeaguesBySport.keys.sorted { $0.rawValue < $1.rawValue }
        favView.showLeagues()
    }
    func getleaguesBySportCount() -> Int {
        return leaguesBySport.count
    }
}
