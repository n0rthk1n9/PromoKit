//
//  PromoAppsView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 06.12.2024.
//

import SwiftData
import SwiftUI

struct PromoAppsView: View {
    @State private var showAddPromoAppSheet = false
    @Query private var promoApps: [PromoApp]

    var body: some View {
        NavigationStack {
            List {
                ForEach(promoApps) { promoApp in
                    Text(promoApp.name)
                }
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
}

#Preview {
    PromoAppsView()
        .modelContainer(for: PromoApp.self)
}
