//
//  DataModels.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/30/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation

struct StreamModel<T: Codable>: Codable, Identifiable {
    let id: UUID
    var name: String
    var description: String?
    var stream: [StreamItem<T>]
    var isDefault: Bool = false
    
    static func new<T>() -> StreamModel<T> {
        StreamModel<T>(id: UUID(), name: "Default Stream", description: nil, stream: [])
    }
}

struct StreamItem<T: Codable>: Codable {
    let value: T
    var operatorItem: OperatorItem? = nil
}

enum OperatorType: String, Codable {
    case delay
    case filter
}

class OperatorItem: Codable {
    let type: OperatorType
    let value: Double?
    let next: OperatorItem?
    
    init(type: OperatorType, value: Double? = nil, next: OperatorItem? = nil) {
        self.type = type
        self.value = value
        self.next = next
    }
    
}
