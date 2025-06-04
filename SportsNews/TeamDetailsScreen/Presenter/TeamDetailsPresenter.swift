//
//  TeamDetailsPresenter.swift
//  SportsNews
//
//  Created by mac on 29/05/2025.
//
import Foundation

protocol TeamDetailsPresenterProtocol{
    func getNamesToTranslate(from team: FootballTeam) -> [String]
    func assignTranslatedNames(to team: inout FootballTeam, translatedString: [String])
    func translateNames(team: FootballTeam)
}
class TeamDetailsPresenter:TeamDetailsPresenterProtocol{

    var view: TeamDetailsViewProtocol
    var network = NetworkServices()
    init(view: TeamDetailsViewProtocol) {
        self.view = view
    }
    
    func getNamesToTranslate(from team: FootballTeam) -> [String]{
        let playerNames = team.players?.compactMap { $0.playerName } ?? []
        let coachNames = team.coaches?.compactMap { $0.coachName } ?? []
        let allNames = playerNames + coachNames
        return allNames
    }
    
    func assignTranslatedNames(to team: inout FootballTeam, translatedString: [String]) {
        let translatedNames = translatedString
        let playerCount = team.players?.count ?? 0
        let coachCount = team.coaches?.count ?? 0
        
        guard translatedNames.count == playerCount + coachCount else {
            print("Mismatch in translated names count.")
            return
        }
        
        for i in 0..<playerCount {
            team.players?[i].playerName = translatedNames[i]
        }
        
        for j in 0..<coachCount {
            team.coaches?[j].coachName = translatedNames[playerCount + j]
        }
    }
    func translateNames(team: FootballTeam) {
        var team = team
        let names = getNamesToTranslate(from: team)
        var translatedNames: [String] = Array(repeating: "", count: names.count)
        
        print(" Starting translation for \(names.count) names...")
        
        func translateNext(index: Int) {
        
            if index >= names.count {
                print(" Finished translating all names.")
                self.assignTranslatedNames(to: &team, translatedString: translatedNames)
                self.view.showData(team: team)
                return
            }
            
            let currentName = names[index]
            print(" Translating [\(index)]: \(currentName)")
            
            self.network.getTranslationForName(name: currentName) { translated in
                print(" Translated [\(index)]: \(currentName) → \(translated)")
                translatedNames[index] = translated
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    translateNext(index: index + 1)
                }
            }
        }
        
        translateNext(index: 0)
    }
}
