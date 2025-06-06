//
//  FixtureDecoders.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 31/05/2025.
//

import Foundation

protocol FixtureDecoders{
    func decode(data:Data) -> [FixtureModel]
}

class FootballFixtureDecoders : FixtureDecoders{
    func decode(data: Data) -> [FixtureModel] {
        do {
            let decoded = try JSONDecoder().decode(APIResponse<[FootballFixture]>.self, from: data)
            return decoded.result ?? []
        } catch {
            print("Error decoding: \(error)")
            return []
        }
    }
}

class BasketballFixtureDecoders : FixtureDecoders{
    func decode(data: Data) -> [FixtureModel] {
        do {
            let decoded = try JSONDecoder().decode(APIResponse<[BasketballFixture]>.self, from: data)
            return decoded.result ?? []
        } catch {
            print("Error decoding: \(error)")
            return []
        }
    }
}

class TennisFixtureDecoders : FixtureDecoders{
    func decode(data: Data) -> [FixtureModel] {
        do {
            let decoded = try JSONDecoder().decode(APIResponse<[TennisFixture]>.self, from: data)
            return decoded.result ?? []
        } catch {
            print("Error decoding: \(error)")
            return []
        }
    }
}

class CricketFixtureDecoders : FixtureDecoders{
    func decode(data: Data) -> [FixtureModel] {
        do {
            let decoded = try JSONDecoder().decode(APIResponse<[CricketFixture]>.self, from: data)
            return decoded.result ?? []
        } catch {
            print("Error decoding: \(error)")
            return []
        }
    }
}

class FixturesDecoderFactory {
    static func decoder(for sport: SportType) -> FixtureDecoders? {
        switch (sport) {
        case .football: return FootballFixtureDecoders()
        case .basketball: return BasketballFixtureDecoders()
        case .tennis: return TennisFixtureDecoders()
        case .cricket: return CricketFixtureDecoders()
        case .none: return nil
        }
    }
}
