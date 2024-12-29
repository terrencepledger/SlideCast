//
//  MockFileManager.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/23/24.
//

import Foundation

class MockFileManager: FileManager {
    var shouldFailToCreateDirectory = false
    var shouldFailToCreateFile = false
    var shouldFileExist = false
    
    override func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        if shouldFailToCreateDirectory {
            throw NSError(domain: "com.slidescast.test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Directory creation failed."])
        } else {
            try super.createDirectory(at: url, withIntermediateDirectories: createIntermediates, attributes: attributes)
        }
    }
    
    override func fileExists(atPath path: String) -> Bool {
        return shouldFileExist
    }
    
    override func createFile(atPath path: String, contents data: Data?, attributes: [FileAttributeKey : Any]? = nil) -> Bool {
        if shouldFailToCreateFile {
            return false // Simulate failure to create file
        }
        return super.createFile(atPath: path, contents: data, attributes: attributes)
    }
}
