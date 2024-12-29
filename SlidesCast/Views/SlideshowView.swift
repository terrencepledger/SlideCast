//
//  SlideshowOverlay.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/17/24.
//

import Foundation
import SwiftUI

struct SlideshowView: View {
    @Binding var isShowing: Bool
    @StateObject var viewModel: SlideshowViewModel
    
    var body: some View {
        VStack {
            if !viewModel.allImageDetails.isEmpty {
                Image(uiImage: viewModel.allImageDetails[viewModel.currentIndex].image)
                    .resizable()
                    .scaledToFit()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: viewModel.currentIndex)
            } else {
                Text("No images available for slideshow.")
            }
            
            HStack {
                Text("Slide Duration:")
                
                Picker("Slide Duration", selection: $viewModel.slideshowDuration) {
                    ForEach(viewModel.durationOptions, id: \.self) { duration in
                        Text("\(Int(duration)) seconds").tag(duration)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: viewModel.slideshowDuration) {
                    viewModel.resetTimer()
                }
            }
            
            HStack {
                Button("Previous") {
                    viewModel.showPrevious()
                }
                .disabled(!viewModel.isLooping && viewModel.currentIndex == 0)
                .padding()
                
                Button(viewModel.isPlaying ? "Pause" : "Play") {
                    viewModel.togglePlayPause()
                }
                .padding()
                
                Button("Next") {
                    viewModel.showNext()
                }
                .disabled(!viewModel.isLooping && viewModel.currentIndex == viewModel.allImageDetails.count - 1)
                .padding()
            }
            
            HStack {
                Button(action: {
                    viewModel.shuffleSlides()
                }) {
                    Image(systemName: "shuffle")
                        .font(.title2)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding()
                
                Button("Close") {
                    viewModel.stopSlideshow()
                    isShowing = false
                }
                .foregroundColor(.red)
                .padding()
                
                Toggle("Loop", isOn: $viewModel.isLooping)
                    .toggleStyle(SwitchToggleStyle())
                    .fixedSize()
            }
        }
        .onAppear {
            viewModel.startSlideshow()
        }
        .onDisappear {
            viewModel.stopSlideshow()
        }
    }
}
