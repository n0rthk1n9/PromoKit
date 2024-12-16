//
//  PromoAppSwipeToDeleteTransition.swift
//  PromoKit
//
//  Created by Jan Armbrust on 15.12.2024.
//

import SwiftUI

struct PromoAppSwipeToDeleteTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                GeometryReader {
                    let size = $0.size
                    
                    Rectangle()
                        .offset(y: phase == .identity ? 0 : -size.height)
                }
                .containerRelativeFrame(.horizontal)
            }
    }
}
