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
    
    func customSerialNumberPublisher() -> AnyPublisher<Int, Error> {
        SerialNumberPublisher().eraseToAnyPublisher()
    }
    
    func intervalSerialNumberPublisher() -> AnyPublisher<Int, Error> {
        let publisher1 = Just(1).tryMap { $0 }.delay(for: 0, scheduler: DispatchQueue.main)
        let publisher2 = Just(2).tryMap { $0 }.delay(for: 2, scheduler: DispatchQueue.main)
        let publisher3 = Just(3).tryMap { $0 }.delay(for: 4, scheduler: DispatchQueue.main)
        let publisher4 = Just(4).tryMap { $0 }.delay(for: 6, scheduler: DispatchQueue.main)
        return Publishers.MergeMany([publisher1, publisher2, publisher3, publisher4]).tryMap { $0 }.eraseToAnyPublisher()
    }
    
    
}


// Not Cancellable
class SerialNumberPublisher: Publisher {
    static func == (lhs: SerialNumberPublisher, rhs: SerialNumberPublisher) -> Bool {
        return true
    }
    typealias Output = Int
    
    typealias Failure = Error
    
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

