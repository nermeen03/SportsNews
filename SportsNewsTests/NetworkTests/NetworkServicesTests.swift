//
//  SportsNewsTests.swift
//  SportsNewsTests
//
//  Created by Nermeen Mohamed on 31/05/2025.
//

import XCTest
@testable import SportsNews

final class NetworkServicesTests: XCTestCase {

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
    
    func testTranslateSuccess(){
        let array = ["first","second"]
        let exp = expectation(description: "test api")
        
        network.translate(texts: array, sourceLang: "en", targetLang: "ar", completion: { translated in
            XCTAssertNotEqual(array, translated)
            exp.fulfill()
        })

        waitForExpectations(timeout: 5)
    }
    func testTranslateTextError(){
        let text = "first"
        let exp = expectation(description: "test api")
        
        network.translateText(text: text, sourceLang: "en", targetLang: "arabic", completion: { translated in
            XCTAssertEqual(text, translated)
            exp.fulfill()
        })

        waitForExpectations(timeout: 5)
    }
    func testGetAllSportLeaguesEnSuccess(){
        let exp = expectation(description: "test api")
        network.getAllSportLeagues(sportName: .football, lang: false, completion: {
            leagues in
            XCTAssertNotNil(leagues)
            XCTAssertFalse(leagues.isEmpty,"Expected leagues not to be empty")
            exp.fulfill()
        })
        waitForExpectations(timeout: 5)
    }
    func testGetAllSportLeaguesArSuccess(){
        let exp = expectation(description: "test api")
        network.getAllSportLeagues(sportName: .football, lang: true, completion: {
            leagues in
            XCTAssertNotNil(leagues)
            XCTAssertFalse(leagues.isEmpty,"Expected leagues not to be empty")
            exp.fulfill()
        })
        waitForExpectations(timeout: 5)
    }
    
    func testGetAllSportLeaguesFail(){
        let exp = expectation(description: "test api")
        network.getAllSportLeagues(sportName: .none, lang: false, completion: {
            leagues in
            XCTAssertNotNil(leagues)
            XCTAssertTrue(leagues.isEmpty,"Expected leagues to be empty")
            exp.fulfill()
        })
        waitForExpectations(timeout: 5)
    }
    
    func testGetFixturesEnSuccess(){
        let exp = expectation(description: "test api")
        network.getFixtures(sportName: .football, lang: false, leagueKey: 152, fromData: "2025-05-01", toData: "2025-06-08", completion: {
            fixtures in
            XCTAssertNotNil(fixtures)
            XCTAssertFalse(fixtures.isEmpty,"Expected fixture not to be empty")
            exp.fulfill()
        })
        waitForExpectations(timeout: 5)
    }
    
    func testGetFixturesArSuccess(){
        let exp = expectation(description: "test api")
        network.getFixtures(sportName: .football, lang: true, leagueKey: 152, fromData: "2025-05-01", toData: "2025-06-08", completion: {
            fixtures in
            XCTAssertNotNil(fixtures)
            XCTAssertFalse(fixtures.isEmpty,"Expected fixture not to be empty")
            exp.fulfill()
        })
        waitForExpectations(timeout: 5)
    }
    
    func testGetFixturesFail(){
        let exp = expectation(description: "test api")
        network.getFixtures(sportName: .none, lang: true, leagueKey: 152, fromData: "2025-05-01", toData: "2025-06-08", completion: {
            fixtures in
            XCTAssertNotNil(fixtures)
            XCTAssertTrue(fixtures.isEmpty,"Expected fixture to be empty")
            exp.fulfill()
        })
        waitForExpectations(timeout: 5)
    }

}
