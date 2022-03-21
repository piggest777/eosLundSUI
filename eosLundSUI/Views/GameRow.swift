//
//  GameRow.swift
//  eosLundSUI
//
//  Created by Denis Rakitin on 2022-03-03.
//

import SwiftUI

struct GameRow: View {
    
//    var logoLeft: some View {
//        if gameItem.homeTeamCode == "EOS" {
//            return Image("EOS")
//                .resizable()
//                .frame(width: 50.0, height: 50.0)
//        } else {
//            return Image("TEAM")
//                .resizable()
//                .frame(width: 50.0, height: 50.0)
//        }
//    }
    var nameLeft: some View {
        return Text(gameItem.homeTeamCode)
    }
    
    var gameDate: some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        formatter.locale = Locale(identifier: "en_us")
        return Text(formatter.string(from: gameItem.gameDateAndTime))
            .bold()
    }
    var gameTime: some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return Text(formatter.string(from: gameItem.gameDateAndTime))
    }
    var logoRight: some View {
        if gameItem.guestTeamCode == "EOS" {
            return Image("EOS")
                .resizable()
                .frame(width: 50.0, height: 50.0)
        } else {
            return Image("TEAM")
                .resizable()
                .frame(width: 50.0, height: 50.0)
        }
    }

    var nameRight: some View {
        
        return Text(gameItem.guestTeamCode)
    }
    
    static let example = Game(id: "cadsffda123", homeTeamCode: "EOS", guestTeamCode: "HBBK", homeScore: 190, guestTeamScore: 105, gameDateAndTime: Date(), teamLeague: "SBLD" )
    static let homeTeamEx = Team(id: "EOS", name: "IK EOS", city: "Lund", arena: "Eoshallen")
    static let guestTeamEx = Team(id: "WET", name: "Wetterbygden Sparks", city: "Huskvarna", arena: "Huskvarna Sporthall")
    
    let gameItem: Game
    let homeTeam: Team
    let guestTeam: Team
    
    var body: some View {
        HStack{
            VStack{
//                logoLeft
                Image(Util.getTeamLogoName(homeTeam.id))
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                Text(homeTeam.name)
                    .font(.system(size: 12))
                    .frame(maxWidth: 70, maxHeight: .infinity, alignment: .top)
                    .multilineTextAlignment(.center)
//                nameLeft
            }
            VStack{
                if gameItem.gameDateAndTime > Date() {
                    gameDate
                        .frame(maxWidth: .infinity)
                    gameTime
                } else {
                    gameDate
                    Spacer()
                        .frame(height: 10)
                    Text( "\(gameItem.homeScore) : \(gameItem.guestTeamScore)")
                        .frame(maxWidth: .infinity)
                }

            }
            VStack(){
                Image(Util.getTeamLogoName(guestTeam.id))
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                Text(guestTeam.name)
                    .font(.system(size: 12))
                    .frame(maxWidth: 70, maxHeight: .infinity, alignment: .top)
                    .multilineTextAlignment(.center)
                    
//                logoRight
//                nameRight
            }
        }
    }
    
    func safeSystemImage(_ image: String) -> String{
        if UIImage(named: "\(image).png") != nil {
            return image
        } else {
            return "TEAM"
        }
    }
}

struct GameRow_Previews: PreviewProvider {

    static var previews: some View {
        GameRow(gameItem: GameRow.example, homeTeam: GameRow.homeTeamEx, guestTeam: GameRow.guestTeamEx)
    }
}
