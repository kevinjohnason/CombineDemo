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
    
    @Published var streamDescription: String
    
    @Published var values: [TimeSeriesValue<String>]
    
    let streamModel: StreamModel<String>
    
    init(streamModel: StreamModel<String>) {
        self.streamModel = streamModel
        self.streamOptions = (1...8).map { BallViewModel(value: String($0)) }
        self.streamName = streamModel.name
        self.streamDescription = streamModel.description ?? ""
        self.values = streamModel.stream.map {
            TimeSeriesValue(value: $0.value)
        }
    }
    
    func save() {               
        let newStream = values.map {
            StreamItem(value: $0.value, delay: 1)
        }
        var storedStreams = DataService.shared.storedStreams
                        
        if let storedStreamIndex = storedStreams.firstIndex(where: { $0.id == self.streamModel.id }) {
            var updatingStoredStream = storedStreams[storedStreamIndex]
            updatingStoredStream.description = streamDescription
            updatingStoredStream.name = streamName
            updatingStoredStream.stream = newStream
            storedStreams[storedStreamIndex] = updatingStoredStream
        } else {
            let newStreamModel =
                 StreamModel<String>(name: streamName, description: streamDescription, stream: newStream)
            storedStreams.append(newStreamModel)
        }
        DataService.shared.storedStreams = storedStreams
    }
    
}
