//
//  OffsetKey.swift
//  PromoKit
//
//  Created by Jan Armbrust on 15.12.2024.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
