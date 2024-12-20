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
        guard let session = session, !CastManager.isCastingImage(session: session, filename: filename) else {
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
        
        let metadata = GCKMediaMetadata(metadataType: .photo)
        
        metadata.setString(filename, forKey: kGCKMetadataKeyTitle)
        metadata.setString("Image being casted by SlidesCast", forKey: kGCKMetadataKeySubtitle)
        
        let mediaInfoBuilder = GCKMediaInformationBuilder(contentURL: photoURL)
        mediaInfoBuilder.streamType = .none
        mediaInfoBuilder.contentType = "image/jpeg"
        mediaInfoBuilder.metadata = metadata
        
        let mediaInformation = mediaInfoBuilder.build()
        
        session.remoteMediaClient?.loadMedia(mediaInformation)
    }
    
    private static func isCastingImage(session: GCKSession, filename: String) -> Bool {
        let title = session.remoteMediaClient?.mediaStatus?.mediaInformation?.metadata?.string(forKey: kGCKMetadataKeyTitle)
        
        return title == filename
    }
}

class CastLogger: NSObject, GCKLoggerDelegate {
    func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
        print("Cast Log: \(level) - \(message) [\(function) - \(location)]")
    }
}
