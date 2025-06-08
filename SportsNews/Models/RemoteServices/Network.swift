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
    
    
    func getTeamsAndPlayers<T: Codable>(sportName: SportType, lang:Bool, leagueId: Int, responseType: T.Type, handler: @escaping ([T]) -> Void) {
        let endpoint = sportName == .tennis ? "Players" : "Teams"
        var url = self.url + "\(sportName)//?&met=\(endpoint)&leagueId=\(leagueId)&APIkey=\(key)"
        if(lang == true){
            url += "&lang=ar"
        }
        AF.request(url).responseDecodable(of: APIResponse<[T]?>.self) { response in
            switch response.result {
            case .success(let data):
                guard let result = data.result else {
                    print("No teams/players")
                    handler([])
                    return
                }
                handler(result ?? [])
            case .failure(let error):
                print("Error: \(error)")
                handler([])
            }
        }
    }
    
    func getAllSportLeagues(sportName:SportType,lang:Bool, completion: @escaping ([LeagueModel]) -> Void){
        var url = self.url + "\(sportName.rawValue)/?met=Leagues&APIkey=\(key)"
        if(lang == true){
            url += "&lang=ar"
        }
        AF.request(url).responseData { response in
                guard let data = response.data,
                      let decoder = LeaguesDecoderFactory.decoder(for: sportName) else {
                          completion([])
                          return
                }

                do {
                    let result = try decoder.decode(data: data)
                    completion(result)
                    
                } catch {
                    print("Decoding failed: \(error)")
                    completion([])
                }
            }
    }
    
    func getFixtures(sportName:SportType, lang:Bool, leagueKey:Int, fromData:String, toData:String, completion : @escaping ([FixtureModel]) -> Void){
        var url = self.url + "\(sportName)/?met=Fixtures&APIkey=\(key)&from=\(fromData)&to=\(toData)&leagueId=\(leagueKey)"
        print(url)
        if(lang == true){
            url += "&lang=ar"
        }
        print(url)
        AF.request(url).responseData { response in
            guard let data = response.data , let decoder = FixturesDecoderFactory.decoder(for: sportName) else {
                    print("No data returned")
                    completion([])
                    return
                }
            let result = decoder.decode(data: data)
            completion(result)
        }
    }
    
    func translate(texts: [String], sourceLang: String, targetLang: String,
        completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: "https://libretranslate-production-04e3.up.railway.app/translate") else {
                completion(texts)
                return
            }

        let parameters: [String: Any] = [
            "q": texts,
            "source": sourceLang,
            "target": targetLang,
            "format": "text"
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        print(url)
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: TranslatorArrayResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data.translatedText)
                case .failure(let error):
                    print("LibreTranslate failed: \(error)")
                    completion(texts)
                }
            }
    }
    
    func translateText(text: String, sourceLang: String, targetLang: String,
        completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://libretranslate-production-04e3.up.railway.app/translate") else {
                completion(text)
                return
            }

        let parameters: [String: Any] = [
            "q": text,
            "source": sourceLang,
            "target": targetLang,
            "format": "text"
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        print(url)
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: TranslatorResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print(data.translatedText)
                    completion(data.translatedText)
                case .failure(let error):
                    print("LibreTranslate failed: \(error)")
                    completion(text)
                }
            }
    }

}
