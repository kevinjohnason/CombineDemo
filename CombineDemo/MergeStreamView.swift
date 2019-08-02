//
//  MergeStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/2/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct MergeStreamView: View {
    
    let numberPublisher = CombineService.shared.commonPublisher
    let letterPublisher = CombineService.shared.serialLetterPublisher()
    let mergesPublisher: AnyPublisher<String, Error>
    
    init() {
        mergesPublisher = Publishers.Merge(numberPublisher, letterPublisher).eraseToAnyPublisher()
    }
    
    var body: some View {
        VStack {
            SingleStreamView(viewModel: SingleStreamViewModel(publisher: numberPublisher))
            SingleStreamView(viewModel: SingleStreamViewModel(publisher: letterPublisher), color: .red)
            Spacer(minLength: 80)
            SingleStreamView(viewModel: SingleStreamViewModel(publisher: self.mergesPublisher), color: .yellow)
        }
    }
}

#if DEBUG
struct MergeStreamView_Previews: PreviewProvider {
    static var previews: some View {
        MergeStreamView()
    }
}
#endif
