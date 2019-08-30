//
//  DynamicStreamViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/28/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation

class DynamicStreamViewModel: StreamViewModel<String> {
    
    var streamModel: StreamModel<String> {
        didSet {
            self.title = streamModel.name
            self.description = streamModel.description ?? ""
            self.publisher = streamModel.toPublisher()
        }
    }
    
    init(streamModel: StreamModel<String>) {
        self.streamModel = streamModel
        super.init(title: streamModel.name, description: streamModel.description ?? "", publisher: streamModel.toPublisher())        
    }
    
    func update() {
        guard let newStream = DataService.shared.storedStreams.first(where: {
            $0.id == self.streamModel.id
        }) else {
            return
        }         
        self.streamModel = newStream
    }
}
