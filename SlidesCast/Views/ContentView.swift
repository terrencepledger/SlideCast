//
//  ContentView.swift
//  SlideCast
//
//  Created by Terrence Pledger on 6/8/24.
//

import SwiftUI
import SwiftData
import GoogleCast

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    let castButton = CastButton()

    var body: some View {
        NavigationView {
            ZStack {
                PhotoGalleryView()
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: GoogleAlbumsView()) {
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding()
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding()
                        .accessibilityLabel("Open Google Albums")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    castButton
                        .onAppear {
                            GCKCastContext.sharedInstance()
                                .presentCastInstructionsViewControllerOnce(with: castButton.button)
                        }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
