//
//  ContentView.swift
//  eosLundSUI
//
//  Created by Denis Rakitin on 2022-03-02.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentIndex: Int = 0
    
    @State var currectTab = "SBLD"
    @Namespace var animation
    @ObservedObject private var gameViewModel = GameViewModel()
    
    var body: some View {
        LoadingView(isShowing: $gameViewModel.loading){
            
            NavigationView {
                VStack{
                    VStack(spacing: 15){
                        
                        HStack(spacing: 0) {
                            
                            TabButton(title: "SBLD", animation: animation, currentTab: $currectTab)
                            
                            TabButton(title: "SE Herr", animation: animation, currentTab: $currectTab)
                            TabButton(title: "BE Dam", animation: animation, currentTab: $currectTab)
                            
                        }
                        .background(Color.black.opacity(0.04), in: RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        
                        // SnapCarousel
                        SnapCarousel(index: $currentIndex, items: gameViewModel.nextGames) { card  in
                            GeometryReader{proxy in
                                
                                let size = proxy.size
                                
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                                            .fill(.white)
                                        
                                        VStack {
                                            Text("NEXT GAME")
                                                .background(Color.black)
                                                .foregroundColor(Color.white)
                                            Text(card.league)
                                                .font(.title)
                                            HStack{
                                                VStack{
                                                    Image(Util.getTeamLogoName(card.homeTeamCode))
                                                        .resizable()
                                                        .frame(minWidth: 25, idealWidth: 75, maxWidth: 100, minHeight: 50, idealHeight: 75, maxHeight: 100, alignment: .center)
                                                        .aspectRatio(1, contentMode: .fit)
                                                    Text(card.homeTeamCode)
                                                        .font(.system(size: 12))
                                                        .frame(maxWidth: 70, maxHeight: 30, alignment: .top)
                                                        .multilineTextAlignment(.center)
                                                }
                                                VStack(){
                                                    Text(card.gameDate)
                                                    Text(card.gameTime)
                                                }
                                                
                                                VStack(){
                                                    Image(Util.getTeamLogoName(card.guestTeamCode))
                                                        .resizable()
                                                        .frame(minWidth: 25, idealWidth: 75, maxWidth: 100, minHeight: 50, idealHeight: 75, maxHeight: 100, alignment: .center)
                                                        .aspectRatio(1, contentMode: .fit)
                                                    Text(card.guestTeamCode)
                                                        .font(.system(size: 12))
                                                        .frame(maxWidth: 70, maxHeight: 30, alignment: .top)
                                                        .multilineTextAlignment(.center)
                                                    
                                                }
                                                
                                            }
                                            Text(card.place)
                                            
                                        }
                                        .padding(20)
                                        .multilineTextAlignment(.center)
                                        .shadow(radius: 0)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: 350)
                                    .shadow(radius: 10)
                                }
                                .frame(width: size.width)
                                
                            }
                            .padding(.vertical, 10)
                            
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .onAppear{
                            
                            
                        }
                        
                        List(gameViewModel.games) { game in
                            let homeTeam = TeamRealmObject.getTeamInfoById(id: game.homeTeamCode)
                            let guestTeam = TeamRealmObject.getTeamInfoById(id: game.guestTeamCode)
                            NavigationLink( destination: MatchView(gameItem: game, homeTeam: homeTeam, guestTeam: guestTeam)) {
                                GameRow(gameItem: game, homeTeam: homeTeam, guestTeam: guestTeam)
                            }
                        }
                        .environment(\.defaultMinListRowHeight, 100)
                        .onAppear() {
                            if self.gameViewModel.listener != nil {
                                self.gameViewModel.listener.remove()
                            }
                            self.gameViewModel.getGames(forLeague: currectTab)
                        }
                        .onChange(of: currectTab) { newValue in
                            if self.gameViewModel.listener != nil {
                                self.gameViewModel.listener.remove()
                            }
                            gameViewModel.games.removeAll()
                            self.gameViewModel.getGames(forLeague: currectTab)
                        }
                        .onChange(of: currentIndex) { newValue in
                            
                            switch (currentIndex) {
                            case 0:
                                currectTab = "SBLD"
                                break
                            case 1:
                                currectTab = "SE Herr"
                                break
                            case 2:
                                currectTab = "BE Dam"
                                break
                            default:
                                currectTab = "SBLD"
                                break
                            }
                        }
                        .onDisappear(){
                            if self.gameViewModel.listener != nil {
                                self.gameViewModel.listener.remove()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
