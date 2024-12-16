//
//  AddPromoAppView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 06.12.2024.
//

import SwiftData
import SwiftUI

struct AddPromoAppView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context

    @State private var promoApp = PromoApp()

    private var isFormValid: Bool {
        !promoApp.name.isEmpty && !promoApp.version.isEmpty && !promoApp.link.isEmpty && !promoApp.appId.isEmpty
            && !promoApp.promoCodes.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("App Name", text: $promoApp.name)
                    TextField("App Version", text: $promoApp.version)
                    TextField("Paste App Store link to extract App ID", text: $promoApp.link)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                }
                Section("App ID") {
                    Text(promoApp.appId)
                }
                PromoCodesView(promoApp: promoApp)
            }
            .navigationTitle("Add App")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        withAnimation {
                            context.insert(promoApp)
                            dismiss()
                        }
                    } label: {
                        Text("Add")
                    }
                    .disabled(!isFormValid)
                }
            }
            .onChange(of: promoApp.link) { oldValue, newValue in
                if newValue != oldValue {
                    updateAppIdFromLink()
                }
            }
            .autocorrectionDisabled()
            .submitLabel(.done)
        }
    }

    private func updateAppIdFromLink() {
        guard let url = URL(string: promoApp.link) else {
            promoApp.appId = ""
            return
        }

        let pathComponents = url.pathComponents
        let regexPattern = #"id(\d+)"#

        do {
            let regex = try NSRegularExpression(pattern: regexPattern)
            for component in pathComponents {
                let range = NSRange(location: 0, length: component.utf16.count)
                if let match = regex.firstMatch(in: component, options: [], range: range),
                    let idRange = Range(match.range(at: 1), in: component)
                {
                    promoApp.appId = String(component[idRange])
                    return
                }
            }
        } catch {
            print("Regex error: \(error)")
        }

        promoApp.appId = ""
    }
}

#Preview {
    AddPromoAppView()
        .modelContainer(for: PromoApp.self)
}
