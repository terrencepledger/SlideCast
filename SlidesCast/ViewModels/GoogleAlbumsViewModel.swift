//
//  GoogleAlbumsViewModel.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/30/24.
//

import SwiftUI

@MainActor
class GoogleAlbumViewModel: ObservableObject {
    @Published var error: GooglePhotosServiceError?
    @Published var albums: [GoogleAlbum] = []

    func loadAlbums() async {
        do {
            guard let accessToken = GoogleSignInService.getAccessToken() else {
                self.error = GooglePhotosServiceError.accessTokenError
                return
            }
            if let albums = try await GooglePhotosService.fetchAlbums(accessToken: accessToken) {
                self.albums = albums
            }
        } catch {
            HapticsManager.notification(type: .error)
            self.error = error
        }
    }
}
