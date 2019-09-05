//
//  CombineService.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine

class CombineService {
    static let shared = CombineService()
    
    lazy var commonPublisher: AnyPublisher<String, Never> = self.serialNumberPublisher(seconds: 1)
    
    var savedStreamPublisher: AnyPublisher<String, Never> {
        DataService.shared.currentStream.toPublisher()
    }
    
    func serialNumberPublisher() -> AnyPublisher<String, Never> {
        return Publishers.Sequence(sequence: 1...4).map { String($0) }.eraseToAnyPublisher()
    }
    
    func serialNumberPublisher(seconds: Double) -> AnyPublisher<String, Never> {
        return interval([1, 2, 3, 4], seconds: seconds).map { String($0) }.eraseToAnyPublisher()
    }
    
    func serialLetterPublisher() -> AnyPublisher<String, Never> {
        return Publishers.Sequence(sequence: ["A", "B", "C", "D"]).eraseToAnyPublisher()
    }
    
    func serialLetterPublisher(seconds: Double) -> AnyPublisher<String, Never> {
        return interval(["A", "B", "C", "D"], seconds: seconds).eraseToAnyPublisher()
    }
    
    func interval<T>(_ arr: [T], seconds: Double) -> AnyPublisher<T, Never> {
        let intervalPublishers = arr.map { Just($0).delay(for: .seconds(seconds), scheduler: DispatchQueue.main).eraseToAnyPublisher() }
        
        var publisher: AnyPublisher<T, Never>?
        
        for intervalPublisher in intervalPublishers {
            if publisher == nil {
                publisher = intervalPublisher
                continue
            }
            publisher = publisher?.append(intervalPublisher).eraseToAnyPublisher()
        }
        return publisher!
    }
    
}


// Not Cancellable
class SerialNumberPublisher: Publisher {
    static func == (lhs: SerialNumberPublisher, rhs: SerialNumberPublisher) -> Bool {
        return true
    }
    typealias Output = Int
    
    typealias Failure = Never
    
    let numbers: [Int] = [1, 2, 3, 4]
    
    func receive<S>(subscriber: S) where S : Subscriber, SerialNumberPublisher.Failure == S.Failure, SerialNumberPublisher.Output == S.Input {
        numbers.enumerated().forEach { (arg) in
            let (offset, element) = arg
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(offset * 2)) {
                let test = subscriber.receive(element)
                Swift.print(test)
                if offset >= self.numbers.count {
                    subscriber.receive(completion: .finished)
                }
            }                        
        }
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
    
    func toPublisher()  -> AnyPublisher<String, Never>  {
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

extension StreamModel where T == String {
    
    func applyOperationPublisher() -> AnyPublisher<String, Never> {                
        guard let operatorItem = self.operatorItem else {
            return toPublisher()
        }
        return operatorItem.applyPublisher(toPublisher())
    }
    
}

extension StreamItem where T == String {
    func toPublisher()  -> AnyPublisher<String, Never>  {
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

extension OperatorItem  {
    
    func applyPublisher(_ publisher: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
        switch self.type {
        case .delay:
            return publisher.delay(for: .seconds(self.value ?? 0), scheduler: DispatchQueue.main).eraseToAnyPublisher()
        case .filter:
            return publisher.filter { NSPredicate(format: self.expression ?? "true",
                                                  argumentArray: [$0, String(Int(self.value ?? 0))]).evaluate(with: nil) }.eraseToAnyPublisher()
        case .drop:
            return publisher.dropFirst(Int(self.value ?? 0)).eraseToAnyPublisher()
        case .map:
            return publisher.map { NSExpression(format: self.expression ?? "0", argumentArray: [Int($0) ?? 0, Int(self.value ?? 0)]).expressionValue(with: nil, context: nil) as? Int }.map { String($0 ?? 0) }.eraseToAnyPublisher()
        }
    }
}
