//
//  CastManager.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/17/24.
//

import GoogleCast

struct CastManager {
    static var isCasting: Bool {
        GCKCastContext.sharedInstance().sessionManager.currentSession?.connectionState == .connected
    }
    
    static func castPhoto(filename: String) {
        guard let session = GCKCastContext.sharedInstance().sessionManager.currentSession else {
            print("No Cast session is currently established.")
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
        
        session.remoteMediaClient?.loadMedia(mediaInformation)
    }
}
