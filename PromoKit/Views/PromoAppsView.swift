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

    @Query private var promoApps: [PromoApp]

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
            Picker("Copy Mode", selection: $copyMode) {
                ForEach(CopyMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
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
}

// Hack to making archive build work
#if DEBUG
    #Preview(traits: .sampleData) {
        PromoAppsView()
    }
#endif
