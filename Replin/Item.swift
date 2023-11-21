//
//  Item.swift
//  Replin
//
//  Created by Julian Creha on 21/11/23.
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
