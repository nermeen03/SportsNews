//
//  TeamPojo.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 28/05/2025.
//

import Foundation

struct TeamResult : Codable{
    var success : Int
    var result : [TeamPojo]?
}

struct TeamPojo : Codable{
    var teamKey : Int
    var teamName : String
    var teamLogo : String
    var players : [PlayerPojo]
    var coaches : [CoachPojo]
    
    enum CodingKeys: String, CodingKey{
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players
        case coaches
    }
}

struct PlayerPojo : Codable {
    var playerName : String
    var playerImage : String?
    var playerType : String?
    
    enum CodingKeys: String, CodingKey{
        case playerName = "player_name"
        case playerImage = "player_image"
        case playerType = "player_type"
    }
}

struct CoachPojo : Codable{
    var coachName : String
    var coachCountry : String?
    
    enum CodingKeys: String, CodingKey{
        case coachName = "coach_name"
        case coachCountry = "coach_country"
    }
}
