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
    
    init(streamOptions: [BallViewModel]) {
        self.streamOptions = streamOptions        
    }
}
