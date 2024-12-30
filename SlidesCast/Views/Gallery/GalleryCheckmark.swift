//
//  GalleryCheckmark.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/17/24.
//

import SwiftUI

struct GalleryCheckmark: View {
    let isChecked: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(isChecked ? Color.blue : Color.white)
                .frame(width: 24, height: 24)
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))

            if isChecked {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .shadow(radius: 2)
    }
}
