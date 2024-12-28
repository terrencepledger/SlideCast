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
    var body: some Scene {
        WindowGroup {
            if isProduction {
                ContentView()
                    .onAppear {
                        CastManager.setup()
                        LocalServer.startServer()
                    }
            }
        }
    }
    
    private var isProduction: Bool {
        NSClassFromString("XCTest") == nil
    }
}

