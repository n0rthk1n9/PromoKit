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

    // Computed property to calculate the days remaining until the promo codes run out
    var daysRemaining: Int {
        guard let earliestDateAdded = promoCodes.map(\.dateAdded).min() else {
            return 0
        }

        guard let expirationDate = Calendar.current.date(byAdding: .day, value: 28, to: earliestDateAdded) else {
            return 0
        }

        let remaining = Calendar.current.dateComponents([.day], from: Date(), to: expirationDate).day ?? 0
        return max(remaining, 0)  // Ensure the value doesn't go below zero
    }
}
