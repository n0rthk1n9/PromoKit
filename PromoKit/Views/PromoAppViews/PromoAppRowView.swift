//
//  PromoAppRowView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 10.12.2024.
//

import SwiftUI

struct PromoAppRowView: View {
    var promoApp: PromoApp
    @Binding var appStorePromoCodeLink: String
    let copyMode: CopyMode
    let showCopiedToClipboardNotification: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            PromoAppRowHeaderView(promoApp: promoApp)
            PromoCodesGridView(
                promoApp: promoApp,
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
            appStorePromoCodeLink: .constant(""),
            copyMode: .code,
            showCopiedToClipboardNotification: {}
        )
    }
#endif
