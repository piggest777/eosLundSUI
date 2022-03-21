//
//  TeamRO.swift
//  eosLundSUI
//
//  Created by Denis Rakitin on 2022-03-09.
//

import Foundation
import RealmSwift

//realm class for store team in realm base
class TeamRealmObject: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = "Team"
    @objc dynamic var city: String = ""
    @objc dynamic var arena: String =  ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, teamName: String, teamCity: String, homeArena: String){
        self.init()
        self.id = id
        self.name = teamName
        self.city = teamCity
        self.arena = homeArena
    }
    
    //save team to real base
//    static func updateTeamInfo(team: TeamFirestoreModel) {
//        let realmTeam = TeamRealmObject()
//        realmTeam.id = team.id
//        realmTeam.teamName = team.teamName
//        realmTeam.teamCity = team.teamCity
//        realmTeam.homeArena = team.homeArena
//        realmTeam.logoPathName = team.logoPathName
//
//        do {
//            let realm =  try Realm()
//            try realm.write {
//                realm.add(realmTeam, update: .modified)
//            }
//        } catch  {
//            debugPrint("can`t add or update team info", error)
//        }
//    }
    
    //get all teams from realm base
    static func getAllRealmTeam() -> Results<TeamRealmObject>?{
        do {
            let realm = try Realm()
            let teams = realm.objects(TeamRealmObject.self)
            return teams
        } catch  {
            debugPrint("Can`t get team`s list from realm", error)
            return nil
        }
    }
    
    //delete team by team id
    static func deleteRealmTeamBy(id: String) {
        do {
            let realm = try Realm()
            let objectToDelete = realm.object(ofType: TeamRealmObject.self, forPrimaryKey: id)
            
            guard let object = objectToDelete else {return}
            try! realm.write {
                realm.delete(object)
            }
            
        } catch  {
            debugPrint("Can`t delete team by id", error)
        }
    }
   
    //get team by id
    static func getTeamInfoById(id: String) -> Team {
        
        let defaulTeam = Team(id: "TEAM", name: "TEAM", city: "", arena: "")
        do {
            let realmTeam = try Realm().object(ofType: TeamRealmObject.self, forPrimaryKey: id)
            if realmTeam != nil {
                return Team(id: realmTeam!.id, name: realmTeam!.name, city: realmTeam!.city, arena: realmTeam!.arena)
            } else {
                return defaulTeam
            }
        } catch  {
            debugPrint("Can`t get team info from Realm Base", error)
            return defaulTeam
        }
    }
    
    //add team to realm base and wait while write transaction will be finished before update
//    static func realmWriteWithCallback(team: TeamFirestoreModel, completion: @escaping (Bool)->()) {
//        let realmTeam = TeamRealmObject()
//        realmTeam.id = team.id
//        realmTeam.teamName = team.teamName
//        realmTeam.teamCity = team.teamCity
//        realmTeam.homeArena = team.homeArena
//        realmTeam.logoPathName = team.logoPathName
//
//        do {
//            let realm =  try Realm()
//            try realm.write(
//                transaction: {
//                    realm.add(realmTeam, update: .modified)
//            },
//                completion: {
//                    completion(true)
//            })
//        } catch  {
//            debugPrint("can`t add or update team info in Realm base", error)
//        }
//    }
}
