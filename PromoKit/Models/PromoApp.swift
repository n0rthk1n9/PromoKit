//
//  PromoApp.swift
//  PromoKit
//
//  Created by Jan Armbrust on 06.12.2024.
//

import Foundation
import SwiftData

@Model
final class PromoApp {
    var name: String
    var version: String
    
    init(name: String = "", version: String = "") {
        self.name = name
        self.version = version
    }
}
