//
//  PhotoGalleryView.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 6/9/24.
//

import SwiftUI

struct PhotoGalleryView: View {
    @ObservedObject var viewModel = PhotoLibraryVM()
    @State private var showingDetail = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(viewModel.images.indices, id: \.self) { index in
                        let img = viewModel.images[index]
                        Button(action: {
                            self.selectedImage = img
                            self.showingDetail = true
                        }) {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFit()
                                .padding(2)
                        }
                    }
                }
            }
            .navigationTitle("Photo Gallery")
            .onAppear {
                viewModel.loadPhotos()
            }
            .overlay(
                Group {
                    if showingDetail {
                        Color.black.opacity(0.75)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                self.showingDetail = false
                            }
                    }
                } .onTapGesture {
                    self.showingDetail = false
                }
            )
            .overlay(
                Group {
                    if showingDetail, let selectedImage = selectedImage {
                        PhotoDetailView(image: selectedImage, isShowing: $showingDetail)
                            .frame(width: 300, height: 450)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            .transition(.scale)
                    }
                }, alignment: .center
            )
        }
    }
}
