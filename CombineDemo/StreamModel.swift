//
//  StreamModel.swift
//  CombineDemo
//
//  Created by Kevin Minority on 8/26/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine

struct StreamModel {
    let title: String
    let items: [String]
}

extension StreamModel {
    
    func toViewModel() -> StreamViewModel<String> {
        StreamViewModel(title: self.title, publisher: CombineService.shared.interval(self.items, seconds: 1))
    }
}
