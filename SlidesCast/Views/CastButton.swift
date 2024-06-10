//
//  CastButton.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 6/8/24.
//

import SwiftUI
import GoogleCast

struct CastButton: UIViewRepresentable {
    public let button = GCKUICastButton(frame: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))

    func makeUIView(context: Context) -> GCKUICastButton {
        return button
    }

    func updateUIView(_ uiView: GCKUICastButton, context: Context) {
        // Update the view if needed (e.g., based on changes in SwiftUI state)
    }
}

#Preview {
    CastButton()
}
