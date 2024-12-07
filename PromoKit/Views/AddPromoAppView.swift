//
//  AddPromoAppView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 06.12.2024.
//

import SwiftUI
import SwiftData

struct AddPromoAppView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context

    @State private var promoApp = PromoApp()

    var body: some View {
        NavigationStack {
            Form {
                TextField("App Name", text: $promoApp.name)
                TextField("App Version", text: $promoApp.version)
                PromoCodesView(promoApp: promoApp)
            }
            .navigationTitle("Add App")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            context.insert(promoApp)
                            dismiss()
                        }
                    } label: {
                        Text("Add")
                    }
                }
            }
        }
    }
}

#Preview {
    AddPromoAppView()
        .modelContainer(for: PromoApp.self)
}
