//
//  LeaguePojo.swift
//  SportsNews
//
//  Created by mac on 28/05/2025.
//

//struct LeaguesResult : Decodable{
//    let success : Int
//    let result : [LeagueModel]?
//}
protocol LeagueModel: Codable {}

struct FootballLeague: LeagueModel {
    let leagueKey: Int
    let leagueName: String
    let countryKey: Int?
    let countryName: String?
    let leagueLogo: String?
    let countryLogo: String?

    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryKey = "country_key"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
    }
}

struct BasketballLeague: LeagueModel {
    let leagueKey: Int
    let leagueName: String
    let countryKey: Int?
    let countryName: String?

    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryKey = "country_key"
        case countryName = "country_name"
    }
}

struct CricketLeague: LeagueModel {
    let leagueKey: Int
    let leagueName: String
    let leagueYear: String?

    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueYear = "league_year"
    }
}

struct TennisLeague: LeagueModel {
    let leagueKey: Int
    let leagueName: String
    let countryKey: Int?
    let countryName: String?

    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryKey = "country_key"
        case countryName = "country_name"
    }
}
