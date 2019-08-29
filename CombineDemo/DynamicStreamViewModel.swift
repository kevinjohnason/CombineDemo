//
//  DynamicStreamViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/28/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation

class DynamicStreamViewModel<T: Codable>: StreamViewModel<T> {
    init(streamModel: StreamModel<T>) {
        super.init(title: streamModel.name, publisher: streamModel.toPublisher())
    }    
}
