//
//  Item.swift
//  SlideCast
//
//  Created by Terrence Pledger on 6/8/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
