//
//  AppsView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 05.12.2024.
//

import SwiftUI

struct AppsView: View {
    var body: some View {
        PromoCodesView()
    }
}

#Preview {
    AppsView()
        .environment(PromoCodesViewModel())
}
