//
//  View+Extension.swift
//  PromoKit
//
//  Created by Jan Armbrust on 16.12.2024.
//

import SwiftUI
import Foundation

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}
