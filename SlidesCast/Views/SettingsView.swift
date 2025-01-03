//
//  SettingsView.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 1/2/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(AppConfig.UserDefaults.haptics) private var hapticsEnabled = true
    @AppStorage(AppConfig.UserDefaults.appearance) private var appearanceMode: AppearanceMode = .systemDefault
    
    var body: some View {
        Form {
            Section(header: Text("Preferences")) {
                Picker("Appearance", selection: $appearanceMode) {
                    ForEach(AppearanceMode.allCases) { mode in
                        Text(mode.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 10)
                .onChange(of: appearanceMode) {
                    HapticsManager.selection()
                }
                
                Toggle("Enable Haptics", isOn: $hapticsEnabled)
            }
            
            Section(header: Text("Feedback")) {
                Button(action: sendFeedback) {
                    HStack {
                        Image(systemName: "envelope")
                        Text("Send App Feedback")
                    }
                }
            }
            
            Section(header: Text("Slideshow Overlays")) {
                // TODO: Overlay settings
                Text("More options coming soon!")
                    .italic()
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            HapticsManager.prepare()
        }
        .navigationTitle("Settings")
    }
    
    private func sendFeedback() {
        HapticsManager.impact(style: .light)
        let feedbackSubject = "?subject=App%20Feedback"
        if let url = URL(string: AppConfig.supportEmail + feedbackSubject) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    SettingsView()
}
