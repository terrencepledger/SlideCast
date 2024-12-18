//
//  GalleryImage.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/17/24.
//

import SwiftUI

struct GalleryImage: View {
    let imageDetails: ImageDetails
    let isSelected: Bool
    let isSelectionMode: Bool
    let onToggleSelection: () -> Void
    let onQuickTap: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Image display
            Image(uiImage: imageDetails.image)
                .resizable()
                .scaledToFit()
                .padding(2)
                .overlay(
                    Rectangle()
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                )
                .gesture(
                    LongPressGesture(minimumDuration: 0.3)
                        .onEnded { _ in
                            if !isSelectionMode {
                                onToggleSelection()
                            }
                        }
                )
                .gesture(
                    TapGesture()
                        .onEnded {
                            if isSelectionMode {
                                onToggleSelection()
                            } else {
                                onQuickTap()
                            }
                        }
                )

            // Custom Checkmark overlay (visible only in selection mode)
            if isSelectionMode {
                GalleryCheckmark(isChecked: isSelected)
                    .padding(4)
            }
        }
    }
}
