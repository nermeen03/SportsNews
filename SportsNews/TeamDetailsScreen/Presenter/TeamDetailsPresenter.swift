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
        let teamName = [team.teamName]
        let playerNames = team.players?.compactMap { $0.playerName } ?? []
        let coachNames = team.coaches?.compactMap { $0.coachName } ?? []
        let allNames = playerNames + coachNames + teamName
        return allNames
    }
    
    func assignTranslatedNames(to team: inout FootballTeam, translatedString: [String]) {
        let translatedNames = translatedString
        let playerCount = team.players?.count ?? 0
        let coachCount = team.coaches?.count ?? 0
        
        guard translatedNames.count == playerCount + coachCount + 1 else {
            print("Mismatch in translated names count.")
            return
        }
        
        for i in 0..<playerCount {
            team.players?[i].playerName = translatedNames[i]
        }
        
        for j in 0..<coachCount {
            team.coaches?[j].coachName = translatedNames[playerCount + j]
        }
        team.teamName = translatedNames[playerCount + coachCount]
        print(team.teamName)
    }
    func translateNames(team: FootballTeam) {
        
        var mutableTeam = team
            let namesToTranslate = getNamesToTranslate(from: team)
            
            guard !namesToTranslate.isEmpty else {
                view.showData(team: team)
                return
            }

            network.translate(texts: namesToTranslate, sourceLang: "en", targetLang: "ar") { [weak self] translatedNames in
                guard let self = self else { return }
                self.assignTranslatedNames(to: &mutableTeam, translatedString: translatedNames)
                self.view.showData(team: mutableTeam)
            }
    }
}
