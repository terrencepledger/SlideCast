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
    var image: UIImage
    @Binding var isShowing: Bool

    var body: some View {
       VStack {
           Image(uiImage: image)
               .resizable()
               .scaledToFit()
           Button("Close") {
               isShowing = false
           }
           .padding()
       } .onAppear {
           if let session = GCKCastContext.sharedInstance().sessionManager.currentSession, session.connectionState == .connected {
               if let imageData = image.pngData() {
                   let base64String = imageData.base64EncodedString()
                   let dataUrl = "data:image/png;base64,\(base64String)"
                   castPhoto(photoURL: dataUrl)
              }
           }
       }
    }

    func castPhoto(photoURL: String) {
        guard let session = GCKCastContext.sharedInstance().sessionManager.currentSession else {
            print("No Cast session is currently established.")
            return
        }
        
        // Create a GCKMediaMetadata object
        let metadata = GCKMediaMetadata(metadataType: .photo)

        // Add metadata (optional, but recommended for a better user experience)
        metadata.setString("Image Title", forKey: kGCKMetadataKeyTitle)
        metadata.setString("A description of the image", forKey: kGCKMetadataKeySubtitle)

        // Use the builder pattern
        let mediaInfoBuilder = GCKMediaInformationBuilder(contentURL: URL(string: photoURL)!)
        mediaInfoBuilder.streamType = .none // For images, use .none
        mediaInfoBuilder.contentType = "image/jpeg" // Adjust based on your image's format
        mediaInfoBuilder.metadata = metadata

        // Finally, build the GCKMediaInformation object
        let mediaInformation = mediaInfoBuilder.build()
        
        session.remoteMediaClient?.loadMedia(mediaInformation)
    }
}
