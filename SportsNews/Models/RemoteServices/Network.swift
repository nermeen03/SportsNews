//
//  Network.swift
//  SportsNews
//
//  Created by mac on 27/05/2025.
//

import Foundation
import Alamofire

class NetworkServices {
    private let key = "8128da79ca08268ed6ca69e25e85994d93942ca6259a6e61877535f6e6a54854"
    private let url = "https://apiv2.allsportsapi.com/"
    
    func getTeamsAndPlayers() {
        
        let leagueId = 96
        
        let url = self.url + "football//?&met=Teams&leagueId=\(leagueId)&APIkey=\(key)"
        AF.request(url).responseDecodable(of: TeamResult.self) { response in
            switch response.result {
                    case .success(let data):
                        print("Data received: \(data.result[0].players)")
                        print("Data received: \(data.result[0].coaches)")
                        
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
    }
    
    func getAllFootballLeagues(){
        let url = self.url + "football/?met=Leagues&APIkey=\(key)"
        
        AF.request(url).responseDecodable(of: LeaguesResult.self){
            response in
            switch response.result {
            case .success(let data):
                print(data.result.count)
                for league in data.result{
                    print("\(league.leagueName) + \(league.leagueKey) ")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func getFixtures(leagueKey:Int){
        let url = self.url + "football/?met=Fixtures&APIkey=\(key)&from=2025-05-10&to=2025-05-30&leagueId=\(leagueKey)"
        AF.request(url).responseDecodable(of: FixturesResult.self){
            response in
            switch response.result {
            case .success(let data):
                print(data.result.count)
                for fixture in data.result{
                    print("\(fixture.homeTeam) + \(fixture.awayTeam) ")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
}
