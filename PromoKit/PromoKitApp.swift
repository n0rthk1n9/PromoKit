//
//  PromoKitApp.swift
//  PromoKit
//
//  Created by Jan Armbrust on 05.12.2024.
//

import SwiftUI

@main
struct PromoKitApp: App {
    @State var promoCodesViewModel = PromoCodesViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Apps", systemImage: "app.fill") {
                    AppsView()
                }
                Tab("Settings", systemImage: "gear") {
                    SettingsView()
                }
            }
            .environment(promoCodesViewModel)
            .fontDesign(.rounded)
        }
    }
}
