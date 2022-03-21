//
//  GameViewModel.swift
//  eosLundSUI
//
//  Created by Denis Rakitin on 2022-03-02.
//

import Foundation
import FirebaseFirestore
import UIKit
import RealmSwift

class GameViewModel: ObservableObject {
    
    @Published var games = [Game]()
    @Published var teams = [Team]()
    @Published var loading = false
    var leagues = ["SBLD", "SE Herr", "BE Dam"]
    @Published var nextGames = [MatchCard]()
    var listener: ListenerRegistration!
    
    init(){
        checkTeamsUpdatePossibility { status in
            switch status {
            case .NEED_TO_UPDATE:
                self.loading = true
                self.updateRealmTeamBase { success in
                    if success {
                        self.updateDate = Date()
                        self.loading = false
                        self.addEmptyCards()
                        self.getAllNextGames()
                        print("Update finished")
                    }
                }
            case .READY_TO_USE:
                self.addEmptyCards()
                self.getAllNextGames()
                print("Team base ready to use")
            case .NOT_EXIST:
                print("do nothing")
            case .ERROR:
                print("Can`t get info about team update date")
            }
//            self.getAllNextGames()
        }
        

    }
    
    private var db  = Firestore.firestore()
    private var teamsReference = Firestore.firestore().collection("teams")
    
    let defaults = UserDefaults.standard
    
    
    var updateDate: Date? {
        get {
            return defaults.value(forKey: "teamsInfoWasUpdated") as? Date
        }
        set {
            defaults.set(newValue, forKey: "teamsInfoWasUpdated")
        }
    }
    
    func getGames(forLeague league: String) {
       listener =  db.collection("games")
            .whereField(TEAM_LEAGUE, isEqualTo: league)
            .order(by: GAME_DATE_AND_TIME, descending: false)
            .addSnapshotListener{(querySnapshot,error) in
                guard let documents = querySnapshot?.documents else {return}
                
                documents.forEach {documentSnapshot in
                    let data = documentSnapshot.data()
                    let oppositeTeamCode: String = data[OPPOSITE_TEAM_CODE] as? String ?? "TEAM"
                    let isHomeGame: Bool = data[IS_HOME_GAME] as? Bool ?? true
                    let eosScore: Int = data[EOS_SCORES] as? Int ?? 0
                    let oppositeTeamScores: Int = data[OPPOSITE_TEAM_SCORES] as? Int ?? 0
                    let dateAndTimeTimestamp: Timestamp? = data[GAME_DATE_AND_TIME] as? Timestamp ?? nil
                    let teamLeague: String = data[TEAM_LEAGUE] as? String ?? "undefined"
                    let documentId = documentSnapshot.documentID
                    let eosPlayers: String? = data[EOS_PLAYERS] as? String ?? nil
                    let oppositeTeamPlayers: String? = data[OPPOSITE_TEAM_PLAYERS] as? String ?? nil
                    let gameDesc: String? = data[GAME_DESCRIPTION] as? String ?? nil
                    let statsLink: String? = data[STATISTIC_LINK] as? String ?? nil
                    let gameCoverUrl: String?  = data[GAME_COVER_URL] as? String ?? nil
                    
                    if dateAndTimeTimestamp != nil {
                        let gameDateAndTime = dateAndTimeTimestamp!.dateValue()
                        
                        if(isHomeGame) {
                            let newGame = Game(id: documentId, homeTeamCode: "EOS", guestTeamCode: oppositeTeamCode, homeScore: eosScore, guestTeamScore: oppositeTeamScores, gameDateAndTime: gameDateAndTime, teamLeague: teamLeague, eosPlayers: eosPlayers, oppositeTeamPlayers: oppositeTeamPlayers, statsLink: statsLink, gameDescription: gameDesc, gameCoverUrl: gameCoverUrl)
                            self.games.append(newGame)
                        } else {
                            let newGame = Game(id: documentId, homeTeamCode: oppositeTeamCode, guestTeamCode: "EOS", homeScore: oppositeTeamScores, guestTeamScore: eosScore, gameDateAndTime: gameDateAndTime, teamLeague: teamLeague, eosPlayers: eosPlayers, oppositeTeamPlayers: oppositeTeamPlayers, statsLink: statsLink, gameDescription: gameDesc, gameCoverUrl: gameCoverUrl)
                            self.games.append(newGame)
                        }
                        
                    } else {
                        print("out information about game date and time, can`t add to array. Game id: \(documentId)")
                    }
                }
                
            }
        
    }
    
    func checkTeamsUpdatePossibility(completionHandler: @escaping (TeamUpTracker)->())  {
        if updateDate != nil, let teamRealmBase = TeamRealmObject.getAllRealmTeam(), !teamRealmBase.isEmpty {
            teamsReference.document("teamInfoUpdateDate").getDocument { (snapshot, error) in
                if error == nil {
                    guard let snapshot = snapshot else { return }
                    let data = snapshot.data()
                    if let timestampUpdateDate = data?["updateDate"] as? Timestamp {
                        let firebaseUpdateDate = timestampUpdateDate.dateValue()
                        if firebaseUpdateDate > self.updateDate! {
                            
                            print("team base need to be updatede")
                            completionHandler(.NEED_TO_UPDATE)
                        } else {
                            completionHandler(.READY_TO_USE)
                            print("Realm base already updated")
                        }
                    } else {
                        print("Realm base already updated")
                        completionHandler(.READY_TO_USE)
                    }
                } else {
                    debugPrint("Can`t get updateDate from Firebase", error as Any)
                    completionHandler(.ERROR)
                }
            }
        }   else {
            completionHandler(.NEED_TO_UPDATE)
            print("Updating team base")
        }
    }
    
    
    func updateRealmTeamBase(completion: @escaping (Bool)->()) {
        var teamArray = [Team]()
        teamsReference.getDocuments { (snapshot, error) in
            if error == nil, snapshot != nil {
                snapshot?.documents.forEach { doc in
                    let data = doc.data()
                    let id = doc.documentID
                    let name = data[TEAM_NAME] as? String ?? "Team"
                    let city = data[TEAM_CITY] as? String ?? ""
                    let arena = data[HOME_ARENA] as? String ?? ""
                    
                    if id != "teamInfoUpdateDate" {
                        let newTeam = Team(id: id, name: name, city: city, arena: arena)
                        teamArray.append(newTeam)
                    }
                }
                
                self.loadTeamsInRealm(teamArray: teamArray) { succes in
                    if succes {
                        completion(true)
                    }
                }
                
            } else {
                debugPrint("Can`t get team from Firebase")
            }
            
        }
    }
    
    func loadTeamsInRealm(teamArray: [Team], completion: (Bool)->()) {
        
        let teams: [TeamRealmObject] = teamArray.map { team in
            let teamDB = TeamRealmObject()
            teamDB.id = team.id
            teamDB.name = team.name
            teamDB.city = team.city
            teamDB.arena = team.arena
            return teamDB
        }
        
        do {
            let realm =  try Realm()
            try realm.write(
                transaction: {
                    realm.add(teams, update: .modified)
                },
                completion: {
                    completion(true)
                })
        } catch  {
            debugPrint("can`t add or update team info in Realm base", error)
        }
    }
    
    func addEmptyCards() {
        nextGames.append(MatchCard(league: "SBLD"))
        nextGames.append(MatchCard(league: "SE Herr"))
        nextGames.append(MatchCard(league: "BE Dam"))
    }
    
    func getAllNextGames() {
        leagues.forEach { league in
            db.collection("games")
                .whereField(TEAM_LEAGUE, isEqualTo: league)
                .whereField(GAME_DATE_AND_TIME, isGreaterThan: Timestamp())
                .limit(to: 1)
                .order(by: GAME_DATE_AND_TIME, descending: false)
                .getDocuments { snap, error in
                    if error == nil, snap != nil, !snap!.isEmpty{
                        let doc  = snap!.documents[0]
//                        let doc = snap?.documents[0]
                        let data = doc.data()
                        let oppositeTeamCode: String = data[OPPOSITE_TEAM_CODE] as? String ?? "TEAM"
                        let isHomeGame: Bool = data[IS_HOME_GAME] as? Bool ?? true
                        let eosScore: Int = data[EOS_SCORES] as? Int ?? 0
                        let oppositeTeamScores: Int = data[OPPOSITE_TEAM_SCORES] as? Int ?? 0
                        let dateAndTimeTimestamp: Timestamp? = data[GAME_DATE_AND_TIME] as? Timestamp ?? nil
                        let teamLeague: String = data[TEAM_LEAGUE] as? String ?? "undefined"
                        let documentId = doc.documentID
                        let eosPlayers: String? = data[EOS_PLAYERS] as? String ?? nil
                        let oppositeTeamPlayers: String? = data[OPPOSITE_TEAM_PLAYERS] as? String ?? nil
                        let gameDesc: String? = data[GAME_DESCRIPTION] as? String ?? nil
                        let statsLink: String? = data[STATISTIC_LINK] as? String ?? nil
                        let gameCoverUrl: String?  = data[GAME_COVER_URL] as? String ?? nil
                        
                        if(isHomeGame) {
                            let newGame = Game(id: documentId, homeTeamCode: "EOS", guestTeamCode: oppositeTeamCode, homeScore: eosScore, guestTeamScore: oppositeTeamScores, gameDateAndTime: dateAndTimeTimestamp!.dateValue(), teamLeague: teamLeague, eosPlayers: eosPlayers, oppositeTeamPlayers: oppositeTeamPlayers, statsLink: statsLink, gameDescription: gameDesc, gameCoverUrl: gameCoverUrl)
                             let index = self.nextGames.firstIndex { card in
                                card.league == league
                           }
                            if index != nil {
                                self.nextGames[index!] = MatchCard(game: newGame)
                            }
                        } else {
                            let newGame = Game(id: documentId, homeTeamCode: oppositeTeamCode, guestTeamCode: "EOS", homeScore: oppositeTeamScores, guestTeamScore: eosScore, gameDateAndTime: dateAndTimeTimestamp!.dateValue(), teamLeague: teamLeague, eosPlayers: eosPlayers, oppositeTeamPlayers: oppositeTeamPlayers, statsLink: statsLink, gameDescription: gameDesc, gameCoverUrl: gameCoverUrl)
                            let index = self.nextGames.firstIndex { card in
                               card.league == league
                          }
                           if index != nil {
                               self.nextGames[index!] = MatchCard(game: newGame)
                           }
                        }
                    }
                    else {
                        let index = self.nextGames.firstIndex { card in
                           card.league == league
                      }
                       if index != nil {
                           self.nextGames[index!] = MatchCard(league: league)
                       }
                    }
                    

                }
        }
        

    }
}



enum TeamUpTracker{
    case NEED_TO_UPDATE
    case READY_TO_USE
    case NOT_EXIST
    case ERROR
}
