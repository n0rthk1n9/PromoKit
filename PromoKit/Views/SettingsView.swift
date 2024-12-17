//
//  SettingsView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 06.12.2024.
//

import SwiftUI
import FreemiumKit
import LinksKit

struct SettingsView: View {
    var body: some View {
        Form {
            Section {
                PaidStatusView(style: .decorative(icon: .laurel))
                    .listRowBackground(Color.accentColor)
                    .padding(.vertical, -10)
            }
            LinksView()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(FreemiumKit.shared)
}
