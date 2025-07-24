//
//  View+Extension.swift
//  PromoKit
//
//  Created by Jan Armbrust on 16.12.2024.
//

import Foundation
import SwiftUI

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    @ViewBuilder
    func blurSlide(_ show: Bool) -> some View {
        self
            .compositingGroup()
            .blur(radius: show ? 0 : 10)
            .opacity(show ? 1 : 0)
            .offset(y: show ? 0 : 100)
    }

    @ViewBuilder
    func setUpOnBoarding() -> some View {
        #if os(macOS)
            self
                .padding(.horizontal, 20)
                .frame(minHeight: 600)
        #else
            if UIDevice.current.userInterfaceIdiom == .pad {
                if #available(iOS 18, *) {
                    self
                        .presentationSizing(.fitted)
                        .padding(.horizontal, 25)
                } else {
                    self
                }
            } else {
                self
            }
        #endif
    }
}
