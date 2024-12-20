//
//  Action.swift
//  PromoKit
//
//  Created by Jan Armbrust on 13.12.2024.
//

import SwiftUI

struct Action: Identifiable {
    private(set) var id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTint: Color = .white
    var isEnabled: Bool = true
    var action: () -> Void
}
