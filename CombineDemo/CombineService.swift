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
    
    lazy var commonPublisher: AnyPublisher<String, Never> = self.serialNumberPublisher()
    
    func customSerialNumberPublisher() -> AnyPublisher<Int, Never> {
        SerialNumberPublisher().eraseToAnyPublisher()
    }
    
    func serialNumberPublisher() -> AnyPublisher<String, Never> {
        return Publishers.Sequence(sequence: 1...4).map { String($0) }.eraseToAnyPublisher()
    }
        
    func serialLetterPublisher() -> AnyPublisher<String, Never> {
        return Publishers.Sequence(sequence: ["A", "B", "C", "D"]).eraseToAnyPublisher()
    }
    
    func interval<T>(arr: [T], seconds: Double) -> AnyPublisher<T, Never> {
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

