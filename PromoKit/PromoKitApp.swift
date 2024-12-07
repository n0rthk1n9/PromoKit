//
//  PromoKitApp.swift
//  PromoKit
//
//  Created by Jan Armbrust on 05.12.2024.
//

import SwiftUI
import SwiftData

@main
struct PromoKitApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Apps", systemImage: "app.fill") {
                    PromoAppsView()
                }
                Tab("Settings", systemImage: "gear") {
                    SettingsView()
                }
            }
            .modelContainer(for: PromoApp.self)
            .fontDesign(.rounded)
        }
    }
}
