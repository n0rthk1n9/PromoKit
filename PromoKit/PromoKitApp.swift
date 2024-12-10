//
//  PromoKitApp.swift
//  PromoKit
//
//  Created by Jan Armbrust on 05.12.2024.
//

import SwiftData
import SwiftUI

@main
struct PromoKitApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PromoApp.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(sharedModelContainer)
                .fontDesign(.rounded)
        }
    }
}
