//
//  UpdateStreamViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/27/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import SwiftUI

extension ClosedRange where Bound == Unicode.Scalar {
    static let asciiPrintable: ClosedRange = " "..."~"
    var range: ClosedRange<UInt32>  { return lowerBound.value...upperBound.value }
    var scalars: [Unicode.Scalar]   { return range.compactMap(Unicode.Scalar.init) }
    var characters: [Character]     { return scalars.map(Character.init) }
    var string: String              { return String(scalars) }
}

extension String {
    init<S: Sequence>(_ sequence: S) where S.Element == Unicode.Scalar {
        self.init(UnicodeScalarView(sequence))
    }
}


class UpdateStreamViewModel: ObservableObject {
    
    @Published var streamNumberOptions: [BallViewModel]
    
    @Published var streamLetterOptions: [BallViewModel]
        
    @Published var streamName: String
    
    @Published var streamDescription: String
    
    @Published var values: [TimeSeriesValue<String>]
    
    let streamModel: StreamModel<String>
    
    init(streamModel: StreamModel<String>) {
        self.streamModel = streamModel
        self.streamNumberOptions = (1...8).map {
            print("generating \($0)")
            return BallViewModel(value: String($0))
        }
        self.streamLetterOptions = ("A"..."H").characters.map {
            print("generating \($0)")
            return BallViewModel(value: String($0))
        }
        self.streamName = streamModel.name
        self.streamDescription = streamModel.description ?? ""
        self.values = streamModel.stream.map {
            print("adding \($0.value) to tunnel")
            return TimeSeriesValue(value: $0.value)
        }
    }
    
    func save() {               
        let newStream = values.map {
            StreamItem(value: $0.value, operatorItem: OperatorItem(type: .delay, value: 1))
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
                StreamModel<String>(id: UUID(), name: streamName, description: streamDescription, stream: newStream)
            storedStreams.append(newStreamModel)
        }
        DataService.shared.storedStreams = storedStreams
    }
    
}
