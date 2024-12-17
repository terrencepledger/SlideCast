//
//  PhotoGallery.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 6/9/24.
//

import SwiftUI

struct PhotoGallery: View {
    @ObservedObject var viewModel = PhotoLibrary()
    @State private var showingPhoto = false
    @State private var showingSlideshow = false
    @State private var isSelectionMode = false

    @State private var selectedImage: ImageDetails? = nil
    @State private var selectedImages = [ImageDetails]()

    var body: some View {
        NavigationView {
            ZStack {
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
                                        showingPhoto = true
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
                    get: { showingPhoto },
                    set: { showingPhoto = $0 }
                )) {
                    if let selectedImage = selectedImage {
                        PhotoOverlay(isShowing: $showingPhoto, imgDetails: selectedImage)
                    }
                }
                .sheet(isPresented: Binding(
                    get: { showingSlideshow },
                    set: { showingSlideshow = $0 }
                )) {
                    SlideshowOverlay(isShowing: $showingSlideshow, allImageDetails: selectedImages)
                }
                
                // Create & Show Slideshow Button
                if !isSelectionMode && !selectedImages.isEmpty {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                showingSlideshow = true
                            }) {
                                Text("Create Slideshow (\(selectedImages.count))")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            .padding()
                        }
                    }
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
