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
    func cancelApiCallings()
}
class LeaguesPresenter: LeaguesPresenterProtocol{
    
    let leaguesView: LeaguesProtocol
    let network = NetworkServices()
    let local = LocalDataSource.shared
    var localArr:[LeagueModel]?
    var remoteArr:[LeagueModel]!
    
    var shouldCancelTranslation = false
    
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
        if isEnglish() || sportName == .football{
            self.remoteArr = updatedData
            self.leaguesView.showLeagues()
        }else if !isEnglish() && sportName != .football{
            translateLeaguesInChunks(updatedData, chunkSize: 10,
                onBatchComplete: { translatedSoFar in
                    self.remoteArr = translatedSoFar
                self.leaguesView.showLeagues()
                },
                onAllComplete: {
                    print("All league names translated to Arabic")
                }
            )
        }
    }
    
    func translateLeaguesInChunks(_ leagues: [LeagueModel],
                                  chunkSize: Int = 10,
                                  onBatchComplete: @escaping ([LeagueModel]) -> Void,
                                  onAllComplete: @escaping () -> Void) {
        
        var allTranslated: [LeagueModel] = remoteArr

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
                }

                allTranslated += translatedChunk
                onBatchComplete(allTranslated)
                processChunk(startIndex: endIndex)
            }
        }

        processChunk(startIndex: 0)
    }


    
    func getLeagueNameTranslated(league:LeagueModel,sportName:SportType) {
        var savedLeague = league
        if isEnglish() || sportName != .football{
            network.translateText(text: savedLeague.leagueName,sourceLang: "en",targetLang: "ar"){[weak self] result in
                print(result)
            self?.local.saveLeague(league: league, sportType: sportName,sportName: result)
        }
        }else{
            network.translateText(text: savedLeague.leagueName,sourceLang: "ar",targetLang: "en"){[weak self] result in
                print(result)
                savedLeague.leagueName = result
                self?.local.saveLeague(league: savedLeague, sportType: sportName,sportName: league.leagueName)
            }
            
        }
    }
    
    func cancelApiCallings() {
        self.shouldCancelTranslation = true
    }
    
}
