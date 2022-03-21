//
//  Team.swift
//  eosLundSUI
//
//  Created by Denis Rakitin on 2022-03-09.
//

import Foundation

struct Team: Identifiable {
    let id: String
    let name: String
    let city: String
    let arena: String
}

extension Team {
    init(teamDB: TeamRealmObject) {
        id = teamDB.id
        name = teamDB.name
        city = teamDB.city
        arena = teamDB.arena
    }
}
