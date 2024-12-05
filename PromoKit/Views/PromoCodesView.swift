//
//  PromoCodesView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 05.12.2024.
//

import SwiftUI

struct PromoCodesView: View {
    @Environment(PromoCodesViewModel.self) var viewModel

    @State private var isFileImporterPresented = false

    var body: some View {
        VStack {
            List(viewModel.promoCodes) { promoCode in
                Text(promoCode.code)
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
                        viewModel.readPromoCodes(from: selectedFile)
                    }
                case .failure(let error):
                    print("File selection error: \(error.localizedDescription)")
                }
            }
        }
        .padding()
        .navigationTitle("Promo Codes")
    }
}

#Preview {
    PromoCodesView()
        .environment(PromoCodesViewModel())
}
