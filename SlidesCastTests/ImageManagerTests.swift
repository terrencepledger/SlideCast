//
//  ImageManagerTests.swift
//  SlideCastTests
//
//  Created by Terrence Pledger on 6/8/24.
//

import XCTest
@testable import SlidesCast

final class ImageManagerTests: XCTestCase {
    var imageDetails: ImageDetails!
    var mockFileManager: MockFileManager!
    
    override func setUp() {
        super.setUp()
        
        let testImage = UIImage(systemName: "star")! // Replace with an actual test image as needed
        imageDetails = ImageDetails(image: testImage, name: "testImage.jpg")
        
        // Initialize the mock FileManager
        mockFileManager = MockFileManager()
        
        ImageManager.setFileManager(to: mockFileManager) // Inject custom FileManager
    }
    
    override func tearDown() {
        super.tearDown()
        
        ImageManager.clearTempImageDirectory() // Clean up any created files
    }
    
    func testSaveImageToTempDirectory_FailureToCreateDirectory() async {
        // Given a mock FileManager that simulates a failure when creating directories
        mockFileManager.shouldFailToCreateDirectory = true
        
        // When trying to save the image
        let result = await ImageManager.saveImageToTempDirectory(imageDetails: imageDetails)
        
        // Then it should return false because the directory creation failed
        XCTAssertFalse(result, "The image should not be saved if the directory creation fails.")
    }
    
    func testSaveImageToTempDirectory_FailureToCreateFile() async {
        // Given a mock FileManager that simulates a failure when creating the file
        mockFileManager.shouldFailToCreateFile = true
        
        // When trying to save the image
        let result = await ImageManager.saveImageToTempDirectory(imageDetails: imageDetails)
        
        // Then it should return false because the file creation failed
        XCTAssertFalse(result, "The image should not be saved if the file creation fails.")
    }
    
    func testSaveImageToTempDirectory_FileAlreadyExists() async {
        // Given a mock FileManager that simulates the file already existing
        mockFileManager.shouldFileExist = true
        
        // When trying to save the image
        let result = await ImageManager.saveImageToTempDirectory(imageDetails: imageDetails)
        
        // Then it should return true because the file already exists
        XCTAssertTrue(result, "The image should not be saved again if it already exists.")
    }
}


