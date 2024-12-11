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
    var link: String
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

    var daysRemaining: Int {
        if promoCodes.allSatisfy({ $0.isUsed || $0.isInvalid }) {
            return 0
        }

        let validPromoCodes = promoCodes.filter {
            guard let expirationDate = Calendar.current.date(byAdding: .day, value: 28, to: $0.dateAdded) else {
                return false
            }
            return expirationDate >= Date()
        }

        guard
            let earliestExpirationDate =
                validPromoCodes
                .compactMap({ Calendar.current.date(byAdding: .day, value: 28, to: $0.dateAdded) })
                .min()
        else {
            return 0
        }

        let remaining = Calendar.current.dateComponents([.day], from: Date(), to: earliestExpirationDate).day ?? 0
        return max(remaining, 0)
    }
}
