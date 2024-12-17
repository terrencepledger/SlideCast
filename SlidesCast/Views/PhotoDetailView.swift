//
//  PhotoDetailView.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 6/9/24.
//

import Foundation
import SwiftUI
import GoogleCast

struct PhotoDetailView: View {
    @Binding var isShowing: Bool
    var scImage: SCImage

    var body: some View {
       VStack {
           Image(uiImage: scImage.image)
               .resizable()
               .scaledToFit()
           Button("Close") {
               isShowing = false
           }
           .padding()
       } .onAppear {
           if let session = GCKCastContext.sharedInstance().sessionManager.currentSession, session.connectionState == .connected {
               saveImageToTempDirectory()
           }
       }
    }

    func castPhoto() {
        guard let session = GCKCastContext.sharedInstance().sessionManager.currentSession else {
            print("No Cast session is currently established.")
            return
        }
        
        guard let serverURL = LocalServer.getAddress() else {
            print("unable to retrieve local server address")
            return
        }
        guard let photoURL = URL(string: serverURL + "/images/" + scImage.filename) else {
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
    
    func saveImageToTempDirectory() {
        // Get the path for the Temporary directory
        let tempDirectory = FileManager.default.temporaryDirectory
        let imagesDirectory = tempDirectory.appendingPathComponent("images")
        
        if let imageData = scImage.image.jpegData(compressionQuality: 1.0) {
            let imagePath = imagesDirectory.appendingPathComponent(scImage.filename)
            
            // Write the image to the Temporary directory
            do {
                try FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true, attributes: nil)
                FileManager.default.createFile(atPath: imagePath.path(), contents: imageData)
                print("Image saved to: \(imagePath)")
                castPhoto()
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }
}
