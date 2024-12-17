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
    @UIApplicationDelegateAdaptor(SlidesCastAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class SlidesCastAppDelegate: NSObject, UIApplicationDelegate, GCKLoggerDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let criteria = GCKDiscoveryCriteria(applicationID: kGCKDefaultMediaReceiverApplicationID)
        let options = GCKCastOptions(discoveryCriteria: criteria)
        
        GCKCastContext.setSharedInstanceWith(options)
        GCKLogger.sharedInstance().delegate = self
        
        LocalServer.startServer()
        
        return true
    }

    func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
        print("Cast Log: \(level) - \(message) [\(function) - \(location)]")
    }
}
