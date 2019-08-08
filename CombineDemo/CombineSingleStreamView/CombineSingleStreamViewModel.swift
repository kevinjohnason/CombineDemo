//
//  CombineSingleStreamViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/8/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class CombineSingleStreamViewModel: ObservableObject {
    let title: String
    let objectWillChange: AnyPublisher<Void, Never>
    let objectWillChangeSubject = PassthroughSubject<Void, Never>()
    let publisher: AnyPublisher<(String, String), Never>
    let animationSeconds: Double = 1.5
    var percent: CGFloat = 0
    @Published var text: (String, String) = ("", "")
    var text1: String = ""
    var text2: String = ""
    var userCancellable: Cancellable? = nil
    var previousTexts: [(String, String)] = []
    var showHistory: Bool = true
    var displayCancellable: Cancellable? = nil
    @Published var animatingValues: [(String, String)] = []
    var animationCancellable: Cancellable? = nil
    
    
    var text1Cancellable: Cancellable? = nil
    
    var text2Cancellable: Cancellable? = nil
    
    init(title: String, publisher: AnyPublisher<(String, String), Never>) {
        self.title = title
        objectWillChange = objectWillChangeSubject.eraseToAnyPublisher()
        self.publisher = publisher
        text1Cancellable =
        $text.map { $0.0 }
            .assign(to: \CombineSingleStreamViewModel.text1, on: self)
        text2Cancellable =
        $text.map { $0.1 }
            .assign(to: \CombineSingleStreamViewModel.text2, on: self)
        
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
                .assign(to:\CombineSingleStreamViewModel.animatingValues, on: self)
    }
    
    func reset(texts: [(String, String)]) -> AnyPublisher<[(String, String)], Never> {
        return Future<[(String, String)], Never> {[weak self] future in
            self?.text = texts[0]
            self?.percent = 0
            self?.objectWillChangeSubject.send(())
            future(.success(texts))
        }.eraseToAnyPublisher()
    }
    
    func start(texts: [(String, String)]) -> AnyPublisher<[(String, String)], Never> {
        return Future<[(String, String)], Never> {[weak self] future in
            self?.percent = 1
            self?.objectWillChangeSubject.send(())
            future(.success(texts))
        }.eraseToAnyPublisher()
    }
    
    func finish(texts: [(String, String)]) -> AnyPublisher<[(String, String)], Never> {
        return Future<[(String, String)], Never> {[weak self] future in
            self?.previousTexts.append(texts[0])
            var newTexts = texts
            newTexts.removeFirst(1)
            self?.objectWillChangeSubject.send(())
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
            }.assign(to:\CombineSingleStreamViewModel.animatingValues, on: self)
    }
    
    func cancel() {
        self.animationCancellable?.cancel()
        self.userCancellable?.cancel()
        self.percent = 0
        self.previousTexts.removeAll()
        self.animatingValues.removeAll()
        self.objectWillChangeSubject.send(())
    }
    
}
