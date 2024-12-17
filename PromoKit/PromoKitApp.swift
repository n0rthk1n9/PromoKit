//
//  PromoKitApp.swift
//  PromoKit
//
//  Created by Jan Armbrust on 05.12.2024.
//

import FreemiumKit
import LinksKit
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

    init() {
        self.configureLinksKit()
    }

    func configureLinksKit() {
        let ownApps = LinkSection(
            entries: [
                .link(
                    .ownApp(
                        id: "6503256642",
                        name: "App Exhibit: Your App Showcase",
                        systemImage: "square.grid.3x3.fill.square"
                    )
                )
            ]
        )

        let cihatsApps = LinkSection(
            entries: [
                .link(.friendsApp(id: "6502914189", name: "FreemiumKit: In-App Purchases", systemImage: "cart")),
                .link(.friendsApp(id: "6480134993", name: "FreelanceKit: Time Tracking", systemImage: "timer")),
                .link(.friendsApp(id: "6472669260", name: "CrossCraft: Crossword Tests", systemImage: "puzzlepiece")),
                .link(.friendsApp(id: "6477829138", name: "FocusBeats: Study Music Timer", systemImage: "music.note")),
                .link(.friendsApp(id: "6587583340", name: "Pleydia Organizer: Media Renamer", systemImage: "popcorn")),
                .link(
                    .friendsApp(
                        id: "6479207869", name: "Guided Guest Mode: Device Demo", systemImage: "questionmark.circle")),
                .link(
                    .friendsApp(id: "6478062053", name: "Posters: Discover Movies at Home", systemImage: "movieclapper")
                ),
            ]
        )

        LinksKit.configure(
            providerToken: "121426791",
            linkSections: [
                // TODO: exchange with actual URL
                .helpLinks(appID: "6503256642", faqURL: URL(string: ""), supportEmail: "promokit@xbow.dev"),
                .socialMenus(
                    appLinks: .appSocialLinks(
                        platforms: [.bluesky],
                        handle: "promokit.bsky.social"
                    ),
                    developerLinks: .developerSocialLinks(
                        platforms: [.bluesky, .mastodon(instance: "mastodon.social")],
                        handle: "n0rthk1n9.bsky.social"
                    )
                ),
                .appMenus(
                    ownAppLinks: [ownApps],
                    friendsAppLinks: [cihatsApps]
                ),
                // TODO: exchange with actual URL
                .legalLinks(privacyURL: URL(string: "https://promokit.app/privacy")!),
            ]
        )
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(sharedModelContainer)
                .fontDesign(.rounded)
                .environmentObject(FreemiumKit.shared)
        }
    }
}
