//
//  PromoAppRowHeaderView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 10.12.2024.
//

import SwiftUI

struct PromoAppRowHeaderView: View {
    var promoApp: PromoApp
    
    var body: some View {
        Text(promoApp.name)
            .font(.largeTitle)
            .bold()
            .fontDesign(.rounded)
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
    }
}

// Hack to making archive build work
#if DEBUG
#Preview(traits: .sampleData) {
    PromoAppRowHeaderView(promoApp: SampleData.promoApp2)
}
#endif
