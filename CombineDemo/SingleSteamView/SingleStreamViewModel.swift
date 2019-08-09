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
    let objectWillChange: PassthroughSubject<Void, Never> =
                    PassthroughSubject<Void, Never>()
    let publisher: AnyPublisher<String, Never>
    let animationSeconds: Double = 1.5
    var percent: CGFloat = 0
    var text: String = ""
    var userCancellable: Cancellable? = nil
    var previousTexts: [String] = []
    var showHistory: Bool = true            
    var displayCancellable: Cancellable? = nil
    @Published var animatingValues: [String] = []
    var animationCancellable: Cancellable? = nil
    
    init(title: String, publisher: AnyPublisher<String, Never>) {
        self.title = title
        self.publisher = publisher
    }
    
    func setupAnimationSubscriber() {
        animationCancellable =
            $animatingValues
            .throttle(for: .seconds(0.1), scheduler: DispatchQueue.main, latest: true)
            .filter { $0.count > 0 }
            .flatMap { self.reset(texts: $0) }
            .delay(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .flatMap { self.start(texts: $0) }
            .delay(for: .seconds(animationSeconds), scheduler: DispatchQueue.main)
            .flatMap { self.finish(texts: $0) }
            .eraseToAnyPublisher()
            .assign(to:\SingleStreamViewModel.animatingValues, on: self)
    }
    
    func reset(texts: [String]) -> AnyPublisher<[String], Never> {
        return Future<[String], Never> {[weak self] future in
            self?.text = texts[0]
            self?.percent = 0
            self?.objectWillChange.send(())
            future(.success(texts))
        }.eraseToAnyPublisher()
    }
    
    func start(texts: [String]) -> AnyPublisher<[String], Never> {
        return Future<[String], Never> {[weak self] future in
             self?.percent = 1
             self?.objectWillChange.send(())
            future(.success(texts))
            }.eraseToAnyPublisher()
    }
    
    func finish(texts: [String]) -> AnyPublisher<[String], Never> {
        return Future<[String], Never> {[weak self] future in
            self?.previousTexts.append(texts[0])
            var newTexts = texts
            newTexts.removeFirst(1)
            self?.objectWillChange.send(())
            future(.success(newTexts))
            }.eraseToAnyPublisher()
    }
    
        
    func subscribe() {
        setupAnimationSubscriber()
        userCancellable =
            publisher
                .map {
                    var animatingValues = self.animatingValues
                    animatingValues.append($0)
                    return animatingValues
            }.assign(to:\SingleStreamViewModel.animatingValues, on: self)
    }
    
    func cancel() {
        self.animationCancellable?.cancel()
        self.userCancellable?.cancel()
        self.percent = 0
        self.previousTexts.removeAll()
        self.animatingValues.removeAll()
        self.objectWillChange.send(())
    }
    
}
