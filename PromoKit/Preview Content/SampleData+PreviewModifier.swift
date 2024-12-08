//
//  SampleData+PreviewModifier.swift
//  PromoKit
//
//  Created by Jan Armbrust on 08.12.2024.
//

import SwiftData
import SwiftUI

extension SampleData: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: PromoApp.self,
            configurations: config
        )
        
        for promoApp in SampleData.promoApps {
            container.mainContext.insert(promoApp)
            for promoCode in SampleData.promoCodesPromoApp1 {
                container.mainContext.insert(promoCode)
                promoApp.promoCodes.append(promoCode)
            }
        }
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content
            .modelContainer(context)
    }
}
