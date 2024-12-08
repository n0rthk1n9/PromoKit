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
    @Query private var promoApps: [PromoApp]

    var body: some View {
        NavigationStack {
            List {
                ForEach(promoApps) { promoApp in
                    VStack {
                        Text(promoApp.name)
                        ForEach(promoApp.promoCodes) { promoCode in
                            Text("\(promoCode.code) belongs to \(promoApp.name)")
                        }
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

#Preview(traits: .sampleData) {
    PromoAppsView()
}
