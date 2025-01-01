//
//  MediaItem.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/31/24.
//


struct GooglePhoto: Codable {
    let id: String
    let baseUrl: String
    let mimeType: String?
}

struct GooglePhotosResponse: Codable {
    let photos: [GooglePhoto]?
    let nextPageToken: String?
    
    enum CodingKeys: String, CodingKey {
        case photos = "mediaItems"
        case nextPageToken
    }
}
