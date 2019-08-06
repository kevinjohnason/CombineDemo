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
    
    init(title: String, publisher: AnyPublisher<String, Never>) {
        self.title = title
        objectWillChange = objectWillChangeSubject.eraseToAnyPublisher()
        self.publisher = publisher
    }
    
    func reset(text: String) -> AnyPublisher<String, Never> {
        return Future<String, Never> {[weak self] future in
            self?.text = text
            self?.percent = 0
            self?.objectWillChangeSubject.send(())
            future(.success(text))
        }.eraseToAnyPublisher()
    }
    
    func start(text: String) -> AnyPublisher<String, Never> {
        return Future<String, Never> {[weak self] future in
             self?.percent = 1
             self?.objectWillChangeSubject.send(())
             future(.success(text))
         }.eraseToAnyPublisher()
    }
    
    func subscribe() {
        self.cancellable = publisher.flatMap {
            self.reset(text: $0)
        }.delay(for: 0.2, scheduler: DispatchQueue.main)
        .flatMap {
            self.start(text: $0)
        }.delay(for: 1.6, scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { (error) in
                
            }) {
                self.previousTexts.append($0)
                self.objectWillChangeSubject.send(())
        }
    }
    
    func cancel() {
        self.cancellable?.cancel()
        self.percent = 0
        self.previousTexts.removeAll()
        self.objectWillChangeSubject.send(())
    }
    
}
