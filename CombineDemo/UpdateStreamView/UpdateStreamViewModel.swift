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
        self.streamName = ""
        self.values = []
    }
}
