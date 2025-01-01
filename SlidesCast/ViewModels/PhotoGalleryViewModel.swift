//
//  PhotoGalleryViewModel.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/28/24.
//

import Foundation
import SwiftUI

@MainActor
class PhotoGalleryViewModel: ObservableObject {
    @Published var imgDetails: [ImageDetails] = []
    @Published var selectedImages: [ImageDetails] = []
    @Published var isSelectionMode: Bool = false
    @Published var isAllSelected: Bool = false
    @Published var photosServiceError: GooglePhotosServiceError?
    
    private let photoLibraryManager: PhotoLibraryManager
    
    init(photoLibraryManager: PhotoLibraryManager = PhotoLibraryManager()) {
        self.photoLibraryManager = photoLibraryManager
        self.photoLibraryManager.$imgDetails.assign(to: &$imgDetails)
    }
    
    func loadPhotos(from album: GoogleAlbum? = nil) async {
        if let album = album {
            await loadGoogleAlbumPhotos(album)
            return
        }
        photoLibraryManager.loadPhotos()
    }
    
    func toggleSelection(for img: ImageDetails) {
        if let index = selectedImages.firstIndex(of: img) {
            selectedImages.remove(at: index)
        } else {
            selectedImages.append(img)
        }
        updateSelectAllState()
    }
    
    func toggleSelectAll() {
        if isAllSelected {
            selectedImages.removeAll()
        } else {
            selectedImages = imgDetails
        }
        isAllSelected.toggle()
    }
    
    private func updateSelectAllState() {
        isAllSelected = selectedImages.count == imgDetails.count
    }
    
    private func loadGoogleAlbumPhotos(_ album: GoogleAlbum) async {
        do {
            guard let accessToken = GoogleSignInService.getAccessToken() else {
                self.photosServiceError = GooglePhotosServiceError.accessTokenError
                return
            }
            
            let photos = try await GooglePhotosService.fetchImages(from: album.id, accessToken: accessToken)
            for photo in photos {
                await downloadImage(from: photo)
            }
        } catch {
            self.photosServiceError = error
        }
    }
    
    private func downloadImage(from photo: GooglePhoto) async {
        guard let photoURL = URL(string: photo.baseUrl) else {
            print("URL Error")
            return
        }
        
        if let (data, response) = try? await URLSession.shared.data(from: photoURL) {
            if let img = UIImage(data: data) {
                print(response)
                let details = ImageDetails(image: img, name: photo.id)
                imgDetails.append(details)
            } else {
                print("creating ui image failed")
            }
        } else {
            print("decoding failed")
        }
    }
}
