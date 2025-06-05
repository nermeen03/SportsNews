////
////  LeaguesDetailsCollectionViewController.swift
////  SportsNews
////
////  Created by Nermeen Mohamed on 29/05/2025.
////
//
import UIKit
protocol LeaguesDetailsProtocol : UIViewController{
    
    var sportName : SportType? { get set }
    var leaguesId : Int? { get set }
    var leagueName : String? {get set}
    func renderUpcomingFixtureToView(fixtureList:[FixtureModel])
    func renderPastFixtureToView(fixtureList:[FixtureModel])
    func renderTeamsToView(teams: [FootballTeam])
    func renderPlayersToView(players: [TennisPlayer])
}
