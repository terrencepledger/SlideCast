//
//  AppearanceMode.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 1/3/25.
//

enum AppearanceMode: String, CaseIterable, Identifiable {
    case systemDefault = "System Default", light = "Light Mode", dark = "Dark Mode"
    
    var id: Self { self }
}
