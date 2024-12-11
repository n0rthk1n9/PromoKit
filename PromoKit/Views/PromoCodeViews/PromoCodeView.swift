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
    let copyMode: CopyMode
    let showCopyToClipboardNotification: (String) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: "ticket")
                    .font(.title3)
                Spacer()
                if promoCode.isUsed {
                    Text("✅")
                        .font(.title3)
                        .frame(minHeight: 24)
                        .transition(.scale.combined(with: .opacity))
                } else if promoCode.isInvalid {
                    Text("🚫")
                        .font(.title3)
                        .frame(minHeight: 24)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Button {
                        copyToClipboard()
                    } label: {
                        Text("Copy")
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.mini)
                    .tint(copyMode == .link ? .mint : .blue)
                    .disabled(promoCode.isInvalid)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: promoCode.isUsed)
            .animation(.easeInOut(duration: 0.3), value: promoCode.isInvalid)
            Text(promoCode.code)
                .font(.footnote)
        }
        .padding(8)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.secondary, lineWidth: 1)
        }
        .opacity(promoCode.isInvalid ? 0.3 : 1.0)

    }

    func copyToClipboard() {
        var contentToCopy: String = ""
        if copyMode == .link {
            if let promoURL = promoCode.promoURL {
                contentToCopy = promoURL
            }
        } else {
            contentToCopy = promoCode.code
        }
        promoCode.isUsed = true
        showCopyToClipboardNotification(contentToCopy)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        UIPasteboard.general.string = contentToCopy
    }
}

// Hack to making archive build work
#if DEBUG
    #Preview(traits: .sampleData) {
        PromoCodeView(
            promoCode: SampleData.promoCode1PromoApp1,
            appId: SampleData.promoApp1.appId,
            copyMode: .code,
            showCopyToClipboardNotification: {content in}
        )
    }
#endif

// Hack to making archive build work
#if DEBUG
    #Preview(traits: .sampleData) {
        PromoCodeView(
            promoCode: SampleData.promoCode2PromoApp1,
            appId: SampleData.promoApp1.appId,
            copyMode: .code,
            showCopyToClipboardNotification: {content in}
        )
    }
#endif
