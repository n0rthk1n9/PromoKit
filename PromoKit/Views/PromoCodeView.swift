//
//  PromoCodeView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 08.12.2024.
//

import SwiftUI

struct PromoCodeView: View {
    var promoCode: PromoCode
    let showCopyToClipboardNotification: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: "ticket")
                    .font(.title3)
                Spacer()
                Button {
                    copyToClipboard()
                } label: {
                    Text("Copy")
                }
                .buttonStyle(.bordered)
                .controlSize(.mini)
                .tint(.blue)
            }
            Text(promoCode.code)
                .font(.footnote)
        }
        .padding(8)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.secondary, lineWidth: 1)
        }
        
    }
    
    func copyToClipboard() {
        showCopyToClipboardNotification()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        UIPasteboard.general.string = promoCode.code
    }
}

#Preview(traits: .sampleData) {
    PromoCodeView(promoCode: SampleData.promoCode1PromoApp1, showCopyToClipboardNotification: {})
}
