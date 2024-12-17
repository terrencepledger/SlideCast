//
//  ImageDetails.swift
//  SlidesCast
//
//  Created by Terrence Pledger on 12/17/24.
//

import Foundation
import UIKit

struct ImageDetails: Identifiable, Equatable {
    let id = UUID()
    
    public let image: UIImage
    public let name: String?
    
    public var filename: String {
        name ?? id.uuidString
    }
}
