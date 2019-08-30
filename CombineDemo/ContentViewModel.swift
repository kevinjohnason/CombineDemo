//
//  ContentViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/30/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation

class ContentViewModel {
    
    let streamAModel = DataService.shared.storedStreams.first(where: { $0.isDefault }) ?? StreamModel<String>.new()
    
    let streamBModel = DataService.shared.storedStreams.last(where: { $0.isDefault }) ?? StreamModel<String>.new()
    
    lazy var streamA = streamAModel.toPublisher()
    
    lazy var streamB = streamBModel.toPublisher()
    
}
