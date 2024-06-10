//
//  ContentView.swift
//  SlideCast
//
//  Created by Terrence Pledger on 6/8/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            PhotoGalleryView()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CastButton()
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
