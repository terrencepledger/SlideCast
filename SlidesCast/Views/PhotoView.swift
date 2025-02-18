//
//  PhotoOverlay.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 6/9/24.
//

import Foundation
import SwiftUI

struct PhotoView: View {
    @Binding var isShowing: Bool
    var imgDetails: ImageDetails

    var body: some View {
       VStack {
           Image(uiImage: imgDetails.image)
               .resizable()
               .scaledToFit()
           Button("Close") {
               HapticsManager.impact(style: .light)
               isShowing = false
           }
           .padding()
       } .onAppear {
           sendImage()
       }
    }
    
    func sendImage() {
        Task {
            if CastManager.isCasting, await ImageDirectoryManager.saveImage(imgDetails) {
                CastManager.castPhoto(filename: imgDetails.filename)
            }
        }
    }
}
