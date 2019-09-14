//
//  CombineService.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine

extension StreamModel {
    
    func toArrayStreamModel() -> StreamModel<[T]> {
        StreamModel<[T]>.init(id: self.id, name: self.name, description: self.description,
                              stream: self.stream.map { StreamItem(value: [$0.value], operatorItem: $0.operatorItem) },
                              isDefault: self.isDefault)
    }
    
}

extension StreamModel where T == String {
    
    var sequenceDescription: String {
        var desc = self.stream.reduce("Sequence(") {
            "\($0)\($1.value), "
        }
        guard let finalDotIndex = desc.lastIndex(of: ",") else {
            return "Empty()"
        }
        desc.removeSubrange(finalDotIndex..<desc.endIndex)
        desc.append(")")
        return desc
    }
    
    func toPublisher()  -> AnyPublisher<String, Never> {
        let intervalPublishers =
            self.stream.map { $0.toPublisher() }
        
        var publisher: AnyPublisher<String, Never>?
        
        for intervalPublisher in intervalPublishers {
            if publisher == nil {
                publisher = intervalPublisher
                continue
            }
            publisher = publisher?.append(intervalPublisher).eraseToAnyPublisher()
        }
        
        return publisher ?? Empty().eraseToAnyPublisher()
    }
    
}

extension StreamItem where T == String {
    func toPublisher()  -> AnyPublisher<String, Never> {
        var publisher: AnyPublisher<String, Never> = Just(value).eraseToAnyPublisher()
        var currentOperator = self.operatorItem
        while currentOperator != nil {
            guard let loopOperator = currentOperator else {
                break
            }
            publisher = loopOperator.applyPublisher(publisher)
            currentOperator = loopOperator.next
        }
        return publisher
    }
}

extension OperatorItem {
    var description: String {
        switch self.type {
        case .delay:
            return ".delay(for: .seconds(\(self.value ?? 0)), scheduler: DispatchQueue.main)"
        case .filter:
            return ".filter { $0 != \(self.value ?? 0) }"
        case .drop:
            return ".dropFirst(\(Int(self.value ?? 0)))"
        case .map:
            return ".map { $0 * \(Int(self.value ?? 0)) }"
        case .scan:
            return ".scan(0) { $0 + $1 }"
        }
    }
        
    func applyPublisher(_ publisher: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
        switch self.type {
        case .delay:
            return publisher.delay(for: .seconds(self.value ?? 0), scheduler: DispatchQueue.main).eraseToAnyPublisher()
        case .filter:
            return publisher.filter {
                NSPredicate(format: self.expression ?? "true",
                            argumentArray: [$0, String(Int(self.value ?? 0))])
                .evaluate(with: nil) }.eraseToAnyPublisher()
        case .drop:
            return publisher.dropFirst(Int(self.value ?? 0)).eraseToAnyPublisher()
        case .map:
            return publisher.map { NSExpression(format: self.expression ?? "0",
                                                argumentArray: [Int($0) ?? 0, Int(self.value ?? 0)])
                .expressionValue(with: nil, context: nil) as? Int }
                .map { String($0 ?? 0) }.eraseToAnyPublisher()
        case .scan:
            return publisher.scan(0) { NSExpression(format: self.expression ?? "0",
                                                    argumentArray: [$0, Int($1) ?? 0])
                                        .expressionValue(with: nil, context: nil) as? Int ?? 0 }
                .map { String($0) }.eraseToAnyPublisher()
        }
    }
}

extension GroupOperationType {
    func applyPublishers(_ publishers: [AnyPublisher<String, Never>]) -> AnyPublisher<String, Never> {
        switch self {
        case .merge:
            return Publishers.MergeMany(publishers).eraseToAnyPublisher()
        case .flatMap:
            let initialPublisher: AnyPublisher<String, Never> = Just("").eraseToAnyPublisher()
            return publishers.reduce(initialPublisher) { (initial, next) -> AnyPublisher<String, Never> in
                initial.flatMap { _ in
                     next
                }.eraseToAnyPublisher()
            }
        case .append:
            guard let initialPublisher = publishers.first else {
                return Empty().eraseToAnyPublisher()
            }
            return publishers[1...].reduce(initialPublisher) {
                $0.append($1).eraseToAnyPublisher()
            }
        }
    }
}

extension CombineGroupOperationType {
    func applyPublishers(_ publishers: [AnyPublisher<String, Never>]) -> AnyPublisher<[String], Never> {
        guard publishers.count > 1 else {
            return Empty().eraseToAnyPublisher()
        }
        switch self {
        case .zip:
            return Publishers.Zip(publishers[0], publishers[1]).map {
                [$0, $1]
            }.eraseToAnyPublisher()
        case .combineLatest:
            return Publishers.CombineLatest(publishers[0], publishers[1]).map {
                [$0, $1]
            }.eraseToAnyPublisher()
        }
    }
}