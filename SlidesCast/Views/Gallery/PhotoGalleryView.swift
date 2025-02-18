//
//  PhotoGalleryView.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 6/9/24.
//

import SwiftUI

struct PhotoGalleryView: View {
    @StateObject private var viewModel = PhotoGalleryViewModel()
    
    @State private var showingPhoto = false
    @State private var showingSlideshow = false
    @State private var selectedImage: ImageDetails? = nil
    
    @State var album: GoogleAlbum? = nil
    
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isSelectionMode {
                    HStack {
                        Button("Cancel") {
                            viewModel.isSelectionMode = false
                            viewModel.selectedImages.removeAll()
                            viewModel.isAllSelected = false
                            HapticsManager.impact(style: .light)
                        }
                        .foregroundColor(.red)
                        Spacer()
                        Button(viewModel.isAllSelected ? "Deselect All" : "Select All") {
                            viewModel.toggleSelectAll()
                            HapticsManager.impact(style: .light)
                        }
                        .foregroundColor(.blue)
                        Spacer()
                        Button("Confirm (\(viewModel.selectedImages.count))") {
                            viewModel.isSelectionMode = false
                            viewModel.isAllSelected = false
                            HapticsManager.impact(style: .light)
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                }
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(viewModel.imgDetails) { imgDetails in
                            GalleryImage(
                                imageDetails: imgDetails,
                                isSelected: viewModel.selectedImages.contains(imgDetails),
                                isSelectionMode: viewModel.isSelectionMode,
                                onToggleSelection: {
                                    HapticsManager.impact(style: .light)
                                    viewModel.isSelectionMode = true
                                    viewModel.toggleSelection(for: imgDetails)
                                    
                                },
                                onQuickTap: {
                                    HapticsManager.impact(style: .light)
                                    selectedImage = imgDetails
                                    showingPhoto = true
                                }
                            )
                        }
                    }
                }
            }
            .storeToolbar()
            .navigationTitle(album?.title ?? "Photo Gallery")
            .onAppear {
                Task {
                    showLoadingIndicator()
                    await viewModel.loadPhotos(from: album)
                    hideLoadingIndicator()
                }
            }
            .sheet(isPresented: Binding(
                get: { showingPhoto },
                set: { showingPhoto = $0 }
            )) {
                if let selectedImage = selectedImage {
                    PhotoView(isShowing: $showingPhoto, imgDetails: selectedImage)
                }
            }
            .sheet(isPresented: $showingSlideshow) {
                SlideshowView(isShowing: $showingSlideshow, viewModel: SlideshowViewModel(images: viewModel.selectedImages))
            }
            
            if !viewModel.isSelectionMode && !viewModel.selectedImages.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            showingSlideshow = true
                            HapticsManager.impact(style: .light)
                        }) {
                            Text("Create Slideshow (\(viewModel.selectedImages.count))")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding()
                        
                        Spacer()
                    }
                }
            }
        }
    }
}
