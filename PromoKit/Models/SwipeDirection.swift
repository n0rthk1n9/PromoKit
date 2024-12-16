//
//  SwipeDirection.swift
//  PromoKit
//
//  Created by Jan Armbrust on 13.12.2024.
//

import SwiftUI

enum SwipeDirection {
    case leading
    case trailing
    
    var alignment: Alignment {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}
