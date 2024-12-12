//
//  PromoAppRowView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 10.12.2024.
//

import SwiftData
import SwiftUI

struct PromoAppRowView: View {
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
        // BAD FIX THAT
        @Bindable var promoApp = promoApps.first!

        VStack(alignment: .leading, spacing: 18) {
            PromoAppRowHeaderView(
                promoApp: promoApp,
                appStorePromoCodeLink: $appStorePromoCodeLink,
                copyMode: $copyMode,
                onCopyModeChange: { newMode in
                    copyMode = newMode
                }
            )
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
                
                Button {
                    copyMode = .link
                    copyFirstUnusedPromoCode()
                } label: {
                    Label("Copy link", systemImage: "doc.on.doc")
                        .foregroundStyle(.mint)
                        .frame(maxWidth: .infinity)
                }
                .tint(.mint)
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .disabled(promoApp.promoCodes.allSatisfy { $0.isUsed || $0.isInvalid })
            .opacity(promoApp.promoCodes.allSatisfy { $0.isUsed || $0.isInvalid } ? 0.3 : 1.0)
            
            DisclosureGroup(isExpanded: $promoApp.isPromoCodesSectionExpanded) {
                PromoCodesGridView(
                    promoAppId: promoApp.appId,
                    appStorePromoCodeLink: $appStorePromoCodeLink,
                    copyMode: copyMode,
                    showCopiedToClipboardNotification: showCopiedToClipboardNotification
                )
            } label: {
                Text("Codes")
            }

        }
        .padding()
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
