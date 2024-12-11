//
//  PromoAppRowView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 10.12.2024.
//

import SwiftUI

struct PromoAppRowView: View {
    var promoApp: PromoApp
    let copyMode: CopyMode
    let showCopiedToClipboardNotification: (String) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            PromoAppRowHeaderView(promoApp: promoApp)
            PromoCodesGridView(
                promoApp: promoApp,
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
            copyMode: .code,
            showCopiedToClipboardNotification: {content in}
        )
    }
#endif
