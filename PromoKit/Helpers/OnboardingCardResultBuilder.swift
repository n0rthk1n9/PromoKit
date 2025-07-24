//
//  OnboardingCardResultBuilder.swift
//  PromoKit
//
//  Created by Jan Armbrust on 24.07.2025.
//

import Foundation

@resultBuilder
struct OnboardingCardResultBuilder {
    static func buildBlock(_ components: OnboardingCard...) -> [OnboardingCard] {
        components.compactMap { $0 }
    }
}
