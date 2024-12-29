//
//  LocalServerTests.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/28/24.
//


import XCTest
@testable import SlidesCast

final class LocalServerManagerTests: XCTestCase {
    var mockFileManager: MockFileManager!

    override func setUp() {
        super.setUp()
        // Mock FileManager to simulate the behavior of file system
        mockFileManager = MockFileManager()
        
        // Inject the mock file manager into LocalServer (you would need to modify the LocalServer class to allow this)
        LocalServerManager.setFileManager(to: mockFileManager)
    }

    override func tearDown() {
        super.tearDown()
        LocalServerManager.stopServer()
    }

    func testStartServer_createsInstanceAndStartsServer() {
        // Given that the server isn't started yet
        LocalServerManager.startServer()

        // Then the shared server should be initialized and the server should be running
        XCTAssertTrue(LocalServerManager.isRunning)
    }

    func testStopServer_stopsServerAndNilSharedInstance() {
        // Given that the server is running
        LocalServerManager.startServer()

        // When stopping the server
        LocalServerManager.stopServer()

        // Then the server should stop and sharedServer should be nil
        XCTAssertFalse(LocalServerManager.isRunning)
    }

    func testGetAddress_returnsServerAddress() {
        // Given that the server is running
        LocalServerManager.startServer()

        // When getting the address
        let address = LocalServerManager.getAddress()

        // Then it should return the server's address
        guard let address = address else {
            XCTFail("Server address is missing")
            return
        }
        XCTAssertTrue(address.contains("8080"))
    }

    func testGetAddress_returnsNilWhenNoServer() {
        // When getting the address without starting the server
        let address = LocalServerManager.getAddress()

        // Then it should return nil
        XCTAssertNil(address)
    }
}
