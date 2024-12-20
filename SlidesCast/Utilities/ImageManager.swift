//
//  ImageManager.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/20/24.
//

import Foundation

struct ImageManager {
    private static let tempDirectory = FileManager.default.temporaryDirectory
    private static let imagesDirectory = tempDirectory.appendingPathComponent("images")
    
    // Save the current image to the temp directory and cast
    static func saveImageToTempDirectory(imageDetails: ImageDetails) async -> Bool {
        guard let imageData = imageDetails.image.jpegData(compressionQuality: 1.0) else {
            print("Error retrieving image data")
            return false
        }
        
        let imagePath = imagesDirectory.appendingPathComponent(imageDetails.filename).path()
        if FileManager.default.fileExists(atPath: imagePath) {
            return true
        }
        
        do {
            try FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true, attributes: nil)
            FileManager.default.createFile(atPath: imagePath, contents: imageData)
            print("image saved")
            return true
        } catch {
            print("Error saving image: \(error)")
            return false
        }
    }
}
