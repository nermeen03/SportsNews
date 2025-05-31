//
//  LeaguesDecoders.swift
//  SportsNews
//
//  Created by mac on 31/05/2025.
//

import Foundation

protocol LeagueDecoder {
    func decode(data: Data) throws -> [LeagueModel]
}

class FootballLeaguesDecoder: LeagueDecoder {
    func decode(data: Data) throws -> [LeagueModel] {
        let decoded = try JSONDecoder().decode(APIResponse<[FootballLeague]>.self, from: data)
        return decoded.result
    }
}

class BasketballLeaguesDecoder: LeagueDecoder {
    func decode(data: Data) throws -> [LeagueModel] {
        let decoded = try JSONDecoder().decode(APIResponse<[BasketballLeague]>.self, from: data)
        return decoded.result
    }
}

class TennisLeaguesDecoder: LeagueDecoder {
    func decode(data: Data) throws -> [LeagueModel] {
        let decoded = try JSONDecoder().decode(APIResponse<[TennisLeague]>.self, from: data)
        return decoded.result
    }
}
class CricketLeaguesDecoder: LeagueDecoder {
    func decode(data: Data) throws -> [LeagueModel] {
        let decoded = try JSONDecoder().decode(APIResponse<[CricketLeague]>.self, from: data)
        return decoded.result
    }
}

class LeaguesDecoderFactory {
    static func decoder(for sport: SportType) -> LeagueDecoder? {
        switch (sport) {
        case .football: return FootballLeaguesDecoder()
        case .basketball: return BasketballLeaguesDecoder()
        case .tennis: return TennisLeaguesDecoder()
        case .cricket: return CricketLeaguesDecoder()
        }
    }
}
