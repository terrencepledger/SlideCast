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
                    Text("System Default").tag("System")
                    Text("Light Mode").tag("Light")
                    Text("Dark Mode").tag("Dark")
                }
                .pickerStyle(.segmented)
                .padding(.top, 10)
                
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
            
            Section(header: Text("Slideshow Info")) {
                // Placeholder for future settings
                Text("More options coming soon!")
                    .italic()
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Settings")
    }
    
    private func sendFeedback() {
        if let url = URL(string: AppConfig.supportEmail + "?subject=App%20Feedback") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    SettingsView()
}
