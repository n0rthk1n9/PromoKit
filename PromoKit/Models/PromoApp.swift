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
    var appId: String
    var link: String?
    // One PromoApp can have many PromoCode
    @Relationship(deleteRule: .cascade, inverse: \PromoCode.promoApp)
    var promoCodes: [PromoCode]
    
    init(name: String = "", version: String = "", appId: String = "", link: String = "", promoCodes: [PromoCode] = []) {
        self.name = name
        self.version = version
        self.appId = appId
        self.link = link
        self.promoCodes = promoCodes
    }
}
