//
//  Utilities.swift
//  eosLundSUI
//
//  Created by Denis Rakitin on 2022-03-10.
//

import Foundation
import SwiftUI

class Util {
    
    static func getTeamLogoName(_ image: String) -> String{
        if UIImage(named: "\(image).png") != nil {
            return image
        } else {
            return "TEAM"
        }
    }
}
