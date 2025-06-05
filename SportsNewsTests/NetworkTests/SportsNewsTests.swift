//
//  SportsNewsTests.swift
//  SportsNewsTests
//
//  Created by Nermeen Mohamed on 31/05/2025.
//

import XCTest
@testable import SportsNews

final class SportsNewsTests: XCTestCase {

    var network: NetworkServices!

    override func setUpWithError() throws {
        network = NetworkServices()
    }

    override func tearDownWithError() throws {
        network = nil
    }

    func testGetTeamsAndPlayersSuccess() {
        let exp = expectation(description: "test api")
        
        network.getTeamsAndPlayers(sportName: .football, lang: false, leagueId: 96, responseType: FootballTeam.self) { players in
            XCTAssertFalse(players.isEmpty, "Expected players not to be empty")
            exp.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
    
    func testGetTeamsAndPlayersError() {
        let exp = expectation(description: "test api")
        
        network.getTeamsAndPlayers(sportName: .football, lang: false, leagueId: 96, responseType: TennisPlayer.self) { players in
            XCTAssertTrue(players.isEmpty, "Expected players to be empty")
            exp.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
    
}
