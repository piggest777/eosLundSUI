//
//  BindingExt.swift
//  eosLundSUI
//
//  Created by Denis Rakitin on 2022-03-18.
//

import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> (Void)) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
