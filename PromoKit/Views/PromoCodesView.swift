//
//  PromoCodesView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 05.12.2024.
//

import SwiftData
import SwiftUI

struct PromoCodesView: View {
    @Environment(\.modelContext) var context
    var promoApp: PromoApp

    @State private var isFileImporterPresented = false

    var body: some View {
        VStack {
            List(promoApp.promoCodes) { promoCode in
                Text("\(promoCode.code) belongs to \(promoApp.name)")
            }
            Button("Import Promo Codes") {
                isFileImporterPresented = true
            }
            .fileImporter(
                isPresented: $isFileImporterPresented,
                allowedContentTypes: [.plainText],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    if let selectedFile = urls.first {
                        readPromoCodes(from: selectedFile)
                    }
                case .failure(let error):
                    print("File selection error: \(error.localizedDescription)")
                }
            }
        }
        .padding()
        .navigationTitle("Promo Codes")
    }

    func readPromoCodes(from fileURL: URL) {
        do {
            guard fileURL.startAccessingSecurityScopedResource() else {
                print("Unable to access the file at \(fileURL.path).")
                return
            }
            defer { fileURL.stopAccessingSecurityScopedResource() }

            let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = fileContents.split(separator: "\n")

            let newPromoCodes =
                lines
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .map { PromoCode(code: $0, promoApp: promoApp) }

            for promoCode in newPromoCodes {
                // add promo code to SwiftData
                context.insert(promoCode)
                promoApp.promoCodes.append(promoCode)
            }
        } catch {
            print("Error reading file: \(error)")
        }
    }
}

// Hack to making archive build work
#if DEBUG
#Preview(traits: .sampleData) {
    PromoCodesView(promoApp: SampleData.promoApp1)
}
#endif
