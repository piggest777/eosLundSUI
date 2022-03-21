//
//  MatchCard.swift
//  CarouselList (iOS)
//
//  Created by Manuel Duarte on 26/2/22.
//

import SwiftUI


struct MatchCard: Identifiable {
    var id = UUID().uuidString
    var homeTeamCode: String = "TEAM"
    var guestTeamCode: String = "TEAM"
    var gameDate: String = "NO DATE"
    var gameTime: String = "NO TIME"
    var league: String = ""
    var place: String = ""

}
 
extension MatchCard{
    init(game: Game) {
        id = game.id
        homeTeamCode = game.homeTeamCode
        guestTeamCode = game.guestTeamCode
        var gameDate: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            formatter.locale = Locale(identifier: "en_us")
            return formatter.string(from: game.gameDateAndTime)
        }
        self.gameDate = gameDate
        
        var gameTime: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: game.gameDateAndTime)
        }
        self.gameTime = gameTime
        let homeTeam = TeamRealmObject.getTeamInfoById(id: game.homeTeamCode)
        place = "\(homeTeam.city), \(homeTeam.arena)"
        league = game.teamLeague
    }
}
