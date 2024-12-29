//
//  PhotoLibraryManager.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 6/9/24.
//

import Photos
import UIKit

class PhotoLibraryManager: ObservableObject {
    @Published var imgDetails: [ImageDetails] = []

    func loadPhotos() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    self.fetchPhotos()
                }
            }
        } else if status == .authorized {
            self.fetchPhotos()
        }
    }

    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        assets.enumerateObjects { (asset, _, _) in
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 200, height: 200) // Example size
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
                if let image = image {
                    DispatchQueue.main.async {
                        let imgDetails = ImageDetails(image: image, name: asset.originalFilename)
                        self.imgDetails.append(imgDetails)
                    }
                }
            }
        }
    }
}

extension PHAsset {
    var originalFilename: String? {
        return PHAssetResource.assetResources(for: self).first?.originalFilename
    }
}
