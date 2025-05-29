//
//  LeaguePojo.swift
//  SportsNews
//
//  Created by mac on 28/05/2025.
//

struct LeaguesResult : Decodable{
    let success : Int
    let result : [League]?
}

struct League: Codable {
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
