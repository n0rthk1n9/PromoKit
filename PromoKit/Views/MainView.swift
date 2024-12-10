//
//  MainView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 10.12.2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Tab("Apps", systemImage: "app.fill") {
                PromoAppsView()
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
    }
}

#Preview {
    MainView()
}
