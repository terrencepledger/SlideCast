//
//  HapticsManager.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 1/3/25.
//


import UIKit

struct HapticsManager {
    private static let impactGenerator = UIImpactFeedbackGenerator()
    private static let notificationGenerator = UINotificationFeedbackGenerator()
    private static let selectionGenerator = UISelectionFeedbackGenerator()
    
    private static var hapticsEnabled: Bool {
        UserDefaults.standard.bool(forKey: AppConfig.UserDefaults.haptics)
    }
    
    static func prepare() {
        impactGenerator.prepare()
        notificationGenerator.prepare()
        selectionGenerator.prepare()
    }
    
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        if hapticsEnabled {
            impactGenerator.impactOccurred()
        }
    }
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        if hapticsEnabled {
            notificationGenerator.notificationOccurred(type)
        }
    }
    
    static func selection() {
        if hapticsEnabled {
            selectionGenerator.selectionChanged()
        }
    }
}
