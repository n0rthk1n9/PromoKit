//
//  PromoCodesGridView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 10.12.2024.
//

import SwiftUI

struct PromoCodesGridView: View {
    var promoApp: PromoApp
    let copyMode: CopyMode
    let showCopiedToClipboardNotification: (String) -> Void
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(promoApp.promoCodes) { promoCode in
                PromoCodeView(
                    promoCode: promoCode,
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
        copyMode: .code,
        showCopiedToClipboardNotification: {content in}
    )
}
#endif
