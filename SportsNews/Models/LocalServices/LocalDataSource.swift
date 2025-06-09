//
//  LocalDataSource.swift
//  SportsNews
//
//  Created by mac on 01/06/2025.
//

import CoreData
import UIKit

protocol LocalDataSourceProtocol {
    func saveLeague(league: LeagueModel, sportType: SportType,sportName:String)
    func getAllLeagues()->[FavLeagueModel]
    func deleteLeague(leagueId: Int)
    func getLeaguesBySport(sportType: SportType)->[LeagueModel]
    func getAllArabicLeagues() -> [FavLeagueModel]
}

class LocalDataSource:LocalDataSourceProtocol{

    static let shared = LocalDataSource()
    var context:NSManagedObjectContext?
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func saveLeague(league: any LeagueModel, sportType: SportType,sportName:String) {
        let entity = NSEntityDescription.entity(forEntityName: "FavLeagues", in: context!)
        let newsObject = NSManagedObject(entity: entity!, insertInto: context)
        newsObject.setValue(league.leagueName, forKey: "leagueName")
        newsObject.setValue(league.leagueKey, forKey: "leagueKey")
        newsObject.setValue(league.leagueLogo, forKey: "leagueLogo")
        newsObject.setValue(league.isFav, forKey: "isFav")
        newsObject.setValue(sportType.rawValue, forKey: "sportType")
        newsObject.setValue(sportName, forKey: "arabicName")
        do{
            try context?.save()
            
        }catch{
            print(error.localizedDescription)
        }
    }
    func getAllLeagues() -> [FavLeagueModel] {
        var newsArr:[FavLeagueModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavLeagues")
        do{
            let leagues = try context?.fetch(fetchRequest)
            guard let leagues = leagues else{
                return []
            }
            for league in leagues{
                if let sport = SportType(rawValue: league.value(forKey: "sportType") as? String ?? SportType.football.rawValue){
                    var newObject = LeagueFactory.createEmptyLeague(for: sport)
                    newObject.leagueName = (league.value(forKey: "leagueName") as? String)!
                    newObject.leagueKey = league.value(forKey: "leagueKey") as! Int
                    newObject.leagueLogo = league.value(forKey: "leagueLogo") as? String
                    newObject.isFav = league.value(forKey: "isFav") as? Bool
                    let favObject = FavLeagueModel(league: newObject, sportType: sport)
                    newsArr.append(favObject)
                }
            }
        }catch{
            print("Fetch failed: \(error)")
        }
        return newsArr
    }
    func checkLeagueByID(leagueID: Int)-> Bool{
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavLeagues")
        fetchRequest.predicate = NSPredicate(format: "leagueKey == %d", leagueID)
        do{
            let league = try context?.fetch(fetchRequest)
            guard league != nil else{
                return false
            }
            if league?.count == 0{
                return false
            }
            return true
        }catch{
            print("Fetch failed: \(error)")
        }
        return false
    }
    
    func deleteLeague(leagueId: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavLeagues")
        fetchRequest.predicate = NSPredicate(format: "leagueKey == %d", leagueId)

        do {
            if let results = try context?.fetch(fetchRequest) {
                for object in results {
                    context?.delete(object)
                }
                try context?.save()
            }
        } catch {
            print("Failed to delete league: \(error.localizedDescription)")
        }
    }
    func getLeaguesBySport(sportType: SportType) -> [any LeagueModel] {
        var newsArr:[LeagueModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavLeagues")
        fetchRequest.predicate = NSPredicate(format: "sportType == %@", sportType.rawValue)
        do{
            let leagues = try context?.fetch(fetchRequest)
            guard let leagues = leagues else{
                return []
            }
            for league in leagues{
                if let sport = SportType(rawValue: league.value(forKey: "sportType") as? String ?? SportType.football.rawValue){
                    var newObject = LeagueFactory.createEmptyLeague(for: sport)
                    newObject.leagueName = (league.value(forKey: "leagueName") as? String)!
                    newObject.leagueKey = league.value(forKey: "leagueKey") as! Int
                    newObject.leagueLogo = league.value(forKey: "leagueLogo") as? String
                    newObject.isFav = league.value(forKey: "isFav") as? Bool
                    newsArr.append(newObject)
                }
            }
        }catch{
            print("Fetch failed: \(error)")
        }
        return newsArr
    }
    
    func getAllArabicLeagues() -> [FavLeagueModel] {
        var newsArr:[FavLeagueModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavLeagues")
        do{
            let leagues = try context?.fetch(fetchRequest)
            guard let leagues = leagues else{
                return []
            }
            for league in leagues{
                if let sport = SportType(rawValue: league.value(forKey: "sportType") as? String ?? SportType.football.rawValue){
                    var newObject = LeagueFactory.createEmptyLeague(for: sport)
                    newObject.leagueName = (league.value(forKey: "arabicName") as? String) ?? "nil"
                    newObject.leagueKey = league.value(forKey: "leagueKey") as! Int
                    newObject.leagueLogo = league.value(forKey: "leagueLogo") as? String
                    newObject.isFav = league.value(forKey: "isFav") as? Bool
                    let favObject = FavLeagueModel(league: newObject, sportType: sport)
                    newsArr.append(favObject)
                }
            }
        }catch{
            print("Fetch failed: \(error)")
        }
        return newsArr
    }
    
    func updateLeagueArabicName(leagueId : Int , name : String){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavLeagues")
        fetchRequest.predicate = NSPredicate(format: "leagueKey == %d", leagueId)

        do {
            if let results = try context?.fetch(fetchRequest) {
                for object in results {
                    object.setValue(name, forKey: "arabicName")
                }
                try context?.save()
            }
        } catch {
            print("Failed to update league: \(error.localizedDescription)")
        }
    }
    func updateLeagueEnglishName(leagueId : Int , name : String){
        print("name is \(name)")
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavLeagues")
        fetchRequest.predicate = NSPredicate(format: "leagueKey == %d", leagueId)

        do {
            if let results = try context?.fetch(fetchRequest) {
                for object in results {
                    object.setValue(name, forKey: "leagueName")
                }
                try context?.save()
            }
        } catch {
            print("Failed to update league: \(error.localizedDescription)")
        }
    }
}
