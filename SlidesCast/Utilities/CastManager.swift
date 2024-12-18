//
//  CastManager.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/17/24.
//

import GoogleCast

struct CastManager {
    private static var logger = CastLogger()
    private static var session: GCKSession? {
        if let session = GCKCastContext.sharedInstance().sessionManager.currentSession {
            return session
        } else {
            print("No Cast session is currently established.")
            return nil
        }
    }
    
    static var isCasting: Bool {
        if let session = session {
            return session.connectionState == .connected
        } else {
            return false
        }
    }
    
    static func setup() {
        let criteria = GCKDiscoveryCriteria(applicationID: kGCKDefaultMediaReceiverApplicationID)
        let options = GCKCastOptions(discoveryCriteria: criteria)
        options.suspendSessionsWhenBackgrounded = false
        
        GCKCastContext.setSharedInstanceWith(options)
        
        GCKLogger.sharedInstance().delegate = logger
    }
    
    static func castPhoto(filename: String) {
        guard let session = session else {
            return
        }
        
        guard let serverURL = LocalServer.getAddress() else {
            print("unable to retrieve local server address")
            return
        }
        
        guard let photoURL = URL(string: serverURL + "/images/" + filename) else {
            print("Failed to create URL")
            return
        }
        
        // Create a GCKMediaMetadata object
        let metadata = GCKMediaMetadata(metadataType: .photo)
        
        // Add metadata (optional, but recommended for a better user experience)
        metadata.setString("Image Title", forKey: kGCKMetadataKeyTitle)
        metadata.setString("A description of the image", forKey: kGCKMetadataKeySubtitle)
        
        // Use the builder pattern
        let mediaInfoBuilder = GCKMediaInformationBuilder(contentURL: photoURL)
        mediaInfoBuilder.streamType = .none // For images, use .none
        mediaInfoBuilder.contentType = "image/jpeg" // Adjust based on your image's format
        mediaInfoBuilder.metadata = metadata
        
        // Finally, build the GCKMediaInformation object
        let mediaInformation = mediaInfoBuilder.build()
        
        Task {
            session.remoteMediaClient?.loadMedia(mediaInformation)
        }
    }
}

class CastLogger: NSObject, GCKLoggerDelegate {
    func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
        print("Cast Log: \(level) - \(message) [\(function) - \(location)]")
    }
}
