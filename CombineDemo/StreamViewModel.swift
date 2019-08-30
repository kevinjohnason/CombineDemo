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
    
    var title: String
    var description: String
    var publisher: AnyPublisher<T, Never>
    @Published var values: [TimeSeriesValue<T>] = []
    let animationSeconds: Double = 1.5
    var cancellable: Cancellable? = nil
    
    init(title: String, description: String = "", publisher: AnyPublisher<T, Never>) {
        self.title = title
        self.description = description
        self.publisher = publisher
    }
    
    func subscribe() {
        cancellable = publisher
            .sink(receiveValue: { [weak self] (value) in
                self?.values.append(TimeSeriesValue(value: value))
            })
    }
    
    func cancel() {
        self.cancellable?.cancel()
        self.values.removeAll()
    }
    
}


struct TimeSeriesValue<T>: Identifiable {
    var value: T
    var id: Date
    
    init(value: T) {
        self.id = Date()
        self.value = value
    }
}
