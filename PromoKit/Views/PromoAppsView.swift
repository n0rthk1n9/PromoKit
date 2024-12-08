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
    @State private var showAddPromoAppSheet = false
    @State private var copiedToClipboard = false
    @Query private var promoApps: [PromoApp]

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(promoApps) { promoApp in
                    VStack {
                        Text(promoApp.name)
                        promoCodesGrid(for: promoApp)
                    }
                }
                .onDelete(perform: deletePromoApp)
            }
            .navigationTitle("Promo Kit")
            .toolbar {
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
            .overlay {
                if copiedToClipboard {
                    Text("✅ Copied to clipboard")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.secondary.opacity(0.2)))
                        .foregroundColor(Color.primary)
                        .transition(.move(edge: .bottom))
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 20)
                }
            }
        }
    }

    @ViewBuilder
    private func promoCodesGrid(for promoApp: PromoApp) -> some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(promoApp.promoCodes) { promoCode in
                PromoCodeView(
                    promoCode: promoCode,
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
