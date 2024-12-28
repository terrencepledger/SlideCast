//
//  LocalServer.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/16/24.
//

import GCDWebServer
import Foundation

class LocalServer {
    public static var isRunning: Bool {
        sharedServer?.webServer.isRunning == true
    }
    private static var sharedServer: LocalServer?

    private var webServer: GCDWebServer
    private var fileManager: FileManager = .default

    public static func startServer() {
        if sharedServer == nil {
            sharedServer = LocalServer()
        }
    }
    
    public static func stopServer() {
        sharedServer?.webServer.stop()
        sharedServer = nil
        print("Server stopped.")
    }
    
    public static func setFileManager(to fileManager: FileManager) {
        sharedServer?.fileManager = fileManager
    }
    
    public static func getAddress() -> String? {
        guard let server = sharedServer else {
            print("No server instance when attempting to retrieve address.")
            return nil
        }
        return server.webServer.serverURL?.absoluteString
    }

    private init() {
        self.webServer = GCDWebServer()
        configureServer()
        start()
    }
    
    private func configureServer() {
        let tempDirectory = fileManager.temporaryDirectory.appendingPathComponent("images")
        
        webServer.addGETHandler(
            forBasePath: "/",
            directoryPath: tempDirectory.path,
            indexFilename: nil,
            cacheAge: 60,
            allowRangeRequests: true
        )
    }
    
    private func start() {
        if webServer.isRunning {
            print("Server is already running on port \(webServer.port). Restarting...")
            webServer.stop()
        }
        
        do {
            try webServer.start(options: [GCDWebServerOption_Port: 8080, "AutomaticallySuspendInBackground" : false])
        } catch {
            print("Failed to start server: \(error)")
        }
    }
}
