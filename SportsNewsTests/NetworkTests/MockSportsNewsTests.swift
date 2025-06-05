//
//  MockSportsNewsTests.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 05/06/2025.
//

import XCTest
@testable import SportsNews

final class MockSportsNewsTests: XCTestCase{
    
    func testGetFixturesSuccess(){
        let network = MockNetworkServices(shouldFail: false)

        network.getFixtures(sportName: .basketball, lang: true, leagueKey: 96, fromData: "", toData: "", completion: { _ in
            XCTAssertNotNil(network.apiResponse[96])
        })
    }
    
    func testGetFixturesFail(){
        let network = MockNetworkServices(shouldFail: true)
        
        network.getFixtures(sportName: .basketball, lang: true, leagueKey: 96, fromData: "", toData: "", completion: { _ in
            XCTAssertNil(network.apiResponse[96])
        })
    }
    
}
