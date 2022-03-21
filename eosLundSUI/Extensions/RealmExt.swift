//
//  RealmExt.swift
//  eosLundSUI
//
//  Created by Denis Rakitin on 2022-03-10.
//

import Foundation
import RealmSwift

extension Realm {
    func write(transaction block: () -> Void, completion: () -> Void) throws {
        try write(block)
        completion()
    }
}
