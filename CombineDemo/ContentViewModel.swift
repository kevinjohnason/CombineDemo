//
//  ContentViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/30/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    
    @Published var storedStreams: [StreamModel<String>] = DataService.shared.storedStreams {
        didSet {
            DataService.shared.storedStreams = self.storedStreams
        }
    }
             
    var streamAModel: StreamModel<String> {
        storedStreams.first(where: { $0.isDefault }) ?? StreamModel<String>.new()
    }
    
    var streamBModel: StreamModel<String> {
        storedStreams.last(where: { $0.isDefault }) ?? StreamModel<String>.new()
    }
    
    var streamA: AnyPublisher<String, Never> {
        streamAModel.toPublisher()
    }
    
    var streamB: AnyPublisher<String, Never> {
        streamBModel.toPublisher()
    }
    
    var cancellable: Cancellable?
    
    init() {
        cancellable = $storedStreams.sink { (newValues) in
            DataService.shared.storedStreams = newValues
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
