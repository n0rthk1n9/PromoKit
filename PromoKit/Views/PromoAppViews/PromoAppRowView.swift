//
//  PromoAppRowView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 10.12.2024.
//

import SwiftData
import SwiftUI

struct PromoAppRowView: View {
    @Environment(\.colorScheme) private var colorScheme
    var promoAppId: String
    @State var appStorePromoCodeLink: String
    @State var copyMode: CopyMode
    let showCopiedToClipboardNotification: (String, CopyMode) -> Void

    @Query private var promoApps: [PromoApp]

    init(
        promoAppId: String, appStorePromoCodeLink: String = "", copyMode: CopyMode = .code,
        showCopiedToClipboardNotification: @escaping (String, CopyMode) -> Void
    ) {
        self.promoAppId = promoAppId
        self.appStorePromoCodeLink = appStorePromoCodeLink
        self.copyMode = copyMode
        self.showCopiedToClipboardNotification = showCopiedToClipboardNotification

        let promoAppIdString = promoAppId

        let predicate = #Predicate<PromoApp> { promoApp in
            promoApp.appId == promoAppIdString
        }

        _promoApps = Query(filter: predicate)
    }

    var body: some View {
        if let promoApp = promoApps.first {
            @Bindable var promoApp = promoApp

            VStack(alignment: .leading, spacing: 14) {
                PromoAppRowHeaderView(
                    promoApp: promoApp,
                    appStorePromoCodeLink: $appStorePromoCodeLink,
                    copyMode: $copyMode,
                    onCopyModeChange: { newMode in
                        copyMode = newMode
                    }
                )
                .accessibilityElement(children: .combine)
                HStack {
                    Button {
                        copyMode = .code
                        copyFirstUnusedPromoCode()
                    } label: {
                        Label("Copy code", systemImage: "doc.on.doc")
                            .foregroundStyle(.blue)
                            .frame(maxWidth: .infinity)
                    }
                    .tint(.blue)
                    .accessibilityLabel(
                        promoApp.promoCodes.allSatisfy { $0.isUsed || $0.isInvalid }
                            ? "No valid promo code to copy available" : "Copy first unused promo code")

                    Button {
                        copyMode = .link
                        copyFirstUnusedPromoCode()
                    } label: {
                        Label("Copy link", systemImage: "doc.on.doc")
                            .foregroundStyle(.mint)
                            .frame(maxWidth: .infinity)
                    }
                    .tint(.mint)
                    .accessibilityLabel(
                        promoApp.promoCodes.allSatisfy { $0.isUsed || $0.isInvalid }
                            ? "No valid promo code to copy available" : "Copy first unused promo code link")
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .disabled(promoApp.promoCodes.allSatisfy { $0.isUsed || $0.isInvalid })
                .opacity(promoApp.promoCodes.allSatisfy { $0.isUsed || $0.isInvalid } ? 0.3 : 1.0)
                .padding(.horizontal)

                DisclosureGroup(isExpanded: $promoApp.isPromoCodesSectionExpanded) {
                    PromoCodesGridView(
                        promoAppId: promoApp.appId,
                        appStorePromoCodeLink: $appStorePromoCodeLink,
                        copyMode: copyMode,
                        showCopiedToClipboardNotification: showCopiedToClipboardNotification
                    )
                    .padding(1)
                } label: {
                    Text("Promo codes")
                }
                .padding([.horizontal, .bottom])
                .accessibilityLabel(
                    promoApp.isPromoCodesSectionExpanded ? "Collaps promo codes section" : "Expand promo codes section")
            }
            .background {
                if colorScheme == .dark {
                    Color.secondary.opacity(0.2)
                } else {
                    Color.secondary.opacity(0.1)
                }
            }
            .background(colorScheme == .dark ? .black : .white)

        }
    }

    func copyFirstUnusedPromoCode() {
        let sortedPromoCodes = promoApps.first!.promoCodes
            .sorted { $0.code.localizedCompare($1.code) == .orderedAscending }

        if let promoCode = sortedPromoCodes.last(where: { !$0.isUsed && !$0.isInvalid }) {
            var contentToCopy: String = ""
            if copyMode == .link, let promoURL = promoCode.promoURL {
                contentToCopy = promoURL
            } else {
                contentToCopy = promoCode.code
            }
            appStorePromoCodeLink = contentToCopy
            promoCode.isUsed = true
            showCopiedToClipboardNotification(contentToCopy, copyMode)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            UIPasteboard.general.string = contentToCopy
        }
    }
}

// Hack to making archive build work
#if DEBUG
    #Preview(traits: .sampleData) {
        PromoAppRowView(
            promoAppId: SampleData.promoApp2.appId,
            appStorePromoCodeLink: "",
            copyMode: .link,
            showCopiedToClipboardNotification: { content, copyMode in }
        )
    }
#endif
