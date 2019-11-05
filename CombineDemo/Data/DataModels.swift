//
//  DataModels.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/30/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine
struct StreamModel<T: Codable>: Codable, Identifiable {
    var id: UUID
    var name: String?
    var description: String?
    var stream: [StreamItem<T>]
    var isDefault: Bool
    
    init(id: UUID = UUID(), name: String? = nil, description: String? = nil, stream: [StreamItem<T>] = [], isDefault: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.stream = stream
        self.isDefault = isDefault
    }
    
    static func new<T>() -> StreamModel<T> {
        StreamModel<T>()
    }
}

struct StreamItem<T: Codable>: Codable {
    let value: T
    var operatorItem: Operator<T>?
}

struct OperationStreamModel: Codable, Identifiable {
    var id: UUID
    var name: String?
    var description: String?
    var streamModelId: UUID
    var operatorItem: Operator<String>
}

enum GroupOperationType: String, Codable {
    case merge
    case flatMap
    case append
}

enum CombineGroupOperationType: String, Codable {
    case zip
    case combineLatest
}

struct GroupOperationStreamModel: Codable, Identifiable {
    var id: UUID
    var name: String?
    var description: String?
    var streamModelIds: [UUID]
    var operationType: GroupOperationType
}

struct CombineGroupOperationStreamModel: Codable, Identifiable {
    var id: UUID
    var name: String?
    var description: String?
    var streamModelIds: [UUID]
    var operatorType: CombineGroupOperationType
}

indirect enum Operator<T: Codable>: Codable {
    
    private struct DelayParameters: Codable {
        let seconds: Double
        let next: Operator?
    }
    case delay(seconds: Double, next: Operator?)
    
    private struct ExpressionParameters: Codable {
           let expression: String
           let next: Operator?
    }
    case filter(expression: String, next: Operator?)
    
    private struct DropFirstParameters: Codable {
        let count: Int
        let next: Operator?
    }
    case dropFirst(count: Int, next: Operator?)

    case map(expression: String, next: Operator?)
    
    case scan(expression: String, next: Operator?)
    
    enum CodingKeys: CodingKey {
        case delay
        case filter
        case dropFirst
        case map
        case scan
    }
    
    enum CodingError: Error { case decoding(String) }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let delayParameters = try? container.decodeIfPresent(DelayParameters.self, forKey: .delay) {
            self = .delay(seconds: delayParameters.seconds, next: delayParameters.next)
          return
        } else if let filterParameters = try? container.decodeIfPresent(ExpressionParameters.self, forKey: .filter) {
            self = .filter(expression: filterParameters.expression, next: filterParameters.next)
          return
        } else if let dropFirstParameters = try? container.decodeIfPresent(DropFirstParameters.self, forKey: .dropFirst) {
            self = .dropFirst(count: dropFirstParameters.count, next: dropFirstParameters.next)
          return
        } else if let mapParameters = try? container.decodeIfPresent(ExpressionParameters.self, forKey: .map) {
            self = .map(expression: mapParameters.expression, next: mapParameters.next)
        } else if let scanParameters = try? container.decodeIfPresent(ExpressionParameters.self, forKey: .scan) {
            self = .scan(expression: scanParameters.expression, next: scanParameters.next)
        }
        throw CodingError.decoding("Decoding Failed. \(dump(container))")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .delay(let seconds, let next):
            try container.encode(DelayParameters(seconds: seconds, next: next), forKey: .delay)
        case .filter(let expression, let next):
            try container.encode(ExpressionParameters(expression: expression, next: next), forKey: .delay)
        case .dropFirst(let count, let next):
            try container.encode(DropFirstParameters(count: count, next: next), forKey: .dropFirst)
        case .map(let expression, let next):
            try container.encode(ExpressionParameters(expression: expression, next: next), forKey: .map)
        case .scan(let expression, let next):
            try container.encode(ExpressionParameters(expression: expression, next: next), forKey: .scan)
        }
    }
    
}

extension Operator {
    
    var description: String {
        switch self {
        case .delay(let seconds, _):
            return ".delay(for: .seconds(\(seconds)), scheduler: DispatchQueue.main)"
        case .filter(let expression, _):
            return ".filter { \(expression) }"
        case .dropFirst(let count, _):
            return ".dropFirst(\(count))"
        case .map(let expression, _):
            return ".map { \(expression) }"
        case .scan(let expression, _):
            return ".scan(0) { \(expression) }"
        }
    }
    
    func applyPublisher(_ publisher: AnyPublisher<T, Never>) -> AnyPublisher<T, Never> {
        switch self {
        case .delay(let seconds, _):
            return publisher.delay(for: .seconds(seconds), scheduler: DispatchQueue.main).eraseToAnyPublisher()
        case .filter(let expression, _):
            return publisher.filter {
                NSPredicate(format: expression,
                            argumentArray: [$0])
                .evaluate(with: nil) }.eraseToAnyPublisher()
        case .dropFirst(let count, _):
            return publisher.dropFirst(count).eraseToAnyPublisher()
        case .map(let expression, _):
            return publisher.map { NSExpression(format: expression,
                                                argumentArray: [$0])
                
                .expressionValue(with: nil, context: nil) }
                .map { $0 as? T }
                .filter {  $0 != nil }
                // swiftlint:disable:next force_cast
                .map { $0! }
                .eraseToAnyPublisher()
        case .scan(let expression, _):
            return publisher.scan(0) { NSExpression(format: expression,
                                                    argumentArray: [$0, $1])
                                        .expressionValue(with: nil, context: nil) }                                
                .map { $0 as? T }
                .filter { $0 != nil }
                // swiftlint:disable:next force_cast
                .map { $0! }
                .eraseToAnyPublisher()
        }
    }
    
    var next: Operator? {
        switch self {
        case .delay(_, let next):
            return next
        case .filter(_, let next):
            return next
        case .dropFirst(_, let next):
            return next
        case .map(_, let next):
            return next
        case .scan(_, let next):
            return next
        }
    }
}
