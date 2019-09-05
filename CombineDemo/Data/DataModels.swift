//
//  DataModels.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/30/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation

struct StreamModel<T: Codable>: Codable, Identifiable {
    var id: UUID
    var name: String?
    var description: String?
    var stream: [StreamItem<T>]
    var isDefault: Bool
    var operatorItem: OperatorItem?
    
    init(id: UUID = UUID(), name: String? = nil, description: String? = nil, stream: [StreamItem<T>] = [], isDefault: Bool = false, operatorItem: OperatorItem? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.stream = stream
        self.isDefault = isDefault
        self.operatorItem = operatorItem
    }
    
    static func new<T>() -> StreamModel<T> {
        StreamModel<T>()
    }
}

struct StreamItem<T: Codable>: Codable {
    let value: T
    var operatorItem: OperatorItem? = nil
}

enum OperatorType: String, Codable {
    case delay
    case filter
    case drop
    case map
}

class OperatorItem: Codable {
    let type: OperatorType
    let value: Double?
    var next: OperatorItem?
    let expression: String?
    
    init(type: OperatorType, value: Double? = nil, expression: String? = nil, next: OperatorItem? = nil) {
        self.type = type
        self.value = value
        self.next = next
        self.expression = expression
    }
    
}
