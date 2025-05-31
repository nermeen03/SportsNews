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
    
    
    func getTeamsAndPlayers(sportName:String, leagueId : Int, handler:@escaping ([FootballTeam])->Void) {
                
        let url = self.url + "\(sportName)//?&met=Teams&leagueId=\(leagueId)&APIkey=\(key)"
        AF.request(url).responseDecodable(of: APIResponse<[FootballTeam]?>.self) { response in
            switch response.result {
                    case .success(let data):
                        guard let result = data.result else {
                            print("No teams")
                            return
                        }
                        handler(result)
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
    }
    
    func getAllSportLeagues(sportName:SportType, completion: @escaping ([LeagueModel]) -> Void){
        
        let date = Date()
        print(date)
        
        let url = self.url + "\(sportName.rawValue)/?met=Leagues&APIkey=\(key)"
        
        AF.request(url).responseData { response in
                guard let data = response.data,
                      let decoder = LeaguesDecoderFactory.decoder(for: sportName) else {
                          print("No leagues")
                          completion([])
                          return
                }

                do {
                    let result = try decoder.decode(data: data)
                    print(result)
                    completion(result)
                    
                } catch {
                    print("Decoding failed: \(error)")
                    completion([])
                }
            }
    }
    
    func getFixtures(sportName:SportType, leagueKey:Int, fromData:String, toData:String, completion : @escaping ([FixtureModel]) -> Void){
        let url = self.url + "\(sportName)/?met=Fixtures&APIkey=\(key)&from=\(fromData)&to=\(toData)&leagueId=\(leagueKey)"
        AF.request(url).responseData { response in
            guard let data = response.data , let decoder = FixturesDecoderFactory.decoder(for: sportName) else {
                    print("No data returned")
                    return
                }
            let result = decoder.decode(data: data)
            completion(result)
        }
    }
    
}
