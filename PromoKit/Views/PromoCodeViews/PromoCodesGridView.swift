//
//  PromoCodesGridView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 10.12.2024.
//

import SwiftUI

struct PromoCodesGridView: View {
    var promoApp: PromoApp
    @Binding var appStorePromoCodeLink: String
    let copyMode: CopyMode
    let showCopiedToClipboardNotification: (String, CopyMode) -> Void
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(promoApp.promoCodes) { promoCode in
                PromoCodeView(
                    promoCode: promoCode,
                    appStorePromoCodeLink: $appStorePromoCodeLink,
                    appId: promoApp.appId,
                    copyMode: copyMode,
                    showCopyToClipboardNotification: showCopiedToClipboardNotification
                )
            }
        }
    }
}

// Hack to making archive build work
#if DEBUG
#Preview(traits: .sampleData) {
    PromoCodesGridView(
        promoApp: SampleData.promoApp2,
        appStorePromoCodeLink: .constant(""),
        copyMode: .code,
        showCopiedToClipboardNotification: {content, copyMode in}
    )
}
#endif
