//
//  SlideCastApp.swift
//  SlideCast
//
//  Created by Terrence Pledger on 6/8/24.
//

import SwiftUI
import SwiftData
import GoogleCast

@main
struct SlidesCastApp: App {
    @AppStorage(AppConfig.UserDefaults.appearance) private var appearanceMode: AppearanceMode = .systemDefault
    
    var body: some Scene {
        WindowGroup {
            if isProduction {
                ContentView()
                    .onAppear {
                        CastManager.setup()
                        LocalServerManager.startServer()
                        GoogleSignInService.setup()
                    }
                    .withGlobalLoadingOverlay()
                    .onChange(of: appearanceMode) {
                        updateAppearance(mode: appearanceMode)
                    }
            }
        }
    }
    
    private var isProduction: Bool {
        NSClassFromString("XCTest") == nil
    }
    
    private func updateAppearance(mode: AppearanceMode) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let keyWindow = windowScene?.windows.first(where: { $0.isKeyWindow })
        
        switch mode {
        case .light:
            keyWindow?.overrideUserInterfaceStyle = .light
        case .dark:
            keyWindow?.overrideUserInterfaceStyle = .dark
        default:
            keyWindow?.overrideUserInterfaceStyle = .unspecified
        }
    }
}

