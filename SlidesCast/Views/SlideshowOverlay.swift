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
    @State private var slideshowDuration: TimeInterval = 5.0
    @State private var isLooping: Bool = false
    
    @State var allImageDetails: [ImageDetails]
    let durationOptions: [TimeInterval] = [3.0, 5.0, 10.0, 15.0]
    
    var body: some View {
        VStack {
            if !allImageDetails.isEmpty {
                Image(uiImage: allImageDetails[currentIndex].image)
                    .resizable()
                    .scaledToFit()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: currentIndex)
                    .onChange(of: currentIndex) {
                        resetTimer()
                    }
            } else {
                Text("No images available for slideshow.")
            }
            
            HStack {
                Text("Slide Duration:")
                Picker("Slide Duration", selection: $slideshowDuration) {
                    ForEach(durationOptions, id: \.self) { duration in
                        Text("\(Int(duration)) seconds").tag(duration)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: slideshowDuration) {
                    resetTimer()
                }
            }
            
            HStack {
                Button("Previous") {
                    showPrevious()
                }
                .disabled(!isLooping && currentIndex == 0)
                .padding()
                
                Button(isPlaying ? "Pause" : "Play") {
                    togglePlayPause()
                }
                .padding()
                
                Button("Next") {
                    showNext()
                }
                .disabled(!isLooping && currentIndex == allImageDetails.count - 1)
                .padding()
            }
            
            HStack {
                Button(action: {
                    shuffleSlides()
                }) {
                    Image(systemName: "shuffle")
                        .font(.title2)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding()
                
                Button("Close") {
                    stopSlideshow()
                    isShowing = false
                }
                .foregroundColor(.red)
                .padding()
                
                Toggle("Loop", isOn: $isLooping)
                    .toggleStyle(SwitchToggleStyle())
                    .onChange(of: isLooping) {
                        if isLooping, currentIndex == allImageDetails.count - 1 {
                            resetTimer()
                        }
                    }
                    .fixedSize()
            }
        }
        .onAppear {
            sendImage()
            startSlideshow()
        }
        .onDisappear {
            stopSlideshow()
        }
    }
    
    func startSlideshow() {
        guard isPlaying else { return }
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
        if currentIndex < allImageDetails.count - 1 {
            currentIndex += 1
        } else if isLooping {
            currentIndex = 0
        } else {
            stopSlideshow()
        }
        sendImage()
    }
    
    func showPrevious() {
        if currentIndex > 0 {
            currentIndex -= 1
        } else if isLooping {
            currentIndex = allImageDetails.count - 1
        }
        sendImage()
    }
    
    // Reset timer
    func resetTimer() {
        if isPlaying {
            stopSlideshow()
            startSlideshow()
        }
    }
    
    func shuffleSlides() {
        allImageDetails.shuffle()
        currentIndex = 0
        resetTimer()
    }
    
    func sendImage() {
        Task {
            let currentImage = allImageDetails[currentIndex]
            
            if CastManager.isCasting, await ImageManager.saveImageToTempDirectory(imageDetails: currentImage) {
                CastManager.castPhoto(filename: currentImage.filename)
            }
        }
    }
}
