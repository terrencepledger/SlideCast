//
//  CastButton.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 6/8/24.
//

import SwiftUI
import GoogleCast

struct CastButton: UIViewRepresentable {
    func makeUIView(context: Context) -> GCKUICastButton {
        let castButton = GCKUICastButton(frame: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
        castButton.tintColor = UIColor.gray
        castButton.delegate = CastButtonDelegate()
        return castButton
    }

    func updateUIView(_ uiView: GCKUICastButton, context: Context) {
        // Update the view if needed (e.g., based on changes in SwiftUI state)
    }
}

class CastButtonDelegate: NSObject, GCKUICastButtonDelegate {
    
}

#Preview {
    CastButton()
}
