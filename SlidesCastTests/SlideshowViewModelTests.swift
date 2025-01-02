//
//  SlideshowOverlayViewModelTests.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/28/24.
//


import XCTest
@testable import SlidesCast

class SlideshowViewModelTests: XCTestCase {
    func testStartSlideshow() {
        // Given a list of image details
        let images = [ImageDetails(image: UIImage(), name: "Image1"),
                      ImageDetails(image: UIImage(), name: "Image2")]
        let viewModel = SlideshowViewModel(images: images)
        
        // When the slideshow is started
        viewModel.startSlideshow()
        
        // Then the slideshow should be playing
        XCTAssertTrue(viewModel.isPlaying)
    }

    func testStopSlideshow() {
        // Given a list of image details and a playing slideshow
        let images = [ImageDetails(image: UIImage(), name: "Image1")]
        let viewModel = SlideshowViewModel(images: images)
        viewModel.startSlideshow()
        
        // When the slideshow is stopped
        viewModel.stopSlideshow()
        
        // Then the slideshow should not be playing
        XCTAssertFalse(viewModel.isPlaying)
    }

    func testShowNext() {
        // Given a list of image details
        let images = [ImageDetails(image: UIImage(), name: "Image1"),
                      ImageDetails(image: UIImage(), name: "Image2")]
        let viewModel = SlideshowViewModel(images: images)

        // When the next image is shown
        viewModel.showNext()
        
        // Then the current index should be 1
        XCTAssertEqual(viewModel.currentIndex, 1)

        // When the next image is shown again (but there's no next image)
        viewModel.showNext()
        
        // Then the current index should remain at 1, since looping is not enabled
        XCTAssertEqual(viewModel.currentIndex, 1, "Should not advance beyond last image without looping")
    }

    func testShowNextWithLooping() {
        // Given a list of image details and looping enabled
        let images = [ImageDetails(image: UIImage(), name: "Image1"),
                      ImageDetails(image: UIImage(), name: "Image2")]
        let viewModel = SlideshowViewModel(images: images)

        // When the next image is shown twice and looping is enabled
        viewModel.isLooping = true
        viewModel.showNext()
        viewModel.showNext()
        
        // Then the current index should loop back to the first image
        XCTAssertEqual(viewModel.currentIndex, 0, "Should loop back to first image")
    }

    func testShowPrevious() {
        // Given a list of image details and the current index at 1
        let images = [ImageDetails(image: UIImage(), name: "Image1"),
                      ImageDetails(image: UIImage(), name: "Image2")]
        let viewModel = SlideshowViewModel(images: images)
        viewModel.currentIndex = 1
        
        // When the previous image is shown
        viewModel.showPrevious()
        
        // Then the current index should be 0
        XCTAssertEqual(viewModel.currentIndex, 0)
        
        // When the previous image is shown again (but we're already at the first image)
        viewModel.showPrevious()
        
        // Then the current index should remain at 0, since looping is not enabled
        XCTAssertEqual(viewModel.currentIndex, 0, "Should not go below index 0 without looping")
    }

    func testShowPreviousWithLooping() {
        // Given a list of image details and looping enabled
        let images = [ImageDetails(image: UIImage(), name: "Image1"),
                      ImageDetails(image: UIImage(), name: "Image2")]
        let viewModel = SlideshowViewModel(images: images)
        viewModel.isLooping = true
        
        // When the previous image is shown (starting at index 0)
        viewModel.showPrevious()
        
        // Then the current index should loop back to the last image (index 1)
        XCTAssertEqual(viewModel.currentIndex, 1, "Should loop back to last image")
    }

    func testShuffleSlides_Order() {
        // Given a list of image details
        let images = [ImageDetails(image: UIImage(), name: "Image1"),
                      ImageDetails(image: UIImage(), name: "Image2"),
                      ImageDetails(image: UIImage(), name: "Image3"),
                      ImageDetails(image: UIImage(), name: "Image4"),
                      ImageDetails(image: UIImage(), name: "Image5"),
                      ImageDetails(image: UIImage(), name: "Image6")]
        let viewModel = SlideshowViewModel(images: images)
        
        // When the slides are shuffled
        viewModel.shuffleSlides()
        
        // Then the order of image names should no longer match the original order
        XCTAssertNotEqual(viewModel.allImageDetails.map { $0.name }, ["Image1", "Image2", "Image3", "Image4", "Image5", "Image6"], "Images should be shuffled")
    }
    
    func testShuffleSlides_Index() {
        // Given a list of image details
        let images = [ImageDetails(image: UIImage(), name: "Image1"),
                      ImageDetails(image: UIImage(), name: "Image2"),
                      ImageDetails(image: UIImage(), name: "Image3"),
                      ImageDetails(image: UIImage(), name: "Image4"),
                      ImageDetails(image: UIImage(), name: "Image5"),
                      ImageDetails(image: UIImage(), name: "Image6")]
        let viewModel = SlideshowViewModel(images: images)
        
        // When the index is changed
        viewModel.showNext()
        viewModel.showNext()
        
        // When the slides are shuffled
        viewModel.shuffleSlides()
        
        // Then the index is reset to 0
        XCTAssertEqual(viewModel.currentIndex, 0)
    }
}

