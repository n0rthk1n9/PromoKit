//
//  PromoAppRowView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 10.12.2024.
//

import SwiftUI

struct PromoAppRowView: View {
    var promoApp: PromoApp
    @State var appStorePromoCodeLink: String = ""
    @State var copyMode: CopyMode = .code
    let showCopiedToClipboardNotification: (String, CopyMode) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            PromoAppRowHeaderView(
                promoApp: promoApp,
                appStorePromoCodeLink: $appStorePromoCodeLink,
                copyMode: $copyMode,
                onCopyModeChange: { newMode in
                    copyMode = newMode
                }
            )
            PromoCodesGridView(
                promoAppId: promoApp.appId,
                appStorePromoCodeLink: $appStorePromoCodeLink,
                copyMode: copyMode,
                showCopiedToClipboardNotification: showCopiedToClipboardNotification
            )
        }
        .padding(.vertical)
    }
}

// Hack to making archive build work
#if DEBUG
    #Preview(traits: .sampleData) {
        PromoAppRowView(
            promoApp: SampleData.promoApp2,
            copyMode: .link,
            showCopiedToClipboardNotification: { content, copyMode in }
        )
    }
#endif
