//
//  PromoCodeView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 08.12.2024.
//

import SwiftUI

struct PromoCodeView: View {
    var promoCode: PromoCode
    @Binding var appStorePromoCodeLink: String
    let copyMode: CopyMode
    let showCopyToClipboardNotification: (String, CopyMode) -> Void
    @State private var showingUnuseAlert = false

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
        .onLongPressGesture {
            if promoCode.isUsed && promoCode.daysRemaining != 0 {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                showingUnuseAlert = true
            }
        }
        .alert("Mark Code as Unused?", isPresented: $showingUnuseAlert) {
            Button("Confirm", role: .destructive) {
                promoCode.isUsed = false
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to mark this promo code as unused?")
        }
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
        appStorePromoCodeLink = contentToCopy
        promoCode.isUsed = true
        showCopyToClipboardNotification(contentToCopy, copyMode)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        UIPasteboard.general.string = contentToCopy
    }
}

// Hack to making archive build work
#if DEBUG
    #Preview(traits: .sampleData) {
        PromoCodeView(
            promoCode: SampleData.promoCode1PromoApp1,
            appStorePromoCodeLink: .constant(""),
            copyMode: .code,
            showCopyToClipboardNotification: { content, copyMode in }
        )
    }
#endif

// Hack to making archive build work
#if DEBUG
    #Preview(traits: .sampleData) {
        PromoCodeView(
            promoCode: SampleData.promoCode2PromoApp1,
            appStorePromoCodeLink: .constant(""),
            copyMode: .code,
            showCopyToClipboardNotification: { content, copyMode in }
        )
    }
#endif
