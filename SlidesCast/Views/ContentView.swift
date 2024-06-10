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
            PhotoGalleryView()
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
