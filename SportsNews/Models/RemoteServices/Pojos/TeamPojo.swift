//
//  TeamPojo.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 28/05/2025.
//

import Foundation

struct FootballTeam : Codable{
    var teamKey : Int
    var teamName : String
    var teamLogo : String?
    var players : [FootballPlayer]?
    var coaches : [FootballCoach]?
    
    enum CodingKeys: String, CodingKey{
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players
        case coaches
    }
}

struct FootballPlayer : Codable {
    var playerName : String
    var playerImage : String?
    var playerType : String?
    var playerNumber : String
    enum CodingKeys: String, CodingKey{
        case playerName = "player_name"
        case playerImage = "player_image"
        case playerType = "player_type"
        case playerNumber = "player_number"
    }
}

struct FootballCoach : Codable{
    var coachName : String
    var coachCountry : String?
    
    enum CodingKeys: String, CodingKey{
        case coachName = "coach_name"
        case coachCountry = "coach_country"
    }
}

struct TennisPlayer: Codable{
    var playerName: String
    var playerLogo: String
    enum CodingKeys: String, CodingKey{
        case playerName = "player_name"
        case playerLogo = "player_logo"
    }
}
