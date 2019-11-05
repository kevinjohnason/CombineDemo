//
//  CombineService.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine

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
