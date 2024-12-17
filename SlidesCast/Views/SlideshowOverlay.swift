//
//  SlideshowOverlay.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/17/24.
//

import Foundation
import SwiftUI

struct SlideshowOverlay: View {
    @Binding var isShowing: Bool
    
    @State private var currentIndex: Int = 0
    @State private var isPlaying: Bool = true
    @State private var timer: Timer? = nil
    @State private var slideshowDuration: TimeInterval = 5.0 // Time for each slide (in seconds)
    
    var allImageDetails: [ImageDetails] // List of images for the slideshow
    
    var body: some View {
        VStack {
            if !allImageDetails.isEmpty {
                Image(uiImage: allImageDetails[currentIndex].image)
                    .resizable()
                    .scaledToFit()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: currentIndex)
            } else {
                Text("No images available for slideshow.")
            }

            HStack {
                Button("Previous") {
                    showPrevious()
                }
                .disabled(currentIndex == 0)
                .padding()

                Button(isPlaying ? "Pause" : "Play") {
                    togglePlayPause()
                }
                .padding()

                Button("Next") {
                    showNext()
                }
                .disabled(currentIndex == allImageDetails.count - 1)
                .padding()
            }
            .padding()

            Button("Close") {
                stopSlideshow()
                isShowing = false
            }
            .padding()
        }
        .onAppear {
            startSlideshow()
        }
        .onDisappear {
            stopSlideshow()
        }
    }
    
    // MARK: - Slideshow Controls
    func startSlideshow() {
        guard isPlaying else { return }
        saveCurrentImageToTempDirectory()
        timer = Timer.scheduledTimer(withTimeInterval: slideshowDuration, repeats: true) { _ in
            showNext()
        }
    }
    
    func stopSlideshow() {
        timer?.invalidate()
        timer = nil
    }
    
    func togglePlayPause() {
        isPlaying.toggle()
        if isPlaying {
            startSlideshow()
        } else {
            stopSlideshow()
        }
    }
    
    func showNext() {
        guard currentIndex < allImageDetails.count - 1 else {
            stopSlideshow() // End slideshow if at the last image
            return
        }
        
        currentIndex += 1
        saveCurrentImageToTempDirectory()
    }
    
    func showPrevious() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        saveCurrentImageToTempDirectory()
    }

    // Save the current image to the temp directory and cast
    func saveCurrentImageToTempDirectory() {
        let tempDirectory = FileManager.default.temporaryDirectory
        let imagesDirectory = tempDirectory.appendingPathComponent("images")
        let currentImageDetails = allImageDetails[currentIndex]
        
        if let imageData = currentImageDetails.image.jpegData(compressionQuality: 1.0) {
            let imagePath = imagesDirectory.appendingPathComponent(currentImageDetails.filename)
            do {
                try FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true, attributes: nil)
                FileManager.default.createFile(atPath: imagePath.path(), contents: imageData)
                if CastManager.isCasting {
                    CastManager.castPhoto(filename: currentImageDetails.filename)
                }
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }
}
