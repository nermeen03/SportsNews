//
//  FixturePojo.swift
//  SportsNews
//
//  Created by mac on 28/05/2025.
//

protocol FixtureModel: Codable {
    var fixtureDate: String { get }
    var fixtureTime: String { get }
    var homeTeam: String { get }
    var homeTeamLogo: String? { get }
    var awayTeam: String { get }
    var awayTeamLogo: String? { get }
    var finalResult: String? { get }
    var leagueName: String? { get }
}

struct FootballFixture: FixtureModel {
    let fixtureDate: String
    let fixtureTime: String
    let homeTeam: String
    let homeTeamLogo: String?
    let awayTeam: String
    let awayTeamLogo: String?
    let finalResult: String?
    let leagueName: String?

    enum CodingKeys: String, CodingKey {
        case fixtureDate = "event_date"
        case fixtureTime = "event_time"
        case homeTeam = "event_home_team"
        case homeTeamLogo = "home_team_logo"
        case awayTeam = "event_away_team"
        case awayTeamLogo = "away_team_logo"
        case finalResult = "event_final_result"
        case leagueName = "league_name"
    }
}

struct BasketballFixture: FixtureModel {
    let fixtureDate: String
    let fixtureTime: String
    let homeTeam: String
    let homeTeamLogo: String?
    let awayTeam: String
    let awayTeamLogo: String?
    let finalResult: String?
    let leagueName: String?

    enum CodingKeys: String, CodingKey {
        case fixtureDate = "event_date"
        case fixtureTime = "event_time"
        case homeTeam = "event_home_team"
        case homeTeamLogo = "event_home_team_logo"
        case awayTeam = "event_away_team"
        case awayTeamLogo = "event_away_team_logo"
        case finalResult = "event_final_result"
        case leagueName = "league_name"
    }
}

struct CricketFixture: FixtureModel {
    let fixtureDate: String
    let fixtureTime: String
    let homeTeam: String
    let homeTeamLogo: String?
    let awayTeam: String
    let awayTeamLogo: String?
    let leagueName: String?
    
    let homeFinalResult: String?
    let awayFinalResult: String?
    

    enum CodingKeys: String, CodingKey {
        case fixtureDate = "event_date_start"
        case fixtureTime = "event_time"
        case homeTeam = "event_home_team"
        case homeTeamLogo = "event_home_team_logo"
        case awayTeam = "event_away_team"
        case awayTeamLogo = "event_away_team_logo"
        case homeFinalResult = "event_home_final_result"
        case awayFinalResult = "event_away_final_result"
        case leagueName = "league_name"
    }

    var finalResult: String? {
        if let home = homeFinalResult, let away = awayFinalResult {
            return "\(home) - \(away)"
        }
        return nil
    }
}


struct TennisFixture: FixtureModel {
    let fixtureDate: String
    let fixtureTime: String
    let homeTeam: String
    let homeTeamLogo: String?
    let awayTeam: String
    let awayTeamLogo: String?
    let finalResult: String?
    let leagueName: String?

    enum CodingKeys: String, CodingKey {
        case fixtureDate = "event_date"
        case fixtureTime = "event_time"
        case homeTeam = "event_first_player"
        case awayTeam = "event_second_player"
        case homeTeamLogo = "event_first_player_logo"
        case awayTeamLogo = "event_second_player_logo"
        case finalResult = "event_final_result"
        case leagueName = "league_name"
    }
}
