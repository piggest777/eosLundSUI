//
//  MatchView.swift
//  eosLundSUI
//
//  Created by Denis Rakitin on 2022-03-03.
//

import SwiftUI

struct MatchView: View {
    let gameItem: Game
    let homeTeam: Team
    let guestTeam: Team
    
    var logoLeft: some View {
        if gameItem.homeTeamCode == "EOS" {
            return Image("EOS")
                .resizable()
                .frame(minWidth: 50, idealWidth: 75, maxWidth: 100, minHeight: 50, idealHeight: 75, maxHeight: 100, alignment: .center)
                .aspectRatio(1, contentMode: .fit)
        } else {
            return Image("TEAM")
                .resizable()
                .frame(minWidth: 50, idealWidth: 75, maxWidth: 100, minHeight: 50, idealHeight: 75, maxHeight: 100, alignment: .center)
                .aspectRatio(1,contentMode: .fit)
        }
    }
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
                .frame(minWidth: 50, idealWidth: 75, maxWidth: 100, minHeight: 50, idealHeight: 75, maxHeight: 100, alignment: .center)
                .aspectRatio(1, contentMode: .fit)
        } else {
            return Image("TEAM")
                .resizable()
                .frame(minWidth: 50, idealWidth: 75, maxWidth: 100, minHeight: 50, idealHeight: 75, maxHeight: 100, alignment: .center)
                .aspectRatio(1, contentMode: .fit)
        }
    }

    var nameRight: some View {
        
        return Text(gameItem.guestTeamCode)
    }
    
    var body: some View {
        
        VStack {
            ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(.white)

                        VStack {
                            Text(gameItem.teamLeague)
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text("\(homeTeam.city), \(homeTeam.arena)")
                                .font(.title)
                                .foregroundColor(.gray)
                            Spacer()
                                .frame(maxHeight: 20)
                            HStack{
                                VStack{
                                    Image(Util.getTeamLogoName(homeTeam.id))
                                        .resizable()
                                        .frame(minWidth: 50, idealWidth: 75, maxWidth: 100, minHeight: 50, idealHeight: 75, maxHeight: 100, alignment: .center)
                                        .aspectRatio(1, contentMode: .fit)
                                    Text(homeTeam.name)
                                        .font(.system(size: 12))
                                        .frame(maxWidth: 70, maxHeight: 30, alignment: .top)
                                        .multilineTextAlignment(.center)
//                                    logoLeft
//                                    nameLeft
                                }
                                VStack{
                                    Text("\(gameItem.homeScore) : \(gameItem.guestTeamScore)")
                                        .frame(width: 100, height: 50, alignment: .center)
                                        .font(.system(size: 22, weight: .bold))
                                }
                                VStack(){
                                    Image(Util.getTeamLogoName(guestTeam.id))
                                        .resizable()
                                        .frame(minWidth: 50, idealWidth: 75, maxWidth: 100, minHeight: 50, idealHeight: 75, maxHeight: 100, alignment: .center)
                                        .aspectRatio(1, contentMode: .fit)
                                    Text(guestTeam.name)
                                        .font(.system(size: 12))
                                        .frame(maxWidth: 70, maxHeight: 30, alignment: .top)
                                        .multilineTextAlignment(.center)
//                                    logoRight
//                                    nameRight
                                }
                                
                            }
                            
                            gameDate
                                .frame(maxWidth: .infinity)
                            gameTime
                        }
                        .padding(20)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 350)
                    .shadow(radius: 10)
                .padding()
            Spacer()
        }
            
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MatchView(gameItem: GameRow.example, homeTeam: GameRow.homeTeamEx, guestTeam: GameRow.guestTeamEx)
            MatchView(gameItem: GameRow.example, homeTeam: GameRow.homeTeamEx, guestTeam: GameRow.guestTeamEx)
                .previewDevice("iPhone 12 Pro")
        }
    }
}
