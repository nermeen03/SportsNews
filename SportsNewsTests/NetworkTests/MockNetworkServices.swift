//
//  FakeNetwork.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 05/06/2025.
//

import Foundation
@testable import SportsNews

class MockNetworkServices{
    var shouldFail : Bool
    init(shouldFail: Bool) {
        self.shouldFail = shouldFail
    }
    var apiResponse : [Int:String] = [:]
    
    func getFixtures(sportName:SportType, lang:Bool, leagueKey:Int, fromData:String, toData:String, completion : @escaping ([FixtureModel]) -> Void){
        if shouldFail{
            apiResponse[leagueKey] = nil
        }else{
            apiResponse[leagueKey] = "test"
        }
    }
}
