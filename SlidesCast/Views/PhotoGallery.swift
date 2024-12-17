//
//  PhotoGallery.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 6/9/24.
//

import SwiftUI

struct PhotoGallery: View {
    @ObservedObject var viewModel = PhotoLibrary()
    @State private var showingDetail = false
    @State private var isSelectionMode = false

    @State private var selectedImage: ImageDetails? = nil
    @State private var selectedImages = [ImageDetails]()

    var body: some View {
        NavigationView {
            VStack {
                // Selection mode controls
                if isSelectionMode {
                    HStack {
                        Button("Cancel") {
                            isSelectionMode = false
                            selectedImages.removeAll()
                        }
                        .foregroundColor(.red)
                        Spacer()
                        Button("Confirm") {
                            print("Selected Images: \(selectedImages)")
                            isSelectionMode = false
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                }

                // Grid of images
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(viewModel.imgDetails) { imgDetails in
                            GalleryImage(
                                imageDetails: imgDetails,
                                isSelected: selectedImages.contains(imgDetails),
                                isSelectionMode: isSelectionMode,
                                onToggleSelection: {
                                    isSelectionMode = true
                                    toggleSelection(for: imgDetails)
                                },
                                onQuickTap: {
                                    selectedImage = imgDetails
                                    showingDetail = true
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Photo Gallery")
            .onAppear {
                viewModel.loadPhotos()
            }
            .sheet(isPresented: Binding(
                get: { showingDetail },
                set: { showingDetail = $0 }
            )) {
                if let selectedImage = selectedImage {
                    PhotoOverlay(isShowing: $showingDetail, imgDetails: selectedImage)
                }
            }
        }
    }

    private func toggleSelection(for img: ImageDetails) {
        if let index = selectedImages.firstIndex(where: { $0 == img }) {
            selectedImages.remove(at: index)
        } else {
            selectedImages.append(img)
        }
    }
}
