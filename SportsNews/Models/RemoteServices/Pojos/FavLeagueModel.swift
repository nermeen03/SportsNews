//
//  FavLeagueModel.swift
//  SportsNews
//
//  Created by mac on 01/06/2025.
//

struct FavLeagueModel{
    var league: LeagueModel
    var sportType: SportType
    
    init(league: LeagueModel, sportType: SportType) {
        self.league = league
        self.sportType = sportType
    }
}
