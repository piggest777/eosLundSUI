//
//  Game.swift
//  eosLundSUI
//
//  Created by Denis Rakitin on 2022-03-02.
//

import Foundation

struct Game: Codable, Identifiable {
    var id: String
    private(set) var homeTeamCode: String!
    private(set) var guestTeamCode: String!
    private(set) var homeScore: Int!
    private(set) var guestTeamScore: Int!
    private(set) var gameDateAndTime: Date!
    private(set) var teamLeague: String!
    private(set) var eosPlayers: String?
    private(set) var oppositeTeamPlayers: String?
    private(set) var statsLink: String?
    private(set) var gameDescription: String?
    private(set) var gameCoverUrl: String?
    
}
