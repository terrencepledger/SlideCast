//
//  GooglePhotosService.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/30/24.
//


import Foundation

struct GoogleAlbumsResponse: Decodable {
    let albums: [GoogleAlbum]
}

class GooglePhotosService {
    private let baseURL = "https://photoslibrary.googleapis.com/v1"

    /// Fetches the user's albums from Google Photos asynchronously.
    /// - Parameter accessToken: OAuth 2.0 access token.
    /// - Returns: An array of `GoogleAlbum` or throws an error.
    func fetchAlbums(accessToken: String) async throws -> [GoogleAlbum] {
        let url = URL(string: "\(baseURL)/albums")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // Perform the network request asynchronously
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "HTTPError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)
        }
        
        // Decode the JSON response
        let albumsResponse = try JSONDecoder().decode(GoogleAlbumsResponse.self, from: data)
        return albumsResponse.albums
    }
}
