//
//  SlideshowOverlayViewModel.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/28/24.
//


import SwiftUI
import Combine

class SlideshowViewModel: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var isPlaying: Bool = true
    @Published var slideshowDuration: TimeInterval = 5.0
    @Published var isLooping: Bool = false
    @Published var allImageDetails: [ImageDetails]
    
    private var timer: AnyCancellable?
    
    let durationOptions: [TimeInterval] = [3.0, 5.0, 10.0, 15.0]

    init(images: [ImageDetails]) {
        self.allImageDetails = images
    }

    func startSlideshow() {
        isPlaying = true
        timer = Timer.publish(every: slideshowDuration, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.showNext()
            }
    }

    func stopSlideshow() {
        timer?.cancel()
        timer = nil
        isPlaying = false
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

    func shuffleSlides() {
        allImageDetails.shuffle()
        currentIndex = 0
        resetTimer()
        sendImage()
    }

    func resetTimer() {
        if isPlaying {
            stopSlideshow()
            startSlideshow()
        }
    }

    private func sendImage() {
        Task {
            let currentImage = allImageDetails[currentIndex]
            if CastManager.isCasting, await ImageDirectoryManager.saveImage(currentImage) {
                CastManager.castPhoto(filename: currentImage.filename)
            }
        }
    }
}
