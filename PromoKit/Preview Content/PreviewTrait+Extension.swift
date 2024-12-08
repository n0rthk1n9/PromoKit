//
//  PreviewTrait+Extension.swift
//  PromoKit
//
//  Created by Jan Armbrust on 08.12.2024.
//

import SwiftUI

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
