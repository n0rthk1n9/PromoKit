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
    @State var promoCodesViewModel = PromoCodesViewModel()

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
            .environment(promoCodesViewModel)
            .fontDesign(.rounded)
        }
    }
}
