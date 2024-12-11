//
//  LinearProgressView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 11.12.2024.
//

import SwiftUI

struct LinearProgressViewStyle: ProgressViewStyle {
    var height: CGFloat = 20
    var cornerRadius: CGFloat = 10
    var backgroundColor: Color = Color.gray.opacity(0.3)
    var strokeWidth: CGFloat = 2
    var progressValue: Double

    @Environment(\.colorScheme) var colorScheme

    var progressColor: Color {
        switch progressValue {
        case 0.2...:
            return .green
        case 0.1..<0.2:
            return .yellow
        case 0..<0.1:
            return .red
        default:
            return .red
        }
    }

    var strokeColor: Color {
        colorScheme == .dark ? .white : .black
    }

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .frame(height: height)

                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(progressColor)
                    .frame(width: proxy.size.width * CGFloat(configuration.fractionCompleted ?? 0.0), height: height)
                    .animation(.easeInOut(duration: 0.6), value: configuration.fractionCompleted) // Smooth animation
            }
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(strokeColor, lineWidth: strokeWidth)
            )
            .grayscale(progressValue == 0 ? 1.0 : 0.0)
            .opacity(progressValue == 0 ? 0.5 : 1.0)
        }
        .frame(height: height)
    }
}
