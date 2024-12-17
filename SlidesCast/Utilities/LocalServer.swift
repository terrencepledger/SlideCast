//
//  LocalServer.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/16/24.
//

import GCDWebServer
import Foundation

class LocalServer {
    private static var sharedServer: LocalServer?
    private var webServer: GCDWebServer

    // Start the server if it isn't already running
    public static func startServer() {
        if sharedServer == nil {
            sharedServer = LocalServer()
        }
    }

    // Stop the server
    public static func stopServer() {
        sharedServer?.webServer.stop()
        sharedServer = nil
        print("Server stopped.")
    }

    // Get the server address
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

    // Configure and serve the temporary image directory
    private func configureServer() {
        let tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent("images")
        
        // Ensure the directory exists
        if !FileManager.default.fileExists(atPath: tempDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
                print("Created temporary image directory at: \(tempDirectory.path)")
            } catch {
                print("Error creating temporary image directory: \(error)")
                return
            }
        }
        
        // Add GET handler to serve files from the directory
        webServer.addGETHandler(
            forBasePath: "/",
            directoryPath: tempDirectory.path,
            indexFilename: nil,
            cacheAge: 60,
            allowRangeRequests: true
        )
    }

    // Start the server
    private func start() {
        if webServer.isRunning {
            print("Server is already running on port \(webServer.port). Restarting...")
            webServer.stop()
        }
        
        do {
            try webServer.start(options: [GCDWebServerOption_Port: 8080])
        } catch {
            print("Failed to start server: \(error)")
        }
    }
}
