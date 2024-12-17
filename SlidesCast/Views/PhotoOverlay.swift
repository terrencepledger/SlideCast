//
//  PhotoOverlay.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 6/9/24.
//

import Foundation
import SwiftUI

struct PhotoOverlay: View {
    @Binding var isShowing: Bool
    var imgDetails: ImageDetails

    var body: some View {
       VStack {
           Image(uiImage: imgDetails.image)
               .resizable()
               .scaledToFit()
           Button("Close") {
               isShowing = false
           }
           .padding()
       } .onAppear {
           saveImageToTempDirectory()
       }
    }
    
    func saveImageToTempDirectory() {
        // Get the path for the Temporary directory
        let tempDirectory = FileManager.default.temporaryDirectory
        let imagesDirectory = tempDirectory.appendingPathComponent("images")
        
        if let imageData = imgDetails.image.jpegData(compressionQuality: 1.0) {
            let imagePath = imagesDirectory.appendingPathComponent(imgDetails.filename)
            
            // Write the image to the Temporary directory
            do {
                try FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true, attributes: nil)
                FileManager.default.createFile(atPath: imagePath.path(), contents: imageData)
                if CastManager.isCasting {
                    CastManager.castPhoto(filename: imgDetails.filename)
                }
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }
}
