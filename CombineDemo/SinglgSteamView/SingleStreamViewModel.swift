//
//  SingleStreamViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/1/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class SingleStreamViewModel: ObservableObject {
    
    let title: String
    let objectWillChange: AnyPublisher<Void, Never>
    let objectWillChangeSubject = PassthroughSubject<Void, Never>()
    let publisher: AnyPublisher<String, Never>
    let animationSeconds: Double = 1.5
    var percent: CGFloat = 0
    var text: String = ""
    var cancellable: Cancellable? = nil
    var previousTexts: [String] = []
    var showHistory: Bool = true            
    var displayCancellable: Cancellable? = nil
    let animatingValues: CurrentValueSubject<[String], Never> = CurrentValueSubject([])
    
    var animationCancellable: Cancellable? = nil
    
    init(title: String, publisher: AnyPublisher<String, Never>) {
        self.title = title
        objectWillChange = objectWillChangeSubject.eraseToAnyPublisher()
        self.publisher = publisher
        setupAnimationSubscriber()
    }
    
    func setupAnimationSubscriber() {
        animationCancellable = animatingValues
            .throttle(for: .seconds(0.1), scheduler: DispatchQueue.main, latest: true)
            .filter { $0.count > 0 }
            .flatMap { self.reset(texts: $0) }
            .delay(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .flatMap { self.start(texts: $0) }
            .delay(for: .seconds(animationSeconds), scheduler: DispatchQueue.main)
            .flatMap { self.finish(texts: $0) }
            .sink {
                self.animatingValues.send($0)
            }
    }
    
    func reset(texts: [String]) -> AnyPublisher<[String], Never> {
        return Future<[String], Never> {[weak self] future in
            self?.text = texts[0]
            self?.percent = 0
            self?.objectWillChangeSubject.send(())
            future(.success(texts))
        }.eraseToAnyPublisher()
    }
    
    func start(texts: [String]) -> AnyPublisher<[String], Never> {
        return Future<[String], Never> {[weak self] future in
             self?.percent = 1
             self?.objectWillChangeSubject.send(())
            future(.success(texts))
            }.eraseToAnyPublisher()
    }
    
    func finish(texts: [String]) -> AnyPublisher<[String], Never> {
        return Future<[String], Never> {[weak self] future in
            self?.previousTexts.append(texts[0])
            var newTexts = texts
            newTexts.removeFirst(1)
            self?.objectWillChangeSubject.send(())
            future(.success(newTexts))
            }.eraseToAnyPublisher()
    }
    
        
    func subscribe() {
        self.cancellable = publisher
                            .sink(receiveValue: {
                                var currentAnimatedValues = self.animatingValues.value
                                currentAnimatedValues.append($0)
                                self.animatingValues.send(currentAnimatedValues)
                            })
    }
    
    func cancel() {
        self.cancellable?.cancel()
        self.percent = 0
        self.previousTexts.removeAll()
        self.animatingValues.send([])
        self.objectWillChangeSubject.send(())
    }
    
}
