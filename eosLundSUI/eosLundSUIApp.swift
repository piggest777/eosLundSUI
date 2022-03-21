//
//  eosLundSUIApp.swift
//  eosLundSUI
//
//  Created by Denis Rakitin on 2022-03-02.
//

import SwiftUI
import FirebaseCore
import RealmSwift

@main
struct eosLundSUIApp: SwiftUI.App {
    
    init() {
        initFirebase()
      }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension eosLundSUIApp {
    func initFirebase() {
    FirebaseApp.configure()
  }
}
