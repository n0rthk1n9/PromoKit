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
    var isUsed: Bool
    // This has to be optional, otherwise the .cascade delete rule in the inverse relationship will crash the app
    // A PromoCode can only belong to one PromoApp
    var promoApp: PromoApp?

    init(code: String, dateAdded: Date = Date(), used: Bool = false, promoApp: PromoApp = PromoApp()) {
        self.code = code
        self.dateAdded = dateAdded
        self.isUsed = used
        self.promoApp = promoApp
    }

    // Computed property to check if the code is invalid (used or expired)
    var isInvalid: Bool {
        return isUsed || daysRemaining <= 0
    }

    // Computed property to calculate the days remaining until the code runs out
    var daysRemaining: Int {
        guard let expirationDate = Calendar.current.date(byAdding: .day, value: 28, to: dateAdded) else {
            return 0
        }
        let remaining = Calendar.current.dateComponents([.day], from: Date(), to: expirationDate).day ?? 0
        return max(remaining, 0)  // Ensure the value doesn't go below zero
    }
}
