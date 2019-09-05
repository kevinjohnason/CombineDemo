//
//  DynamicStreamViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/28/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation

class DynamicStreamViewModel: StreamViewModel<String> {
    
    let streamId: UUID
    
    var streamModel: StreamModel<String> {
        didSet {
            self.title = self.streamModel.name ?? ""
            self.description = self.streamModel.description ?? ""
            self.publisher = self.streamModel.toPublisher()
        }
    }
    
    convenience init(streamId: UUID) {
        let streamModel = DataService.shared.loadStream(id: streamId)
        self.init(streamModel: streamModel)
    }
    
    init(streamModel: StreamModel<String>) {
        self.streamId = streamModel.id
        self.streamModel = streamModel
        super.init(title: streamModel.name ?? "", description: streamModel.description ?? "",
                   publisher: self.streamModel.toPublisher())
    }
        
}
