//
//  PhotoGalleryViewModel.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/28/24.
//

import Foundation

class PhotoGalleryViewModel: ObservableObject {
    @Published var imgDetails: [ImageDetails] = []
    @Published var selectedImages: [ImageDetails] = []
    @Published var isSelectionMode: Bool = false
    @Published var isAllSelected: Bool = false
    
    private let photoLibraryManager: PhotoLibraryManager
    
    init(photoLibraryManager: PhotoLibraryManager = PhotoLibraryManager()) {
        self.photoLibraryManager = photoLibraryManager
        self.photoLibraryManager.$imgDetails.assign(to: &$imgDetails)
    }
    
    func loadPhotos() {
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
}
