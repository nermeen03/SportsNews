//
//  TeamPojo.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 28/05/2025.
//

import Foundation

struct TeamResult : Decodable{
    var success : Int
    var result : [TeamPojo]
}

struct TeamPojo : Decodable{
    var team_key : Int
    var team_name : String
    var team_logo : String
    var players : [PlayerPojo]
    var coaches : [CoachPojo]
}

struct PlayerPojo : Decodable {
    var player_name : String
    var player_image : String?
    var player_type : String?
}

struct CoachPojo : Decodable{
    var coach_name : String
    var coach_country : String?
}
