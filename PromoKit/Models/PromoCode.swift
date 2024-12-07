//
//  PromoCode.swift
//  PromoKit
//
//  Created by Jan Armbrust on 05.12.2024.
//

import Foundation
import SwiftData

@Model
class PromoCode {
    var code: String
    var dateAdded: Date
    var used: Bool
    // This has to be optional, otherwise the .cascade delete rule in the inverse relationship will crash the app
    // A PromoCode can only belong to one PromoApp
    var promoApp: PromoApp?
    
    init(code: String, dateAdded: Date = Date(), used: Bool = false, promoApp: PromoApp = PromoApp()) {
        self.code = code
        self.dateAdded = dateAdded
        self.used = used
        self.promoApp = promoApp
    }
}
