//
//  LeaguePojo.swift
//  SportsNews
//
//  Created by mac on 28/05/2025.
//

protocol LeagueModel: Codable {
    var leagueKey: Int { get set}
    var leagueName: String { get set}
    var leagueLogo: String? { get set}
    var isFav: Bool? {get set}
}

struct FootballLeague: LeagueModel {
    var isFav: Bool?
    var leagueKey: Int
    var leagueName: String
    var countryKey: Int?
    var countryName: String?
    var leagueLogo: String?
    var countryLogo: String?
    
    init() {
            self.leagueKey = 0
            self.leagueName = ""
            self.countryKey = nil
            self.countryName = nil
            self.leagueLogo = nil
            self.countryLogo = nil
            self.isFav = false
        }
    
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
    var isFav: Bool?
    var leagueLogo: String?
    var leagueKey: Int
    var leagueName: String
    var countryKey: Int?
    var countryName: String?
    
    init() {
            self.leagueKey = 0
            self.leagueName = ""
            self.countryKey = nil
            self.countryName = nil
            self.leagueLogo = nil
            self.isFav = false
        }
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryKey = "country_key"
        case countryName = "country_name"
    }
}

struct CricketLeague: LeagueModel {
    var isFav: Bool?
    var leagueLogo: String?
    var leagueKey: Int
    var leagueName: String
    var leagueYear: String?

    init() {
            self.leagueKey = 0
            self.leagueName = ""
            self.leagueLogo = nil
            self.leagueYear = nil
            self.isFav = false
        }
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueYear = "league_year"
    }
}

struct TennisLeague: LeagueModel {
    var isFav: Bool?
    var leagueLogo: String?
    var leagueKey: Int
    var leagueName: String
    var countryKey: Int?
    var countryName: String?
    
    init() {
            self.leagueKey = 0
            self.leagueName = ""
            self.countryKey = nil
            self.countryName = nil
            self.leagueLogo = nil
            self.isFav = false
        }
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryKey = "country_key"
        case countryName = "country_name"
    }
}

struct LeagueFactory {
    static func createEmptyLeague(for sport: SportType) -> LeagueModel {
        switch sport {
        case .football:
            return FootballLeague()
        case .basketball:
            return BasketballLeague()
        case .cricket:
            return CricketLeague()
        case .tennis:
            return TennisLeague()
        }
    }
}
