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


class StreamViewModel<T>: ObservableObject {
    
    let title: String
    let publisher: AnyPublisher<T, Never>
    @Published var values: [T] = []
    let animationSeconds: Double = 1.5
    var cancellable: Cancellable? = nil
    
    init(title: String, publisher: AnyPublisher<T, Never>) {
        self.title = title
        self.publisher = publisher
    }
    
    func subscribe() {
        cancellable = publisher
            .sink(receiveValue: { [weak self] (value) in
                self?.values.append(value)
            })
    }
    
    func cancel() {
        self.cancellable?.cancel()
        self.values.removeAll()
    }
    
}
