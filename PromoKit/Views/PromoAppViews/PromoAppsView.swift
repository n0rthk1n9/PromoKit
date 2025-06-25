//
//  PromoAppsView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 06.12.2024.
//

import SwiftData
import SwiftUI
import FreemiumKit

struct PromoAppsView: View {
    @Environment(\.modelContext) var context
    @State private var showAddPromoAppSheet = false
    @State private var copiedToClipboard = false
    @State private var copyMode: CopyMode = .code

    @Query(sort: \PromoApp.name, animation: .easeInOut(duration: 0.35)) private var promoApps: [PromoApp]

    init() {
        var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleFont = UIFont(
            descriptor:
                titleFont.fontDescriptor
                .withDesign(.rounded)?
                .withSymbolicTraits(.traitBold)
                ?? titleFont.fontDescriptor,
            size: titleFont.pointSize
        )
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
    }

    var body: some View {
        NavigationStack {
            VStack {
                if !promoApps.isEmpty {
                    ScrollView {
                        ForEach(promoApps) { promoApp in
                            PromoAppSwipeActionView(cornerRadius: 28, direction: .trailing) {
                                PromoAppRowView(
                                    promoAppId: promoApp.appId,
                                    showCopiedToClipboardNotification: showCopiedToClipboardNotification
                                )
                            } actions: {
                                Action(tint: .red, icon: "trash.fill") {
                                    delete(promoApp)
                                }
                            }
                            .accessibilityAction(named: "Delete app from Promo Kit") {
                                delete(promoApp)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding([.horizontal, .bottom])
                } else {
                    ContentUnavailableView {
                        Label("Add your app", systemImage: "plus")
                    } description: {
                        Text(
                            "When you add an app, you can import promo codes from the file App Store Connect generates for you"
                        )
                    } actions: {
                        Button {
                            generateSampleData()
                        } label: {
                            Text("Add a demo app to test the features")
                        }
                    }
                }
            }
            .navigationTitle("Promo Kit")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PaidFeatureButton("Add", systemImage: "plus") {
                        promoApps.isEmpty
                    } action: {
                        showAddPromoAppSheet.toggle()
                    }
                }
            }
            .sheet(isPresented: $showAddPromoAppSheet) {
                AddPromoAppView()
            }
        }
        .overlay {
            if copiedToClipboard {
                Text(copyMode == .code ? "✅ ✍️ copied" : "✅ 🔗 copied")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(
                        ZStack {
                            Capsule()
                                .fill(.regularMaterial)  // Fill with a background color or material
                            Capsule()
                                .stroke(.white, lineWidth: 2)  // Stroke with white outline
                        }
                    )
                    .foregroundColor(Color.primary)
                    .transition(.opacity)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }

    func showCopiedToClipboardNotification(with copiedContent: String, copyMode: CopyMode) {
        self.copyMode = copyMode
        withAnimation {
            copiedToClipboard = true
        }
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            withAnimation {
                copiedToClipboard = false
            }
        }
    }

    func delete(_ promoApp: PromoApp) {
        Task {
            try? await Task.sleep(for: .seconds(0.25))
            context.delete(promoApp)
        }
    }

    // TODO: Remove bevor deplayment
    func generateSampleData() {
        // Create new instances of promo apps
        let promoApp1 = PromoApp(name: "App Exhibit", version: "1.3", appId: "6503256642")
        let promoApp2 = PromoApp(name: "Cosmo Pic", version: "1.0", appId: "129381232")

        // Insert promo apps into the context
        context.insert(promoApp1)
        context.insert(promoApp2)

        // Create promo codes for promoApp1
        let promoCode1 = PromoCode(code: "AF4HYL4EETAP", dateAdded: .now, used: false)
        let promoCode2 = PromoCode(
            code: "NTYEJLYFHYJT",
            dateAdded: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
            used: false
        )
        let promoCode3 = PromoCode(code: "7HMHWLA6A9JM", dateAdded: .now, used: true)

        // Assign the promo codes to promoApp1
        promoCode1.promoApp = promoApp1
        promoCode2.promoApp = promoApp1
        promoCode3.promoApp = promoApp1

        // Insert promo codes into the context and add them to promoApp1's promoCodes array
        context.insert(promoCode1)
        context.insert(promoCode2)
        context.insert(promoCode3)
        promoApp1.promoCodes.append(contentsOf: [promoCode1, promoCode2, promoCode3])

        // Create a promo code for promoApp2
        let promoCode4 = PromoCode(code: "AF4HYL4EETAP", dateAdded: .now, used: false)
        promoCode4.promoApp = promoApp2

        // Insert promo code into the context and add it to promoApp2's promoCodes array
        context.insert(promoCode4)
        promoApp2.promoCodes.append(promoCode4)
    }
}

// Hack to making archive build work
#if DEBUG
    #Preview(traits: .sampleData) {
        PromoAppsView()
            .environmentObject(FreemiumKit.shared)
    }
#endif
