//
//  LoadingManager.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 1/1/25.
//

import SwiftUI

class GlobalLoadingManager: ObservableObject {
    @Published var isLoading: Bool = false
    var message: String? = nil
    
    static let shared = GlobalLoadingManager()
}

struct GlobalLoadingModifier: ViewModifier {
    @StateObject private var loadingManager = GlobalLoadingManager.shared
    
    func body(content: Content) -> some View {
        ZStack {
            content

            if loadingManager.isLoading {
                ZStack {
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)

                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))

                        if let message = loadingManager.message {
                            Text(message)
                                .foregroundColor(.white)
                                .font(.body)
                        }
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut, value: loadingManager.isLoading)
            }
        }
    }
}
