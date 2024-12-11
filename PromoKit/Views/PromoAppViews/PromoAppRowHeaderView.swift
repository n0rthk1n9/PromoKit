//
//  PromoAppRowHeaderView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 10.12.2024.
//

import SwiftUI

struct PromoAppRowHeaderView: View {
    var promoApp: PromoApp
    @Binding var appStorePromoCodeLink: String
    @Binding var copyMode: CopyMode
    var onCopyModeChange: (CopyMode) -> Void

    @State private var isLinkMode: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(promoApp.name)
                    .font(.largeTitle)
                    .bold()
                    .fontDesign(.rounded)
                Text("Version: \(promoApp.version)")
                    .font(.caption)
            }
            Spacer()
            if let appStorePromoCodeLink = URL(string: appStorePromoCodeLink), isLinkMode {
                ShareLink(item: appStorePromoCodeLink) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.body)
                }
            }
            Image(systemName: "link")
            Toggle(isOn: $isLinkMode) {
                Image(systemName: "link")
            }
            .labelsHidden()
            .disabled(promoApp.validCodesRemaining == 0)
            .onChange(of: isLinkMode) { newValue, oldValue in
                let newMode: CopyMode = newValue ? .code : .link
                onCopyModeChange(newMode)
            }

        }
        .onAppear {
            isLinkMode = copyMode == .link
        }
        Text(
            promoApp.daysRemaining > 0
                ? "\(promoApp.daysRemaining) days remaining" : "🚫 All codes expired or used"
        )
        .font(.headline)
        .foregroundStyle(promoApp.daysRemaining > 0 ? .green : .red)
        .transition(
            promoApp.daysRemaining > 0 ? .identity : .move(edge: .top)
        )
        .animation(.easeIn(duration: 0.4), value: promoApp.daysRemaining)
        ProgressView(value: progressValue)
            .progressViewStyle(
                LinearProgressViewStyle(
                    progressValue: progressValue
                )
            )

        Text("\(promoApp.validCodesRemaining) of \(promoApp.promoCodes.count) codes available")
            .font(.subheadline)
            .opacity(progressValue == 0 ? 0.2 : 1.0)
    }

    private var progressValue: Double {
        guard !promoApp.promoCodes.isEmpty else { return 0.0 }
        return Double(promoApp.validCodesRemaining) / Double(promoApp.promoCodes.count)
    }
}

// Hack to making archive build work
#if DEBUG
    #Preview(traits: .sampleData) {
        PromoAppRowHeaderView(
            promoApp: SampleData.promoApp2,
            appStorePromoCodeLink: .constant(""),
            copyMode: .constant(.code),
            onCopyModeChange: { copyMode in }
        )
    }
#endif
