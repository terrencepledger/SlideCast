//
//  PhotoGalleryView.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 6/9/24.
//

import SwiftUI

struct PhotoGalleryView: View {
   @ObservedObject var viewModel = PhotoLibraryVM()

   var body: some View {
       NavigationView {
           ScrollView {
               LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                   ForEach(viewModel.images, id: \.self) { img in
                       Image(uiImage: img)
                           .resizable()
                           .scaledToFit()
                           .padding(2)
                   }
               }
           }
           .navigationTitle("Photo Gallery")
           .onAppear {
               viewModel.loadPhotos()
           }
       }
   }
}
