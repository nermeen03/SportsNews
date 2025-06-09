//
//  LeaguesPresenter.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 29/05/2025.
//

import Foundation

protocol LeaguesPresenterProtocol{
    var leagues: [LeagueModel] { get }
    var filteredLeagues: [LeagueModel] { get }
    var isFiltering: Bool { get }
    func getLeaguesFromNetwork(sportName : SportType)
    func getLeaguesFromLocal(sportName : SportType)
    func saveLeagueToLocal(league:LeagueModel, sportName : SportType)
    func deleteLeagueFromLocal(league:LeagueModel)
    func getLeagues() -> [LeagueModel]
    func checkFav(sportName : SportType)
    func getData(sportName : SportType, leagueList: [LeagueModel])
    func cancelApiCallings()
    func filterLeagues(with searchText: String)
    func getSecondName(index:Int) -> String
}
class LeaguesPresenter: LeaguesPresenterProtocol{

    var filteredLeagues: [LeagueModel]
    var isFiltering: Bool
    let leaguesView: LeaguesProtocol
    let network = NetworkServices()
    let local = LocalDataSource.shared
    var localArr:[LeagueModel]?
    var englishArr:[LeagueModel]?
    var arabicArr:[LeagueModel]?
    var leagues:[LeagueModel]
    var shouldCancelTranslation = false
    
    init(leaguesView: LeaguesProtocol) {
        self.leaguesView = leaguesView
        leagues = []
        filteredLeagues = []
        isFiltering = false
    }
    
    func getLeaguesFromNetwork(sportName : SportType){
        network.getAllSportLeagues(sportName: sportName,lang: false) {[weak self] data in
            self?.englishArr = data
            if(isEnglish() || sportName != .football){
                self?.getData(sportName: sportName, leagueList: data)
            }
                
        }
        if sportName == .football{ // arabic
            network.getAllSportLeagues(sportName: sportName,lang: true) {[weak self] data in
                self?.arabicArr = data
                if(!isEnglish()){
                    self?.getData(sportName: sportName, leagueList: data)
                }
            }
        }
    }
    func getLeaguesFromLocal(sportName: SportType) {
        localArr = local.getLeaguesBySport(sportType: sportName)
    }
    
    func saveLeagueToLocal(league:LeagueModel, sportName : SportType) {
        shouldCancelTranslation = true
        if let index = leagues.firstIndex(where: { $0.leagueKey == league.leagueKey }) {
            leagues[index] = league
        }
        if isEnglish(){
            self.local.saveLeague(league: league, sportType: sportName,sportName: league.leagueName)
            self.getLeagueNameTranslated(league: league, sportName: sportName)
        }else{ // arabic
            var league = league
            let arabicName = league.leagueName
            league.leagueName = englishArr!.filter({$0.leagueKey == league.leagueKey})[0].leagueName
            print(league.leagueName + "eng" + arabicName)
            self.local.saveLeague(league: league, sportType: sportName,sportName: arabicName)
        }
        
    }
    
    func deleteLeagueFromLocal(league:LeagueModel) {
        if let index = leagues.firstIndex(where: { $0.leagueKey == league.leagueKey }) {
            leagues[index] = league
        }
        local.deleteLeague(leagueId: league.leagueKey)
    }
    func getLeagues() -> [LeagueModel] {
        return leagues
    }
    
    func getData(sportName : SportType, leagueList: [LeagueModel]){
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
        if isEnglish() || sportName == .football{
            self.leagues = updatedData
            self.leaguesView.showLeagues()
        }else {
            translateLeaguesInChunks(updatedData, chunkSize: 10,
                                     onBatchComplete: { translatedSoFar in
                self.leagues += translatedSoFar
                self.leaguesView.showLeagues()
            },
                                     onAllComplete: {
                //                for league in self.leagues{
                //                    print(league.leagueName)
                //                }
                print("All league names translated to Arabic")
            }
            )
        }
    }
    
    func checkFav(sportName : SportType){
        var updatedData = filteredLeagues
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
        self.filteredLeagues = updatedData
        updatedData = leagues
        for i in 0..<updatedData.count {
            if self.localArr?.contains(where: { $0.leagueKey == updatedData[i].leagueKey }) ?? false {
                updatedData[i].isFav = true
            }else{
                if (updatedData[i].isFav == true){
                    updatedData[i].isFav = false
                }
            }
        }
        leagues = updatedData
        self.leaguesView.showLeagues()
    }
    
    func translateLeaguesInChunks(_ leagues: [LeagueModel],
                                  chunkSize: Int = 10,
                                  onBatchComplete: @escaping ([LeagueModel]) -> Void,
                                  onAllComplete: @escaping () -> Void) {
        
        var allTranslated: [LeagueModel] = []

        func processChunk(startIndex: Int) {
            
            guard !self.shouldCancelTranslation else {
                print("Translation cancelled")
                return
            }
    
            let endIndex = min(startIndex + chunkSize, leagues.count)
            if startIndex >= endIndex {
                onAllComplete()
                return
            }

            let chunk = Array(leagues[startIndex..<endIndex])
            let names = chunk.map { $0.leagueName }

            network.translate(texts: names, sourceLang: "en", targetLang: "ar") { translatedNames in
                var translatedChunk = chunk
                for i in 0..<translatedNames.count {
                    translatedChunk[i].leagueName = translatedNames[i]
//                    print(translatedNames[i])
                }

                allTranslated = translatedChunk
                onBatchComplete(allTranslated)
                processChunk(startIndex: endIndex)
            }
        }

        processChunk(startIndex: 0)
    }


    
    func getLeagueNameTranslated(league:LeagueModel,sportName:SportType) {
        if sportName != .football{
            network.translateText(text: league.leagueName,sourceLang: "en",targetLang: "ar"){[weak self] result in
//                print(result)
                self?.local.updateLeagueArabicName(leagueId: league.leagueKey, name: result)
            }
        }else{
            network.getAllSportLeagues(sportName: sportName, lang: true, completion: { [weak self] leagues in
                let league = leagues.filter({$0.leagueKey == league.leagueKey})[0]
                self?.local.updateLeagueArabicName(leagueId: league.leagueKey, name: league.leagueName)
            })
        }
    }
    
    func cancelApiCallings() {
        self.shouldCancelTranslation = true
    }
    
    func filterLeagues(with searchText: String) {
        if searchText.isEmpty {
            isFiltering = false
            filteredLeagues = []
        } else {
            isFiltering = true
            filteredLeagues = leagues.filter {
                $0.leagueName.lowercased().contains(searchText.lowercased())
            }
        }
        leaguesView.showLeagues()
    }
    func getSecondName(index:Int) -> String{
        if isEnglish(){
            return self.arabicArr?[index].leagueName ?? ""
        }else{
            return self.englishArr?[index].leagueName ?? ""
        }
    }
}
