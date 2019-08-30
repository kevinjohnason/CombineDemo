//
//  CombineResultStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/8/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct CombineResultStreamView: View {
    let operatorPublisher: AnyPublisher<(String, String), Never>
    let numberStreamViewModel: StreamViewModel<String>
    let letterStreamViewModel: StreamViewModel<String>
    let resultStreamViewModel: StreamViewModel<(String, String)>
    
    init(title: String, stream1Id: UUID, stream2Id: UUID, streamOperator: (AnyPublisher<String, Never>, AnyPublisher<String, Never>) -> AnyPublisher<(String, String), Never>) {        
        numberStreamViewModel = DynamicStreamViewModel(streamId: stream1Id)
        letterStreamViewModel = DynamicStreamViewModel(streamId: stream2Id)
        operatorPublisher = streamOperator(numberStreamViewModel.publisher, letterStreamViewModel.publisher)
        resultStreamViewModel = StreamViewModel(title: title, publisher: self.operatorPublisher)
    }
    
    var body: some View {
        VStack {
            SingleStreamView(viewModel: numberStreamViewModel, displayActionButtons: false)
            SingleStreamView(viewModel: letterStreamViewModel, color: .red, displayActionButtons: false)
            Spacer()
            CombineSingleStreamView(viewModel: resultStreamViewModel, displayActionButtons: false)
            
            HStack {
                CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                    self.numberStreamViewModel.subscribe()
                    self.letterStreamViewModel.subscribe()
                    self.resultStreamViewModel.subscribe()
                }
                CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                    self.numberStreamViewModel.cancel()
                    self.letterStreamViewModel.cancel()
                    self.resultStreamViewModel.cancel()
                }
            }.padding()
        }
    }
}

#if DEBUG
struct CombineResultStreamView_Previews: PreviewProvider {
    static var previews: some View {
        CombineResultStreamView(title: "", stream1Id: UUID(), stream2Id: UUID()) { (_, _) -> AnyPublisher<(String, String), Never> in
            return Empty().eraseToAnyPublisher()
        }
    }
}
#endif
