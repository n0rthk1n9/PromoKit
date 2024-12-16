//
//  PromoCodesGridView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 10.12.2024.
//

import SwiftData
import SwiftUI

struct PromoCodesGridView: View {
    let promoAppId: String
    @Binding var appStorePromoCodeLink: String
    let copyMode: CopyMode
    let showCopiedToClipboardNotification: (String, CopyMode) -> Void

    @Query private var promoCodes: [PromoCode]

    init(promoAppId: String, appStorePromoCodeLink: Binding<String>, copyMode: CopyMode, showCopiedToClipboardNotification: @escaping (String, CopyMode) -> Void) {
        self.promoAppId = promoAppId
        self._appStorePromoCodeLink = appStorePromoCodeLink
        self.copyMode = copyMode
        self.showCopiedToClipboardNotification = showCopiedToClipboardNotification
        
        let predicate = #Predicate<PromoCode> { promoCode in
            promoCode.promoApp?.appId == promoAppId
        }
        _promoCodes = Query(filter: predicate, sort: \PromoCode.code)
    }

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(promoCodes) { promoCode in
                PromoCodeView(
                    promoCode: promoCode,
                    appStorePromoCodeLink: $appStorePromoCodeLink,
                    copyMode: copyMode,
                    showCopyToClipboardNotification: showCopiedToClipboardNotification
                )
            }
        }
        .accessibilityLabel(Text("Promo codes"))
    }
}

// Hack to making archive build work
#if DEBUG
    #Preview(traits: .sampleData) {
        PromoCodesGridView(
            promoAppId: SampleData.promoApp2.appId,
            appStorePromoCodeLink: .constant(""),
            copyMode: .code,
            showCopiedToClipboardNotification: { content, copyMode in }
        )
    }
#endif
