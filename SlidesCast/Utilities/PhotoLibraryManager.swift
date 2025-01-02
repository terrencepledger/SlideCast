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
            Task {
                self.fetchPhotos()
            }
        }
    }

    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        assets.enumerateObjects { (asset, _, _) in
            let imageManager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImageDataAndOrientation(for: asset, options: options) { data,_,_,_ in
                if let data = data, let image = UIImage(data: data) {
                    let filename = PHAssetResource.assetResources(for: asset).first?.originalFilename ?? "Unknown Name \(self.imgDetails.count)"
                    DispatchQueue.main.async {
                        let imgDetails = ImageDetails(image: image, name: filename)
                        self.imgDetails.append(imgDetails)
                    }
                }
            }
        }
    }
}
