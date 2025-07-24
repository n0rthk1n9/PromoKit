//
//  SettingsView.swift
//  PromoKit
//
//  Created by Jan Armbrust on 06.12.2024.
//

import SwiftUI
import FreemiumKit
import LinksKit

struct SettingsView: View {
    @State var showSetupInstructions: Bool = false
    
    var body: some View {
        Form {
            Section {
                PaidStatusView(style: .decorative(icon: .laurel))
                    .listRowBackground(Color.accentColor)
                    .padding(.vertical, -10)
            }
            Section("Setup instructions") {
                Button("How to set up PromoKit") {
                    showSetupInstructions.toggle()
                }
            }
            LinksView()
        }
        .sheet(isPresented: $showSetupInstructions) {
            OnboardingView(tint: .blue, title: "How to set up PromoKit") {
                Image("OnboardingIcon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(.rect(cornerRadius: 25))
                    .frame(height: 150)
            } cards: {
                OnboardingCard(
                    symbol: "ticket",
                    title: "Generate Promo Codes",
                    subtitle: "Go to App Store Connect -> Your App -> Promo Codes"
                )
                OnboardingCard(
                    symbol: "paperclip",
                    title: "Download .txt file",
                    subtitle: "Download your Promo Codes and save them to a location accessible from your iPhone, e.g. iCloud Drive"
                )
                OnboardingCard(
                    symbol: "plus",
                    title: "Add a new App in PromoKit",
                    subtitle: "Paste the App Store link to your app in PromoKit"
                )
                OnboardingCard(
                    symbol: "paperclip",
                    title: "Select .txt file from iCloud Drive",
                    subtitle: "Select the downloaded file and tap on Add"
                )
            } onContinue: {
                showSetupInstructions = false
            }
            
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(FreemiumKit.shared)
}
