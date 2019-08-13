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
    var cancellable: Cancellable? = nil
    var values: [String] = []
    var showHistory: Bool = true
    
    init(title: String, publisher: AnyPublisher<String, Never>) {
        self.title = title
        self.publisher = publisher
    }
        
    func subscribe() {
        cancellable =
                publisher
                    .sink(receiveValue: { [weak self] (value) in
                        self?.values.append(value)
                        self?.objectWillChange.send(())
                    })
    }
    
    func cancel() {
        self.cancellable?.cancel()
        self.values.removeAll()
        self.objectWillChange.send(())
    }
    
}
