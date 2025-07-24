//
//  OnboardingView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 24.07.2025.
//

import SwiftUI

struct OnboardingView<Icon: View>: View {
    var tint: Color
    var title: String
    var icon: Icon
    var cards: [OnboardingCard]
    var onContinue: () -> Void

    init(
        tint: Color,
        title: String,
        @ViewBuilder icon: @escaping () -> Icon,
        @OnboardingCardResultBuilder cards: @escaping () -> [OnboardingCard],
        onContinue: @escaping () -> Void
    ) {
        self.tint = tint
        self.title = title
        self.icon = icon()
        self.cards = cards()
        self.onContinue = onContinue
        self._animateCards = .init(initialValue: Array(repeating: false, count: self.cards.count))
    }

    @State private var animateIcon: Bool = false
    @State private var animateTitle: Bool = false
    @State private var animateCards: [Bool]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    icon
                        .frame(maxWidth: .infinity)
                        .blurSlide(animateIcon)
                    Text(title)
                        .frame(maxWidth: .infinity)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                        .blurSlide(animateTitle)
                    CardsView()
                }
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)

            Button(action: onContinue) {
                Text("Continue")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    #if os(macOS)
                        .padding(.vertical, 8)
                    #else
                        .padding(.vertical, 4)
                    #endif
            }
            .tint(tint)
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: 350)
        .interactiveDismissDisabled()
        .allowsTightening(animateCards.last == true)
        .task {
            guard !animateIcon else { return }

            await delayedAnimation(0.35) {
                animateIcon = true
            }

            await delayedAnimation(0.2) {
                animateTitle = true
            }

            try? await Task.sleep(for: .seconds(0.2))

            for index in animateCards.indices {
                let delay = Double(index) * 0.1
                await delayedAnimation(delay) {
                    animateCards[index] = true
                }
            }
        }
        .setUpOnBoarding()
    }

    @ViewBuilder
    func CardsView() -> some View {
        Group {
            ForEach(cards.indices, id: \.self) { index in
                let card = self.cards[index]

                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: card.symbol)
                        .font(.title)
                        .foregroundStyle(tint)
                        .symbolVariant(.fill)
                        .frame(width: 45)
                        .offset(y: 10)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(card.title)
                            .font(.title3)
                            .lineLimit(1)
                        Text(card.subtitle)
                            .lineLimit(3)
                    }
                }
                .blurSlide(animateCards[index])
            }
        }
    }

    func delayedAnimation(_ delay: Double, action: @escaping () -> Void) async {
        try? await Task.sleep(for: .seconds(delay))

        withAnimation(.smooth) {
            action()
        }
    }
}

#Preview {
    PromoAppsView()
}
