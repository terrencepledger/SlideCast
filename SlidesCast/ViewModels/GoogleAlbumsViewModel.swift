//
//  GoogleAlbumsViewModel.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/30/24.
//

import SwiftUI

@MainActor
class GoogleAlbumViewModel: ObservableObject {
    @Published var error: GoogleAlbumServiceError?
    @Published var albums: [GoogleAlbum] = []

    func loadAlbums() async {
        do {
            guard let accessToken = GoogleSignInService.getAccessToken() else {
                self.error = GoogleAlbumServiceError.accessTokenError
                return
            }
            self.albums = try await GooglePhotosService.fetchAlbums(accessToken: accessToken)
        } catch {
            self.error = error
        }
    }
}
