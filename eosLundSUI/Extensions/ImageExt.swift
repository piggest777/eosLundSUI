//
//  ImageExt.swift
//  eosLundSUI
//
//  Created by Denis Rakitin on 2022-03-10.
//

import Foundation
import SwiftUI

extension Image {
    func getTeamLogo(_ image: String) -> Image{
        if UIImage(named: "\(image).png") != nil {
            return Image(image)
        } else {
            return Image("TEAM")
        }
    }
}
