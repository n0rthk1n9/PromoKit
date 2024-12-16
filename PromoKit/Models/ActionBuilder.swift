//
//  ActionBuilder.swift
//  PromoKit
//
//  Created by Jan Armbrust on 13.12.2024.
//

import Foundation

@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
}
