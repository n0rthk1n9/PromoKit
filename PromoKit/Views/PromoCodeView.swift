//
//  PromoCodeView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 08.12.2024.
//

import SwiftUI

struct PromoCodeView: View {
    var promoCode: PromoCode
    let appId: String
    @Binding var appStorePromoCodeLink: String
    let copyMode: PromoAppsView.CopyMode
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
                .tint(copyMode == .link ? .mint : .blue)
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
        let contentToCopy: String
        if copyMode == .link {
            contentToCopy = generateLink(for: appId, with: promoCode.code)
        } else {
            appStorePromoCodeLink = ""
            contentToCopy = promoCode.code
        }
        showCopyToClipboardNotification()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        UIPasteboard.general.string = contentToCopy
    }

    func generateLink(for appId: String, with code: String) -> String {
        self.appStorePromoCodeLink = "https://apps.apple.com/redeem?ctx=offercodes&id=\(appId)&code=\(code)"
        
        return "https://apps.apple.com/redeem?ctx=offercodes&id=\(appId)&code=\(code)"
    }
}

// Hack to making archive build work
#if DEBUG
    #Preview(traits: .sampleData) {
        PromoCodeView(
            promoCode: SampleData.promoCode1PromoApp1,
            appId: SampleData.promoApp1.appId,
            appStorePromoCodeLink: .constant(""),
            copyMode: .code,
            showCopyToClipboardNotification: {}
        )
    }
#endif
