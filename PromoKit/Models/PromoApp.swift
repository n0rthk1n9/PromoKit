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
    // One PromoApp can have many PromoCode
    @Relationship(deleteRule: .cascade, inverse: \PromoCode.promoApp)
    var promoCodes: [PromoCode]
    
    init(name: String = "", version: String = "", promoCodes: [PromoCode] = []) {
        self.name = name
        self.version = version
        self.promoCodes = promoCodes
    }
}
