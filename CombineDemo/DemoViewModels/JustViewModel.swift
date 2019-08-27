//
//  JustViewModel.swift
//  CombineDemo
//
//  Created by Kevin Minority on 8/19/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine
class JustViewModel: StreamViewModel<String> {
    
    init() {        
        super.init(title: "Just(\"A\")", publisher: Just("A").eraseToAnyPublisher())
    }
    
}
