//
//  UpdateStreamViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/27/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import SwiftUI

class UpdateStreamViewModel: ObservableObject {
    
    @Published var streamOptions: [BallViewModel]    
    
    @Published var streamName: String
    
    @Published var values: [TimeSeriesValue<String>]
    
    init() {
        self.streamOptions = (1...8).map { BallViewModel(value: String($0)) }
        let stream = DataService.shared.currentStream        
        self.streamName = stream.name
        self.values = stream.stream.map {
            TimeSeriesValue(value: $0.value)
        }
    }
    
    func save() {
        DataService.shared.currentStream =
        StreamModel<String>(name: streamName, stream: values.map {
            StreamItem(value: $0.value)
        })        
    }
    
}
