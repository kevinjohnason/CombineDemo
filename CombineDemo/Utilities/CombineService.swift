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


extension StreamModel where T: Codable {
    
    func toPublisher()  -> AnyPublisher<T, Never>  {
        let intervalPublishers =
            self.stream.map { $0.toPublisher() }
        
        var publisher: AnyPublisher<T, Never>?
        
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

extension StreamItem where T: Codable {
    func toPublisher()  -> AnyPublisher<T, Never>  {
        var publisher: AnyPublisher<T, Never> = Just(value).eraseToAnyPublisher()
        var currentOperator = self.operatorItem
        while currentOperator != nil {
            guard let loopOperator = currentOperator else {
                break
            }
            switch loopOperator.type {
            case .delay:
                publisher = publisher.delay(for: .seconds(loopOperator.value ?? 0), scheduler: DispatchQueue.main).eraseToAnyPublisher()
            default:
                break
            }
            currentOperator = loopOperator.next
        }
        
        return publisher
    }
}