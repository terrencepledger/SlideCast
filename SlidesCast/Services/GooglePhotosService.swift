//
//  GooglePhotosService.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/30/24.
//


import Foundation

struct GooglePhotosService {
    private static let baseURL = "https://photoslibrary.googleapis.com/v1"
    
    /// Fetches the user's albums from Google Photos asynchronously.
    /// - Parameter accessToken: OAuth 2.0 access token.
    /// - Returns: An array of `GoogleAlbum` or throws an error.
    static func fetchAlbums(accessToken: String) async throws(GooglePhotosServiceError) -> [GoogleAlbum]? {
        guard let url = URL(string: "\(baseURL)/albums") else {
            throw GooglePhotosServiceError.invalidURLError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw GooglePhotosServiceError.serverError
            }
            
            let albumsResponse = try JSONDecoder().decode(GoogleAlbumsResponse.self, from: data)
            return albumsResponse.albums
        } catch {
            throw GooglePhotosServiceError.serverError
        }
    }
    
    static func fetchImages(from albumId: String, accessToken: String) async throws(GooglePhotosServiceError) -> [GooglePhoto] {
        guard let url = URL(string: "\(baseURL)/mediaItems:search") else {
            throw GooglePhotosServiceError.invalidURLError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "albumId": albumId,
            "pageSize": 50 // Adjust as needed
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            
            let (data, response) = try await URLSession.shared.data(for: request)
//            print(String(data: data, encoding: .utf8))
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NSError(domain: "HTTPError", code: (response as? HTTPURLResponse)?.statusCode ?? 0, userInfo: nil)
            }
            
            let photosResponse = try JSONDecoder().decode(GooglePhotosResponse.self, from: data)
            return photosResponse.photos ?? []
        } catch {
            throw GooglePhotosServiceError.serverError
        }
    }
}
