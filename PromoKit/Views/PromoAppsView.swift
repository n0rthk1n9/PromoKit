//
//  PromoAppsView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 06.12.2024.
//

import SwiftData
import SwiftUI

struct PromoAppsView: View {
    @Environment(\.modelContext) var context
    @Environment(\.colorScheme) private var colorScheme
    @State private var showAddPromoAppSheet = false
    @State private var copiedToClipboard = false
    @State private var copyMode: CopyMode = .code
    @State private var appStorePromoCodeLink: String = ""

    @Query(sort: \PromoApp.name) private var promoApps: [PromoApp]

    enum CopyMode: String, CaseIterable, Identifiable {
        case code = "Code"
        case link = "Link"

        var id: String { self.rawValue }
    }

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var shadowColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.6) : Color.gray.opacity(0.3)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Copy Mode", selection: $copyMode) {
                    ForEach(CopyMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                if !promoApps.isEmpty {
                    List {
                        ForEach(promoApps) { promoApp in
                            VStack(alignment: .leading) {
                                Text(promoApp.name)
                                    .font(.largeTitle)
                                    .bold()
                                    .fontDesign(.rounded)
                                promoCodesGrid(for: promoApp)
                            }
                            .padding(.vertical)
                        }
                        .onDelete(perform: deletePromoApp)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.secondary.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.secondary, lineWidth: 1)

                                )
                                .padding(.vertical, 10)
                                .padding(.horizontal, 1)
                        )
                        .listRowSeparator(.hidden)
                    }
                } else {
                    ContentUnavailableView {
                        Button {
                            generateSampleData()
                        } label: {
                            Text("Add demo app")
                        }
                    }
                }
            }
            .navigationTitle("Promo Kit")
            .toolbar {
                if appStorePromoCodeLink != "" {
                    withAnimation(.snappy) {
                        ToolbarItem(placement: .topBarTrailing) {
                            if let appStorePromoCodeLink = URL(string: appStorePromoCodeLink) {
                                ShareLink(item: appStorePromoCodeLink) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.body)
                                }
                                .transition(.opacity)
                                .padding(0)
                                .frame(width: 20)
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddPromoAppSheet.toggle()
                    } label: {
                        Label("Add", systemImage: "plus")
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
                        Capsule()
                            .stroke(.white, lineWidth: 2)
                            .foregroundStyle(.regularMaterial)
                    )
                    .foregroundColor(Color.primary)
                    .transition(.opacity)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }

    @ViewBuilder
    private func promoCodesGrid(for promoApp: PromoApp) -> some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(promoApp.promoCodes) { promoCode in
                PromoCodeView(
                    promoCode: promoCode,
                    appId: promoApp.appId,
                    appStorePromoCodeLink: $appStorePromoCodeLink,
                    copyMode: copyMode,
                    showCopyToClipboardNotification: showCopiedToClipboardNotification
                )
            }
        }
    }

    func showCopiedToClipboardNotification() {
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

    func deletePromoApp(at offsets: IndexSet) {
        for index in offsets {
            let promoAppToDelete = promoApps[index]
            withAnimation {
                context.delete(promoAppToDelete)
            }
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
        let promoCode2 = PromoCode(code: "NTYEJLYFHYJT", dateAdded: .now, used: true)
        let promoCode3 = PromoCode(code: "7HMHWLA6A9JM", dateAdded: .now, used: false)

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
    }
#endif
