//
//  MainView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 05.12.2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        PromoCodesView()
    }
}

#Preview {
    MainView()
        .environment(PromoCodesViewModel())
}
