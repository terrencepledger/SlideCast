//
//  Extensions.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/30/24.
//

import UIKit
import SwiftUI
import GoogleCast

extension UIViewController {
    static func topMostViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }

        var topController: UIViewController? = keyWindow.rootViewController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        return topController
    }
}

extension View {
    func withGlobalLoadingOverlay() -> some View {
        self.modifier(GlobalLoadingModifier())
    }
    
    func showLoadingIndicator(with message: String? = nil) {
        let loadingManager = GlobalLoadingManager.shared
        loadingManager.message = message
        loadingManager.isLoading = true
    }
    
    func hideLoadingIndicator() {
        let loadingManager = GlobalLoadingManager.shared
        loadingManager.isLoading = false
        loadingManager.message = nil
    }
    
    func storeToolbar() -> some View {
        let castButton = CastButton()
        
        return self
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.primary)
                    }
                    .accessibilityLabel("Open Settings")
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    castButton
                        .onAppear {
                            GCKCastContext.sharedInstance()
                                .presentCastInstructionsViewControllerOnce(with: castButton.button)
                        }
                }
            }
    }
}

