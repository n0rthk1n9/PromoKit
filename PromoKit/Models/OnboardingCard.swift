//
//  OnboardingCard.swift
//  PromoKit
//
//  Created by Jan Armbrust on 24.07.2025.
//

import Foundation

struct OnboardingCard: Identifiable {
    var id: String = UUID().uuidString
    var symbol: String
    var title: String
    var subtitle: String
}
