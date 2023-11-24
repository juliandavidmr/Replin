//
//  KeyValueItem.swift
//  Replin
//
//  Created by Julian on 23/11/23.
//

import Foundation

struct KeyValueItem: Identifiable {
    let id = UUID()
    let key: String
    let value: String
}
