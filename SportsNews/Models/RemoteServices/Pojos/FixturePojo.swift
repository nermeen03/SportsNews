//
//  FixturePojo.swift
//  SportsNews
//
//  Created by mac on 28/05/2025.
//

struct FixturesResult : Decodable {
    let success : Int
    let result : [Fixture]
}

struct Fixture: Codable {
    let fixtureDate: String
    let fixtureTime: String
    let homeTeam: String
    let awayTeam: String
    let halftimeResult: String
    let finalResult: String
    let fullTimeResult: String
    let penaltyResult: String?
    let status: String
    let leagueRound: String
    let homeTeamLogo: String?
    let awayTeamLogo: String?

    enum CodingKeys: String, CodingKey {
        case fixtureDate = "event_date"
        case fixtureTime = "event_time"
        case homeTeam = "event_home_team"
        case awayTeam = "event_away_team"
        case halftimeResult = "event_halftime_result"
        case finalResult = "event_final_result"
        case fullTimeResult = "event_ft_result"
        case penaltyResult = "event_penalty_result"
        case status = "event_status"
        case leagueRound = "league_round"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
    }
}
