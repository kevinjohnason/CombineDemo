//
//  DoubleStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/7/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct DoubleStreamView: View {
    let streamViewModel1: StreamViewModel<String>
    let streamViewModel2: StreamViewModel<String>
                
    init(streamModel: StreamModel<String>, operatorTitle: String, publisher: AnyPublisher<String, Never>,  convertingPublisher: (AnyPublisher<String, Never>) -> AnyPublisher<String, Never>) {
        
        streamViewModel1 = DynamicStreamViewModel(streamModel: streamModel)
        streamViewModel2 = StreamViewModel(title: operatorTitle, description: operatorTitle, publisher: convertingPublisher(publisher))
    }
    
    var body: some View {
        VStack {
            SingleStreamView(viewModel: streamViewModel1, displayActionButtons: false)
            SingleStreamView(viewModel: streamViewModel2, color: .red, displayActionButtons: false)
            HStack {
                CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                    self.streamViewModel1.subscribe()
                    self.streamViewModel2.subscribe()
                }
                CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                    self.streamViewModel1.cancel()
                    self.streamViewModel2.cancel()
                }
            }.padding()
        }
    }
}

#if DEBUG
struct DoubleStreamView_Previews: PreviewProvider {
    static var previews: some View {
        DoubleStreamView(streamModel: StreamModel<String>.new(), operatorTitle: "", publisher: Just("").eraseToAnyPublisher()) { (_) -> AnyPublisher<String, Never> in
            Just("").eraseToAnyPublisher()
        }
    }
}
#endif
