//
//  PhotoDetailView.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 6/9/24.
//

import Foundation
import SwiftUI

struct PhotoDetailView: View {
   var image: UIImage
   @Binding var isShowing: Bool

   var body: some View {
       VStack {
           Image(uiImage: image)
               .resizable()
               .scaledToFit()
           Button("Close") {
               isShowing = false
           }
           .padding()
       }
   }
}
