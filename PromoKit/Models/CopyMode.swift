//
//  CopyMode.swift
//  PromoKit
//
//  Created by Jan Armbrust on 10.12.2024.
//

import Foundation

enum CopyMode: String, CaseIterable, Identifiable {
    case code = "Code"
    case link = "Link"

    var id: String { self.rawValue }
}
